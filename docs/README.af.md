# WindowsOpenBSDdistributor

Laai gladiola-opbergplekke af na 'n USB-skyf op Windows en installeer dit dan op 'n OpenBSD-rekenaar – selfs wanneer die OpenBSD-stelsel geen direkte internettoegang het nie.

Albei skrifte ondersteun **interaktiewe keuse** sodat jy elke keer presies kan kies watter opbergplekke om af te laai of te installeer.

---

## Stap 1 – Laai af na USB-skyf (Windows)

### Voorvereistes

* [Git vir Windows](https://git-scm.com/download/win) geïnstalleer en in die `PATH`.
* 'n USB-skyf ingesteek (bv. skyf `E:`).

### Voer die PowerShell-skrip uit

```powershell
# Laat uitvoering van plaaslike skrifte toe (eenmalig, voer as Administrateur uit indien nodig)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Opdrag |
|---|---|
| **Interaktief** – GUI-keusevenster | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Spesifieke opbergplekke** – geen GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Alle opbergplekke** – geen GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Met 'n GitHub-token (verhoog die koerslimiet) | voeg `-Token ghp_jouToken` by enige opdrag hierbo |

**Interaktiewe modus** haal alle openbare gladiola-opbergplekke van die GitHub API af en maak 'n `Out-GridView`-venster oop met 'n lys van opbergplek-name. Hou **Ctrl** of **Shift** ingedruk om verskeie opbergplekke te kies, klik dan **OK**.

Die skrip kloon elke gekose opbergplek na `<SkyflettER>:\gladiola_repos\`. As 'n opbergplek reeds voorheen gekloon is, haal dit op en stel dit terug na die nuutste `HEAD`.

Gooi die USB-skyf veilig uit wanneer die skrip sukses rapporteer.

---

## Stap 2 – Installeer op OpenBSD

### Voorvereistes

* Root- (of `doas`-) toegang op die OpenBSD-rekenaar.
* Die USB-skyf fisies aan die OpenBSD-rekenaar gekoppel.

### Koppel die USB-skyf aan

```sh
# Vind die toestelnaam (soek die USB-skyf, dikwels sd1 of sd2)
sysctl hw.disknames

# Koppel aan (vervang sd1i met jou werklike partisie)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Voer die installasiescript uit

| Modus | Opdrag |
|---|---|
| **Interaktief** – genommerde kieslys | `doas sh openbsd/install_repos.sh` |
| **Spesifieke opbergplekke** – geen kieslys | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Alle opbergplekke** – geen kieslys | `doas sh openbsd/install_repos.sh -a` |
| Pasgemaakte bron / bestemming | voeg `-s /mnt/usbkey -d /home/mygebruiker/gladiola` by |

**Interaktiewe modus** lys elke opbergplek wat in `gladiola_repos/` op die USB-skyf gevind word met 'n nommer, en vra jou dan om die nommers wat jy wil hê in te voer (bv. `1 3 5`). Druk **Enter** sonder invoer om alles te installeer.

Vir elke geselekteerde opbergplek doen die skrip:
1. Kopieer dit na `<installasiegids>/` (standaard: `/usr/local/gladiola`)
2. Stel `chmod 755` op alle `.sh`-lêers
3. Voer `make install` uit indien 'n `Makefile` teenwoordig is (uitvoer slegs by mislukking gewys)

### Ontkoppel die USB-skyf wanneer klaar

```sh
doas umount /mnt/usb
```

---

## Gidsuitleg

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Voer op Windows uit om die USB-skyf te vul
├── openbsd/
│   └── install_repos.sh     # Voer op OpenBSD uit om van die USB-skyf te installeer
└── README.md
```
