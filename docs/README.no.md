# WindowsOpenBSDdistributor

Last ned gladiola-repositorier til en USB-enhet på Windows, og installer dem på en OpenBSD-maskin, selv når OpenBSD-systemet ikke har direkte internettilgang.

Begge skriptene støtter **interaktivt valg**, slik at du kan velge nøyaktig hvilke repositorier som skal lastes ned eller installeres.

---

## Trinn 1 – Last ned til USB (Windows)

### Krav

* [Git for Windows](https://git-scm.com/download/win) installert og tilgjengelig i `PATH`.
* En tilkoblet USB-enhet (f.eks. `E:`).

### Kjør PowerShell-skriptet

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Kommando |
|---|---|
| **Interaktiv** – GUI-valg | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Valgte repos** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Alle repos** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Trinn 2 – Installer på OpenBSD

### Krav

* Root- eller `doas`-tilgang på OpenBSD.
* USB-enheten fysisk koblet til OpenBSD-maskinen.

### Monter USB-enheten

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Kjør installasjonsskriptet

```sh
doas sh openbsd/install_repos.sh
```

### Avmonter når du er ferdig

```sh
doas umount /mnt/usb
```
