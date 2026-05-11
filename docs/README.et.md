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

---

## 2. samm – Paigalda OpenBSD-s

### Eeldused

* Root- või `doas`-õigus OpenBSD-s.
* USB-seade on OpenBSD masinaga ühendatud.

### Ühenda USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Käivita paigaldusskript

```sh
doas sh openbsd/install_repos.sh
```

### Eemalda USB

```sh
doas umount /mnt/usb
```
