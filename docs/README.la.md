# WindowsOpenBSDdistributor

Receptacula gladiola in USB disco sub Windows depone, deinde ea in machina OpenBSD institue, etiam si OpenBSD accessum directum ad interrete non habet.

Utraque scriptura **electionem interactivam** sustinet, ut exacte eligas quae receptacula singulis vicibus deponenda vel instituenda sint.

---

## Gradus I – In USB deponere (Windows)

### Praerequisita

* [Git for Windows](https://git-scm.com/download/win) institutum et in `PATH` praesto.
* USB discus conexus (exempli gratia `E:`).

### Scripturam PowerShell exsequere

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Mandatum |
|---|---|
| **Interactivus** – electio GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositoria certa** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Omnia repositoria** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## Gradus II – In OpenBSD instituere

### Praerequisita

* Accessus root vel `doas` in OpenBSD.
* USB discus physice ad OpenBSD conexus.

### USB disci montatio

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Scripturam institutionis exsequere

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

### Post finem dismonta

```sh
doas umount /mnt/usb
```
