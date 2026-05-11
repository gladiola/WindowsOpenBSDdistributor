# WindowsOpenBSDdistributor

Undhuh repositori gladiola menyang drive USB ing Windows, banjur pasang ing mesin OpenBSD sanajan OpenBSD ora nduweni akses internet langsung.

Loro skrip iki ndhukung **pilihan interaktif**, supaya sampeyan bisa milih repositori sing pas kanggo diundhuh utawa dipasang saben wektu.

---

## Langkah 1 – Undhuh menyang USB (Windows)

### Syarat

* [Git for Windows](https://git-scm.com/download/win) wis dipasang lan kasedhiya ing `PATH`.
* Drive USB wis kasambung (umpamane `E:`).

### Jalanake skrip PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Prentah |
|---|---|
| **Interaktif** – pilihan GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositori tartamtu** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Kabeh repositori** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## Langkah 2 – Pasang ing OpenBSD

### Syarat

* Duwe akses root utawa `doas` ing OpenBSD.
* Drive USB kasambung menyang mesin OpenBSD.

### Mount USB

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalanake skrip instalasi

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interactive mode** lists every repo found in `gladiola_repos/` on the USB drive with a number, then prompts you to enter the numbers you want (e.g. `1 3 5`). Press **Enter** with no input to install everything.

For each selected repository the script:
1. Copies it to `<install_dir>/` (default `/usr/local/gladiola`)
2. Sets `chmod 755` on all `.sh` files
3. Runs `make install` if a `Makefile` is present (output shown only on failure)

### Unmount yen wis rampung

```sh
doas umount /mnt/usb
```
