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

| Kapag may GitHub token (mas mataas ang rate limit) | idagdag ang `-Token ghp_yourToken` sa alinmang command sa itaas |

**Interactive mode** kumukuha ng lahat ng pampublikong gladiola repos mula sa GitHub API at nagbubukas ng `Out-GridView` window na may listahan ng repo names. Pindutin ang **Ctrl** o **Shift** para pumili ng marami, tapos i-click ang **OK**.

Iki-clone ng script ang bawat napiling repo sa `<DriveLetter>:\\gladiola_repos\\`. Kung na-clone na dati ang repo, magfe-fetch ito at magre-reset sa pinakabagong `HEAD`.

Ligtas na i-eject ang USB drive kapag nag-report ng success ang script.

---

## Hakbang 2 – I-install sa OpenBSD

### Mga kailangan

* May root o `doas` access sa OpenBSD.
* Nakakabit ang USB drive sa OpenBSD machine.

### I-mount ang USB

```sh
# Hanapin ang device name (hanapin ang USB drive, kadalasang sd1 o sd2)
sysctl hw.disknames

# I-mount ito (palitan ang sd1i ng aktwal mong partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Patakbuhin ang install script

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interactive mode** inililista ang bawat repo na makita sa `gladiola_repos/` sa USB drive na may numero, at hihilingin sa iyong ilagay ang mga numerong gusto mo (hal. `1 3 5`). Pindutin ang **Enter** nang walang input para i-install lahat.

Para sa bawat napiling repository, ang script ay:
1. Kinokopya ito sa `<install_dir>/` (default `/usr/local/gladiola`)
2. Itinatakda ang `chmod 755` sa lahat ng `.sh` files
3. Pinapatakbo ang `make install` kung may `Makefile` (output lang kapag may failure)

### I-unmount kapag tapos na

```sh
doas umount /mnt/usb
```
