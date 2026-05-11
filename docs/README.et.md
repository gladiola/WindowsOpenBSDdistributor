# WindowsOpenBSDdistributor

Laadi gladiola repositooriumid Windowsis USB-mälupulgale ja paigalda need OpenBSD masinasse ka siis, kui OpenBSD-l puudub otsene internetiühendus.

Mõlemad skriptid toetavad **interaktiivset valikut**, et saaksid iga kord valida täpselt need repositooriumid, mida soovid alla laadida või paigaldada.

---

## 1. samm – Laadi USB-le (Windows)

### Eeldused

* [Git for Windows](https://git-scm.com/download/win) on paigaldatud ja `PATH`-is.
* USB-seade on ühendatud (nt `E:`).

### Käivita PowerShelli skript

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Režiim | Käsk |
|---|---|
| **Interaktiivne** – GUI valik | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Kindlad repod** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Kõik repod** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## 2. samm – Paigalda OpenBSD-s

### Eeldused

* Root- või `doas`-õigus OpenBSD-s.
* USB-seade on OpenBSD masinaga ühendatud.

### Ühenda USB

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Käivita paigaldusskript

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

### Eemalda USB

```sh
doas umount /mnt/usb
```
