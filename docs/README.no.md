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

| Med en GitHub-token (høyere grense) | legg til `-Token ghp_dinToken` i en av kommandoene over |

**Interaktiv modus** henter alle offentlige gladiola-repositorier fra GitHub API og åpner et `Out-GridView`-vindu som viser repo-navn. Hold **Ctrl** eller **Shift** for å velge flere repos, og klikk deretter **OK**.

Skriptet kloner hvert valgt repo til `<DriveLetter>:\\gladiola_repos\\`. Hvis et repo allerede var klonet tidligere, henter det og nullstiller til nyeste `HEAD` i stedet.

Løs ut USB-enheten på en trygg måte når skriptet melder suksess.

---

## Trinn 2 – Installer på OpenBSD

### Krav

* Root- eller `doas`-tilgang på OpenBSD.
* USB-enheten fysisk koblet til OpenBSD-maskinen.

### Monter USB-enheten

```sh
# Finn enhetsnavnet (se etter USB-enheten, ofte sd1 eller sd2)
sysctl hw.disknames

# Monter den (erstatt sd1i med din faktiske partisjon)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Kjør installasjonsskriptet

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interaktiv modus** viser hvert repo funnet i `gladiola_repos/` på USB-enheten med et nummer, og ber deg skrive inn numrene du vil ha (f.eks. `1 3 5`). Trykk **Enter** uten input for å installere alt.

For hvert valgt repository gjør skriptet:
1. Kopierer det til `<install_dir>/` (standard `/usr/local/gladiola`)
2. Setter `chmod 755` på alle `.sh`-filer
3. Kjører `make install` hvis en `Makefile` finnes (utdata vises bare ved feil)

### Avmonter når du er ferdig

```sh
doas umount /mnt/usb
```
