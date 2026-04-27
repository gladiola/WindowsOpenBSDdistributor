# WindowsOpenBSDdistributor

Download gladiola repos to a USB drive on Windows, then install them on an
OpenBSD machine – even when the OpenBSD system has no direct internet access.

---

## Repositories covered

| Repository | Description |
|---|---|
| [OBJC-codespaces](https://github.com/gladiola/OBJC-codespaces) | Codespaces setup for Objective-C |
| [OBJC-slowlorisdetector](https://github.com/gladiola/OBJC-slowlorisdetector) | Slowloris attack detector |
| [OBJC-allowlisting](https://github.com/gladiola/OBJC-allowlisting) | HTTP variable allow-listing helper |
| [OBJC-HomemadeBlockProgram](https://github.com/gladiola/OBJC-HomemadeBlockProgram) | IP block program |
| [OpenBSDHomemadeBlockScripts](https://github.com/gladiola/OpenBSDHomemadeBlockScripts) | pf-based block scripts for OpenBSD |

---

## Step 1 – Download to USB drive (Windows)

### Prerequisites

* [Git for Windows](https://git-scm.com/download/win) installed and on `PATH`.
* A USB drive plugged in (e.g. drive `E:`).

### Run the PowerShell script

```powershell
# Allow running local scripts (one-time, run as Administrator if needed)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

# Download all repos to E:\gladiola_repos\
.\windows\download_repos.ps1 -DriveLetter E
```

The script creates `E:\gladiola_repos\` and clones every repository into it.
If a repository was already cloned previously the script fetches and resets to
the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## Step 2 – Install on OpenBSD

### Prerequisites

* Root (or `doas`) access on the OpenBSD machine.
* The USB drive physically connected to the OpenBSD machine.

### Mount the USB drive

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Run the install script

```sh
# Install with default paths (/mnt/usb source, /usr/local/gladiola destination)
doas sh openbsd/install_repos.sh

# Or specify custom paths
doas sh openbsd/install_repos.sh -s /mnt/usbkey -d /home/myuser/gladiola
```

The script:

1. Copies every repository from `<usb_mount>/gladiola_repos/` to
   `<install_dir>/`.
2. Sets executable bits on all `.sh` files.
3. Runs `make install` inside any repository that contains a `Makefile`.
4. Prints post-install notes for `OpenBSDHomemadeBlockScripts` (reminding you
   to edit paths before adding scripts to `cron` or `rc.local`).

### Unmount the USB drive when done

```sh
doas umount /mnt/usb
```

---

## Directory layout

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Run on Windows to populate the USB drive
├── openbsd/
│   └── install_repos.sh     # Run on OpenBSD to install from the USB drive
└── README.md
```