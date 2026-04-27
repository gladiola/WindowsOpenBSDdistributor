<#
.SYNOPSIS
    Downloads today's gladiola GitHub repositories to a USB drive.

.DESCRIPTION
    Clones (or updates) each of the gladiola repositories that were created
    on 2026-04-27 into a folder called "gladiola_repos" on the specified
    USB drive.  The resulting directory layout on the USB drive is:

        <DriveLetter>:\gladiola_repos\
            OBJC-codespaces\
            OBJC-slowlorisdetector\
            OBJC-allowlisting\
            OBJC-HomemadeBlockProgram\
            OpenBSDHomemadeBlockScripts\

    Git must be installed and available on PATH.  The clones are done over
    HTTPS so no SSH key is required.

.PARAMETER DriveLetter
    The drive letter of the USB drive (without colon), e.g. "E".

.EXAMPLE
    .\download_repos.ps1 -DriveLetter E
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = 'USB drive letter (e.g. E)')]
    [ValidatePattern('^[A-Za-z]$')]
    [string]$DriveLetter
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

$GithubOrg   = 'gladiola'
$RepoNames   = @(
    'OBJC-codespaces',
    'OBJC-slowlorisdetector',
    'OBJC-allowlisting',
    'OBJC-HomemadeBlockProgram',
    'OpenBSDHomemadeBlockScripts'
)

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
    if (-not (Test-Path $root)) {
        throw "Drive $root was not found. Make sure the USB drive is plugged in and the letter is correct."
    }
    return $root
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
            git fetch --all --prune 2>&1 | Write-Verbose
            git reset --hard origin/HEAD 2>&1 | Write-Verbose
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Host "  Cloning   $RepoName ..." -ForegroundColor Cyan
        git clone --progress $Url $DestPath 2>&1 | ForEach-Object { Write-Verbose $_ }
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

Write-Host "`nDownloading $($RepoNames.Count) repositories to $targetDir`n"

$failed = @()

foreach ($name in $RepoNames) {
    $url      = "https://github.com/$GithubOrg/$name.git"
    $destPath = Join-Path $targetDir $name

    try {
        Clone-Or-Update -Url $url -DestPath $destPath -RepoName $name
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
    Write-Host "All repositories downloaded successfully to $targetDir" -ForegroundColor Green
    Write-Host "You can now safely eject the USB drive and take it to your OpenBSD machine.`n"
}
