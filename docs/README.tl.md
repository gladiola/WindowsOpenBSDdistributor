# WindowsOpenBSDdistributor

I-download ang mga gladiola repository sa USB drive gamit ang Windows, at i-install ang mga ito sa OpenBSD machine kahit walang direktang internet ang OpenBSD system.

Sinusuportahan ng dalawang script ang **interactive na pagpili**, kaya mapipili mo nang eksakto kung aling repository ang ida-download o i-install sa bawat gamit.

---

## Hakbang 1 – Mag-download sa USB (Windows)

### Mga kailangan

* Naka-install ang [Git for Windows](https://git-scm.com/download/win) at nasa `PATH`.
* May nakakabit na USB drive (hal. `E:`).

### Patakbuhin ang PowerShell script

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Command |
|---|---|
| **Interactive** – GUI picker | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Partikular na repos** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Lahat ng repos** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## Hakbang 2 – I-install sa OpenBSD

### Mga kailangan

* May root o `doas` access sa OpenBSD.
* Nakakabit ang USB drive sa OpenBSD machine.

### I-mount ang USB

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Patakbuhin ang install script

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

### I-unmount kapag tapos na

```sh
doas umount /mnt/usb
```
