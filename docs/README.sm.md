# WindowsOpenBSDdistributor

Saunia gladiola repositories i luga o se USB drive i luga o Windows, ona fa'apipi'i atu i luga o se mea OpenBSD – e oo lava i le taimi e leai ai se mea OpenBSD se ala tuusaʻo i luga o le Initaneti.

O initiga e lua e lagolagoina le **filifilia fegalegaleai** ina ia mafai ona e filifili sa'o po'o fea repositories e saunia pe fa'apipi'i i taimi uma.

---

## Laasaga 1 – Saunia i le USB Drive (Windows)

### Mea Manaʻomia

* [Git mo Windows](https://git-scm.com/download/win) fa'apipi'i ma i totonu o le `PATH`.
* Se USB drive fa'apipi'i (e.g. drive `E:`).

### Fa'agasolo le Fa'asologa PowerShell

```powershell
# Fa'atagaina le fa'agasologa o fa'asolosolo fa'apitoa (e tasi le taimi, fa'agasolo o se Faatonu pe a manaʻomia)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Auala | Poloaiga |
|---|---|
| **Fegalegaleai** – fa'amalama filifiliga GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositories fa'apitoa** – e leai se GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Repositories uma** – e leai se GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Faatasi ma le GitHub token (fa'ateleina le tapula'a) | fa'aopoopo `-Token ghp_yourToken` i soʻo se poloaiga o loʻo i luga |

**Auala fegalegaleai** maua repositories uma lautele a gladiola mai le GitHub API ma tatala se fa'amalama `Out-GridView` o loʻo lisi ai igoa o repositories.누눠 **Ctrl** po'o **Shift** e filifili repositories e tele, ona kiliki lea **OK**.

O le initiga clone ia repositories filifilia i totonu o `<LeteaDrive>:\gladiola_repos\`. Afai o se repository ua uma ona clone muamua, ona maua ma toe fa'afo'i i le `HEAD` fou.

Aveese saogalemu le USB drive pe a lipotia e le initiga le manuia.

---

## Laasaga 2 – Fa'apipi'i i OpenBSD

### Mea Manaʻomia

* Avanoa o root (po'o `doas`) i luga o le mea OpenBSD.
* O le USB drive fa'apipi'i faaletino i le mea OpenBSD.

### Fa'apipi'i le USB Drive

```sh
# Su'e le igoa o le masini (su'e le USB drive, e masani ona sd1 po'o sd2)
sysctl hw.disknames

# Fa'apipi'i (sui le sd1i ma lau partition moni)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Fa'agasolo le Initiga Fa'apipi'i

| Auala | Poloaiga |
|---|---|
| **Fegalegaleai** – lisi numera | `doas sh openbsd/install_repos.sh` |
| **Repositories fa'apitoa** – e leai se lisi | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Repositories uma** – e leai se lisi | `doas sh openbsd/install_repos.sh -a` |
| Puna / fa'atonuga fa'apitoa | fa'aopoopo `-s /mnt/usbkey -d /home/taufa/gladiola` |

**Auala fegalegaleai** lisi le repositories uma o loʻo maua i `gladiola_repos/` i luga o le USB drive ma se numera, ona fai lea ma fesili ia te oe e ulufale i numera e te manaʻo ai (e.g. `1 3 5`). Tomi **Enter** e aunoa ma ulufale e fa'apipi'i uma mea.

Mo repositories uma filifilia, o le initiga:
1. Kopi i `<fa'atonuga_fa'apipi'i>/` (fa'aletonu: `/usr/local/gladiola`)
2. Fa'atuina `chmod 755` i faila `.sh` uma
3. Fa'agasolo `make install` afai iai se `Makefile` (o fa'aalia o mea na maua na o i le le manuia)

### Aveese le USB Drive Pe A Uma

```sh
doas umount /mnt/usb
```

---

## Fa'atulagaga o le Fa'atonuga

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Fa'agasolo i Windows e tumu ai le USB drive
├── openbsd/
│   └── install_repos.sh     # Fa'agasolo i OpenBSD e fa'apipi'i mai le USB drive
└── README.md
```
