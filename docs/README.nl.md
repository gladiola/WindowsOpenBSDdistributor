# WindowsOpenBSDdistributor

Download gladiola-repositories naar een USB-stick op Windows en installeer ze vervolgens op een OpenBSD-machine – zelfs wanneer het OpenBSD-systeem geen directe internettoegang heeft.

Beide scripts ondersteunen **interactieve selectie** zodat u elke keer precies kunt kiezen welke repositories u wilt downloaden of installeren.

---

## Stap 1 – Downloaden naar USB-stick (Windows)

### Vereisten

* [Git voor Windows](https://git-scm.com/download/win) geïnstalleerd en aanwezig in het `PATH`.
* Een USB-stick aangesloten (bijv. station `E:`).

### Het PowerShell-script uitvoeren

```powershell
# Uitvoering van lokale scripts toestaan (eenmalig, voer uit als Administrator indien nodig)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Opdracht |
|---|---|
| **Interactief** – GUI-selectievenster | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Specifieke repositories** – geen GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Alle repositories** – geen GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Met een GitHub-token (verhoogt het snelheidslimiet) | voeg `-Token ghp_uwToken` toe aan elke bovenstaande opdracht |

**Interactieve modus** haalt alle openbare gladiola-repositories op via de GitHub API en opent een `Out-GridView`-venster met een lijst van repository-namen. Houd **Ctrl** of **Shift** ingedrukt om meerdere repositories te selecteren en klik dan op **OK**.

Het script kloont elke gekozen repository naar `<Stationsletter>:\gladiola_repos\`. Als een repository al eerder gekloond is, wordt de nieuwste `HEAD` opgehaald en ingesteld.

Gooi de USB-stick veilig uit wanneer het script succes meldt.

---

## Stap 2 – Installeren op OpenBSD

### Vereisten

* Root- (of `doas`-) toegang op de OpenBSD-machine.
* De USB-stick fysiek aangesloten op de OpenBSD-machine.

### De USB-stick koppelen

```sh
# De apparaatnaam vinden (zoek naar de USB-stick, vaak sd1 of sd2)
sysctl hw.disknames

# Koppelen (vervang sd1i door uw werkelijke partitie)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Het installatiescript uitvoeren

| Modus | Opdracht |
|---|---|
| **Interactief** – genummerd menu | `doas sh openbsd/install_repos.sh` |
| **Specifieke repositories** – geen menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Alle repositories** – geen menu | `doas sh openbsd/install_repos.sh -a` |
| Aangepaste bron / bestemming | voeg toe `-s /mnt/usbkey -d /home/mijngebruiker/gladiola` |

**Interactieve modus** toont elke repository in `gladiola_repos/` op de USB-stick met een nummer en vraagt u vervolgens de gewenste nummers in te voeren (bijv. `1 3 5`). Druk op **Enter** zonder invoer om alles te installeren.

Voor elke geselecteerde repository doet het script:
1. Kopieert het naar `<installatiegids>/` (standaard: `/usr/local/gladiola`)
2. Stelt `chmod 755` in op alle `.sh`-bestanden
3. Voert `make install` uit als er een `Makefile` aanwezig is (uitvoer alleen bij mislukking getoond)

### De USB-stick ontkoppelen wanneer klaar

```sh
doas umount /mnt/usb
```

---

## Mappenstructuur

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Uitvoeren op Windows om de USB-stick te vullen
├── openbsd/
│   └── install_repos.sh     # Uitvoeren op OpenBSD om te installeren vanaf de USB-stick
└── README.md
```
