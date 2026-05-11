# WindowsOpenBSDdistributor

Lataa gladiola-repositoriot USB-asemalle Windowsissa ja asenna ne OpenBSD-koneelle, vaikka OpenBSD-järjestelmällä ei olisi suoraa internetyhteyttä.

Molemmat skriptit tukevat **interaktiivista valintaa**, joten voit valita tarkasti ladattavat tai asennettavat repositoriot.

---

## Vaihe 1 – Lataa USB-asemalle (Windows)

### Vaatimukset

* [Git for Windows](https://git-scm.com/download/win) asennettuna ja `PATH`-muuttujassa.
* USB-asema liitettynä (esim. `E:`).

### Suorita PowerShell-skripti

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Tila | Komento |
|---|---|
| **Interaktiivinen** – GUI-valitsin | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Tietyt repot** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Kaikki repot** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Vaihe 2 – Asenna OpenBSD:ssä

### Vaatimukset

* Root- tai `doas`-oikeudet OpenBSD:ssä.
* USB-asema kytketty OpenBSD-koneeseen.

### Liitä USB-asema

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Suorita asennusskripti

```sh
doas sh openbsd/install_repos.sh
```

### Irrota USB-asema

```sh
doas umount /mnt/usb
```
