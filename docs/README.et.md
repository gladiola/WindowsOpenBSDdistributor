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

| GitHubi tokeniga (suurem päringulimiit) | lisa `-Token ghp_yourToken` mõnele ülaltoodud käsule |

**Interaktiivne režiim** toob GitHub API-st kõik avalikud gladiola repositooriumid ja avab `Out-GridView` akna, kus on repo nimed. Mitme repo valimiseks hoia all **Ctrl** või **Shift**, seejärel klõpsa **OK**.

Skript kloonib iga valitud repo kausta `<DriveLetter>:\\gladiola_repos\\`. Kui repo oli juba varem kloonitud, siis tehakse fetch ja lähtestatakse uusimale `HEAD`-ile.

Eemalda USB-draiv turvaliselt, kui skript annab edust teada.

---

## 2. samm – Paigalda OpenBSD-s

### Eeldused

* Root- või `doas`-õigus OpenBSD-s.
* USB-seade on OpenBSD masinaga ühendatud.

### Ühenda USB

```sh
# Leia seadme nimi (otsi USB-draivi, sageli sd1 või sd2)
sysctl hw.disknames

# Ühenda see (asenda sd1i oma tegeliku partitsiooniga)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Käivita paigaldusskript

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interaktiivne režiim** loetleb USB-draivi `gladiola_repos/` kaustast leitud repositooriumid numbritega ja palub sisestada soovitud numbrid (nt `1 3 5`). Kui vajutad **Enter** ilma sisendita, paigaldatakse kõik.

Iga valitud repositooriumi jaoks skript:
1. Kopeerib selle kausta `<install_dir>/` (vaikimisi `/usr/local/gladiola`)
2. Määrab kõigile `.sh` failidele õiguse `chmod 755`
3. Käivitab `make install`, kui `Makefile` on olemas (väljund kuvatakse ainult vea korral)

### Eemalda USB

```sh
doas umount /mnt/usb
```
