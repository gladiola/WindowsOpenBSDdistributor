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

---

## Hakbang 2 – I-install sa OpenBSD

### Mga kailangan

* May root o `doas` access sa OpenBSD.
* Nakakabit ang USB drive sa OpenBSD machine.

### I-mount ang USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Patakbuhin ang install script

```sh
doas sh openbsd/install_repos.sh
```

### I-unmount kapag tapos na

```sh
doas umount /mnt/usb
```
