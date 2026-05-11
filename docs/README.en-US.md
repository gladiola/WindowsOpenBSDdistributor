# WindowsOpenBSDdistributor

Download gladiola repositories to a USB drive on Windows, then install them on an OpenBSD machine, even when OpenBSD has no direct internet access.

Both scripts support **interactive selection**, so you can choose exactly which repositories to download or install each time.

---

## Step 1 – Download to USB drive (Windows)

### Prerequisites

* [Git for Windows](https://git-scm.com/download/win) installed and available on `PATH`.
* A connected USB drive (for example, `E:`).

### Run the PowerShell script

```powershell
# Allow local scripts (one-time, run as Administrator if needed)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Command |
|---|---|
| **Interactive** – GUI picker window | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Specific repos** – no GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **All repos** – no GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| With a GitHub token (higher rate limits) | add `-Token ghp_yourToken` |

---

## Step 2 – Install on OpenBSD

### Prerequisites

* Root (or `doas`) access on OpenBSD.
* USB drive physically attached to OpenBSD.

### Mount the USB drive

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Run the install script

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

### Unmount when done

```sh
doas umount /mnt/usb
```
