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

---

## Gradus II – In OpenBSD instituere

### Praerequisita

* Accessus root vel `doas` in OpenBSD.
* USB discus physice ad OpenBSD conexus.

### USB disci montatio

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Scripturam institutionis exsequere

```sh
doas sh openbsd/install_repos.sh
```

### Post finem dismonta

```sh
doas umount /mnt/usb
```
