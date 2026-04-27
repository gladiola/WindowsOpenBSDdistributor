<#
.SYNOPSIS
    Downloads selected gladiola GitHub repositories to a USB drive.

.DESCRIPTION
    Queries the GitHub API to discover every public repository owned by
    'gladiola', then lets you choose which ones to download.

    Selection modes (in order of precedence):
      1. -Repos "repo1","repo2"  – non-interactive, download named repos only
      2. Interactive picker      – an Out-GridView window listing all repos;
                                   hold Ctrl/Shift to multi-select, then click OK
      3. -All                    – skip selection and download every repo

    The chosen repos are cloned (or updated if already present) into a folder
    called "gladiola_repos" on the specified USB drive:

        <DriveLetter>:\gladiola_repos\
            <repo1>\
            <repo2>\
            ...

    Git must be installed and available on PATH.  Clones are done over HTTPS
    so no SSH key is required.  No GitHub token is needed to list public
    repositories, but supplying one via -Token raises the API rate limit from
    60 to 5,000 requests per hour and also enables downloading private
    repositories that belong to the token owner.

.PARAMETER DriveLetter
    The drive letter of the USB drive (without colon), e.g. "E".

.PARAMETER Repos
    One or more repository names to download without opening the picker.
    Example: -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"

.PARAMETER All
    Download every repository without opening the picker.

.PARAMETER Token
    Optional GitHub personal access token.  Increases the API rate limit
    and allows access to private repositories owned by the token holder.

.EXAMPLE
    # Interactive picker – choose repos from a GUI list
    .\download_repos.ps1 -DriveLetter E

.EXAMPLE
    # Download specific repos non-interactively
    .\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"

.EXAMPLE
    # Download everything
    .\download_repos.ps1 -DriveLetter E -All

.EXAMPLE
    # With a GitHub token to raise the rate limit
    .\download_repos.ps1 -DriveLetter E -Token ghp_yourTokenHere
#>

[CmdletBinding(DefaultParameterSetName = 'Interactive')]
param (
    [Parameter(Mandatory = $true, HelpMessage = 'USB drive letter (e.g. E)')]
    [ValidatePattern('^[A-Za-z]$')]
    [string]$DriveLetter,

    [Parameter(ParameterSetName = 'Named', Mandatory = $true,
               HelpMessage = 'Names of specific repositories to download')]
    [string[]]$Repos,

    [Parameter(ParameterSetName = 'All', Mandatory = $true,
               HelpMessage = 'Download all repositories without prompting')]
    [switch]$All,

    [Parameter(Mandatory = $false, HelpMessage = 'GitHub personal access token (optional)')]
    [string]$Token = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

$GithubUser = 'gladiola'

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Ensure-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'Git is not installed or not on PATH. ' +
              'Please install Git for Windows from https://git-scm.com/download/win'
    }
}

function Get-UsbRoot {
    param([string]$Letter)

    $root = "$($Letter.ToUpper()):"
    if (-not (Test-Path "$root\")) {
        throw "Drive $root was not found. Make sure the USB drive is plugged in and the letter is correct."
    }
    return $root
}

function Get-AllRepos {
    param(
        [string]$User,
        [string]$AuthToken
    )

    $headers = @{ 'User-Agent' = 'WindowsOpenBSDdistributor' }
    if ($AuthToken -ne '') {
        $headers['Authorization'] = "Bearer $AuthToken"
    }

    $repos = @()
    $page  = 1

    # When a token is supplied use the authenticated endpoint so that private
    # repositories owned by the token holder are included in the results.
    # The public /users/{user}/repos endpoint only returns public repos.
    $useAuthEndpoint = $AuthToken -ne ''

    do {
        if ($useAuthEndpoint) {
            $url = "https://api.github.com/user/repos?visibility=all&affiliation=owner,organization_member&per_page=100&page=$page"
        }
        else {
            $url = "https://api.github.com/users/$User/repos?per_page=100&page=$page"
        }
        $response = @(Invoke-RestMethod -Uri $url -Headers $headers)
        $rawCount = $response.Count
        # When using the authenticated endpoint, keep only repos owned by $User
        if ($useAuthEndpoint) {
            $response = @($response | Where-Object { $_.owner.login -eq $User })
        }
        foreach ($item in $response) { $repos += $item }
        $page++
    } while ($rawCount -eq 100)

    return $repos
}

function Invoke-Git {
    # Run a git command, capture combined stdout+stderr, and throw on failure.
    # This avoids piping 2>&1 through the PowerShell pipeline, which can turn
    # normal git stderr progress lines into terminating errors when
    # $ErrorActionPreference = 'Stop'.
    $out = & git @args 2>&1
    Write-Verbose ($out | Out-String)
    if ($LASTEXITCODE -ne 0) { throw ($out | Out-String).Trim() }
}

function Clone-Or-Update {
    param(
        [string]$Url,
        [string]$DestPath,
        [string]$RepoName
    )

    if (Test-Path (Join-Path $DestPath '.git')) {
        Write-Host "  Updating  $RepoName ..." -ForegroundColor Cyan
        Push-Location $DestPath
        try {
            Invoke-Git fetch --all --prune
            Invoke-Git reset --hard origin/HEAD
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Host "  Cloning   $RepoName ..." -ForegroundColor Cyan
        Invoke-Git clone --progress $Url $DestPath
    }
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

Ensure-Git

$usbRoot   = Get-UsbRoot -Letter $DriveLetter
$targetDir = Join-Path $usbRoot 'gladiola_repos'

if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
    Write-Host "Created $targetDir" -ForegroundColor Green
}

Write-Host "`nFetching repository list for '$GithubUser' from GitHub API ..." -ForegroundColor Cyan
$allRepos = @(Get-AllRepos -User $GithubUser -AuthToken $Token)

if ($allRepos.Count -eq 0) {
    Write-Warning "No public repositories found for '$GithubUser'. Nothing to download."
    exit 0
}

Write-Host "Found $($allRepos.Count) repositories." -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# Selection
# ---------------------------------------------------------------------------

if ($PSCmdlet.ParameterSetName -eq 'Named') {
    # Filter to the names the caller specified
    $selectedRepos = @($allRepos | Where-Object { $Repos -contains $_.name })
    $notFound = $Repos | Where-Object { ($allRepos | ForEach-Object { $_.name }) -notcontains $_ }
    if ($notFound) {
        Write-Warning "The following requested repositories were not found: $($notFound -join ', ')"
    }
    if ($selectedRepos.Count -eq 0) {
        Write-Warning 'None of the specified repository names matched. Nothing to download.'
        exit 0
    }
}
elseif ($PSCmdlet.ParameterSetName -eq 'All') {
    $selectedRepos = $allRepos
}
else {
    # Interactive: show a GUI picker with repo details.
    # Only name and description are shown in the grid so that the long clone URL
    # does not obscure the columns.  Selected names are matched back to the full
    # repo objects afterwards so that clone_url is still available.
    Write-Host 'Opening selection window – hold Ctrl/Shift to pick multiple repos, then click OK.' -ForegroundColor Yellow
    $pickedNames = @(
        $allRepos |
            Select-Object -Property name, description |
            Out-GridView -Title "Select repositories to download to $($DriveLetter.ToUpper()):\gladiola_repos\" -PassThru |
            Where-Object { $_ -ne $null } |
            ForEach-Object { $_.name }
    )

    $selectedRepos = @($allRepos | Where-Object { $pickedNames -contains $_.name })

    if ($selectedRepos.Count -eq 0) {
        Write-Warning 'No repositories selected. Nothing to download.'
        exit 0
    }
}

Write-Host "`nDownloading $($selectedRepos.Count) repositories to $targetDir`n"

$failed = @()

foreach ($repo in $selectedRepos) {
    $name     = $repo.name
    $cloneUrl = $repo.clone_url
    $destPath = Join-Path $targetDir $name

    try {
        Clone-Or-Update -Url $cloneUrl -DestPath $destPath -RepoName $name
        Write-Host "  OK        $name" -ForegroundColor Green
    }
    catch {
        Write-Warning "  FAILED    $name : $_"
        $failed += $name
    }
}

Write-Host ''

if ($failed.Count -gt 0) {
    Write-Warning "The following repositories could not be downloaded:"
    $failed | ForEach-Object { Write-Warning "  - $_" }
    exit 1
}
else {
    Write-Host "All $($selectedRepos.Count) repositories downloaded successfully to $targetDir" -ForegroundColor Green
    Write-Host "You can now safely eject the USB drive and take it to your OpenBSD machine.`n"
}
