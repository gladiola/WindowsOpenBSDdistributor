# WindowsOpenBSDdistributor

## Language index

[English (US)](docs/README.en-US.md) · [Deutsch](docs/README.de.md) · [Español](docs/README.es.md) · [Français](docs/README.fr.md) · [Português](docs/README.pt.md) · [Italiano](docs/README.it.md) · [繁體中文 (香港)](docs/README.zh-HK.md) · [한국어](docs/README.ko.md) · [हिन्दी](docs/README.hi.md) · [Русский](docs/README.ru.md) · [العربية](docs/README.ar.md) · [Kiswahili](docs/README.sw.md) · [日本語](docs/README.ja.md) · [Kreyòl ayisyen](docs/README.ht.md) · [ʻŌlelo Hawaiʻi](docs/README.haw.md) · [Gagana Samoa](docs/README.sm.md) · [Te Reo Māori](docs/README.mi.md) · [Afrikaans](docs/README.af.md) · [Nederlands](docs/README.nl.md) · [Hausa](docs/README.ha.md) · [አማርኛ](docs/README.am.md) · [Yorùbá](docs/README.yo.md) · [বাংলা](docs/README.bn.md) · [普通话](docs/README.zh-CN.md) · [Eesti](docs/README.et.md) · [Suomi](docs/README.fi.md) · [Svenska](docs/README.sv.md) · [Norsk](docs/README.no.md) · [Українська](docs/README.uk.md) · [ไทย](docs/README.th.md) · [Bahasa Indonesia](docs/README.id.md) · [Tagalog](docs/README.tl.md) · [Bahasa Melayu](docs/README.ms.md) · [Basa Jawa](docs/README.jv.md) · [Ελληνικά](docs/README.el.md) · [Latina](docs/README.la.md) · [עברית](docs/README.he.md) · [Gaeilge](docs/README.ga.md)

Download gladiola repos to a USB drive on Windows, then install them on an
OpenBSD machine – even when the OpenBSD system has no direct internet access.

Both scripts support **interactive selection** so you can pick exactly which
repos to download or install each time.

---

## Step 1 – Download to USB drive (Windows)

### Prerequisites

* [Git for Windows](https://git-scm.com/download/win) installed and on `PATH`.
* A USB drive plugged in (e.g. drive `E:`).

### Run the PowerShell script

```powershell
# Allow running local scripts (one-time, run as Administrator if needed)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Command |
|---|---|
| **Interactive** – GUI picker window | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Specific repos** – no GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **All repos** – no GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and
opens an `Out-GridView` window listing repo names.  Hold **Ctrl** or **Shift**
to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\gladiola_repos\`.
If a repo was already cloned previously it fetches and resets to the latest
`HEAD` instead.

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

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interactive mode** lists every repo found in `gladiola_repos/` on the USB
drive with a number, then prompts you to enter the numbers you want (e.g.
`1 3 5`).  Press **Enter** with no input to install everything.

For each selected repository the script:
1. Copies it to `<install_dir>/` (default `/usr/local/gladiola`)
2. Sets `chmod 755` on all `.sh` files
3. Runs `make install` if a `Makefile` is present (output shown only on failure)

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
