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

| GitHub-tokenilla (suurempi pyyntöraja) | lisää `-Token ghp_yourToken` mihin tahansa yllä olevaan komentoon |

**Interaktiivinen tila** hakee kaikki julkiset gladiola-repot GitHub API:sta ja avaa `Out-GridView`-ikkunan, jossa näkyvät repositorioiden nimet. Pidä **Ctrl** tai **Shift** pohjassa valitaksesi useita repoja ja napsauta sitten **OK**.

Skripti kloonaa jokaisen valitun repon hakemistoon `<DriveLetter>:\\gladiola_repos\\`. Jos repo on jo aiemmin kloonattu, se hakee muutokset ja palauttaa uusimpaan `HEAD`-tilaan.

Irrota USB-asema turvallisesti, kun skripti ilmoittaa onnistumisesta.

---

## Vaihe 2 – Asenna OpenBSD:ssä

### Vaatimukset

* Root- tai `doas`-oikeudet OpenBSD:ssä.
* USB-asema kytketty OpenBSD-koneeseen.

### Liitä USB-asema

```sh
# Etsi laitteen nimi (etsi USB-asema, usein sd1 tai sd2)
sysctl hw.disknames

# Liitä se (korvaa sd1i omalla osiollasi)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Suorita asennusskripti

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interaktiivinen tila** listaa jokaisen USB-aseman `gladiola_repos/`-hakemistosta löytyvän repon numerolla ja pyytää syöttämään haluamasi numerot (esim. `1 3 5`). Paina **Enter** ilman syötettä, jos haluat asentaa kaiken.

Jokaiselle valitulle repositoriolle skripti:
1. Kopioi sen hakemistoon `<install_dir>/` (oletus `/usr/local/gladiola`)
2. Asettaa `chmod 755` kaikille `.sh`-tiedostoille
3. Suorittaa `make install`, jos `Makefile` on olemassa (tuloste näytetään vain virheessä)

### Irrota USB-asema

```sh
doas umount /mnt/usb
```
