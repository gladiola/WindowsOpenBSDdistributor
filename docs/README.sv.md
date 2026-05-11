# WindowsOpenBSDdistributor

Ladda ner gladiola-repositorier till ett USB-minne i Windows och installera dem på en OpenBSD-maskin, även när OpenBSD saknar direkt internetåtkomst.

Båda skripten stöder **interaktivt val**, så du kan välja exakt vilka repositorier som ska laddas ner eller installeras varje gång.

---

## Steg 1 – Ladda ner till USB (Windows)

### Förkrav

* [Git for Windows](https://git-scm.com/download/win) installerat och tillgängligt i `PATH`.
* Ett anslutet USB-minne (t.ex. `E:`).

### Kör PowerShell-skriptet

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Läge | Kommando |
|---|---|
| **Interaktivt** – GUI-val | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Specifika repos** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Alla repos** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| Med en GitHub-token (högre gräns för förfrågningar) | lägg till `-Token ghp_dinToken` till valfritt kommando ovan |

**Interaktivt läge** hämtar alla offentliga gladiola-repositorier från GitHub API och öppnar ett `Out-GridView`-fönster som listar repo-namn. Håll **Ctrl** eller **Shift** för att välja flera repos, och klicka sedan på **OK**.

Skriptet klonar varje valt repo till `<DriveLetter>:\\gladiola_repos\\`. Om ett repo redan har klonats tidigare hämtar det och återställer till senaste `HEAD` i stället.

Mata ut USB-minnet säkert när skriptet rapporterar att det lyckades.

---

## Steg 2 – Installera på OpenBSD

### Förkrav

* Root- eller `doas`-åtkomst på OpenBSD.
* USB-minnet anslutet till OpenBSD-maskinen.

### Montera USB-minnet

```sh
# Hitta enhetsnamnet (leta efter USB-minnet, ofta sd1 eller sd2)
sysctl hw.disknames

# Montera det (ersätt sd1i med din faktiska partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Kör installationsskriptet

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interaktivt läge** listar varje repo som hittas i `gladiola_repos/` på USB-minnet med ett nummer och ber dig sedan ange de nummer du vill ha (t.ex. `1 3 5`). Tryck **Enter** utan inmatning för att installera allt.

För varje valt repository gör skriptet:
1. Kopierar det till `<install_dir>/` (standard `/usr/local/gladiola`)
2. Sätter `chmod 755` på alla `.sh`-filer
3. Kör `make install` om en `Makefile` finns (utdata visas bara vid fel)

### Avmontera när du är klar

```sh
doas umount /mnt/usb
```
