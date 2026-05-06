# WindowsOpenBSDdistributor

Telechaje depo gladiola yo sou yon USB sou Windows, epi enstale yo sou yon machin OpenBSD — menm lè sistèm OpenBSD la pa gen aksè dirèk a Entènèt.

De skript yo sipòte **seleksyon entèaktif** pou ou kapab chwazi egzakteman ki depo pou telechaje oswa enstale chak fwa.

---

## Etap 1 – Telechaje sou USB (Windows)

### Kondisyon Preyalab

* [Git pou Windows](https://git-scm.com/download/win) enstale epi nan `PATH`.
* Yon USB enstale (pa egzanp, driv `E:`).

### Kouri Skript PowerShell la

```powershell
# Pèmèt ekzekisyon skript lokal (yon sèl fwa, kouri kòm Administratè si nesesè)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mòd | Kòmand |
|---|---|
| **Entèaktif** – fenèt seleksyon GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Depo espesifik** – san GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Tout depo** – san GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Ak tokèn GitHub (ogmante limit vitès) | ajoute `-Token ghp_tokenOu` nan nenpòt kòmand anwo a |

**Mòd entèaktif** jwenn tout depo piblik gladiola nan API GitHub epi ouvri yon fenèt `Out-GridView` ki montre non depo yo. Kenbe **Ctrl** oswa **Shift** pou seleksyone plizyè depo, epi klike **OK**.

Skript la klone chak depo chwazi nan `<LètrDriv>:\gladiola_repos\`. Si yon depo te deja klone anvan, li rekipere epi mete li sou dènye `HEAD` a.

Retire USB la an sekirite lè skript rapòte siksè.

---

## Etap 2 – Enstale sou OpenBSD

### Kondisyon Preyalab

* Aksè root (oswa `doas`) sou machin OpenBSD la.
* USB la konekte fizikman ak machin OpenBSD la.

### Monte USB la

```sh
# Jwenn non aparèy la (chèche USB a, souvan sd1 oswa sd2)
sysctl hw.disknames

# Monte li (ranplase sd1i ak pati reyèl ou a)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Kouri Skript Enstalasyon an

| Mòd | Kòmand |
|---|---|
| **Entèaktif** – meni nimewo | `doas sh openbsd/install_repos.sh` |
| **Depo espesifik** – san meni | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Tout depo** – san meni | `doas sh openbsd/install_repos.sh -a` |
| Sous / destinasyon pèsonalize | ajoute `-s /mnt/usbkey -d /home/itilizatèm/gladiola` |

**Mòd entèaktif** liste chak depo ki nan `gladiola_repos/` sou USB la ak yon nimewo, epi li mande ou antre nimewo ou vle yo (pa egzanp `1 3 5`). Peze **Antre** san antre pou enstale tout bagay.

Pou chak depo chwazi, skript la:
1. Kopye li nan `<repètowaEnstale>/` (pa defo: `/usr/local/gladiola`)
2. Mete `chmod 755` sou tout fichye `.sh`
3. Kouri `make install` si gen yon `Makefile` (sòti montre sèlman si echèk)

### Demonte USB Lè Ou Fin

```sh
doas umount /mnt/usb
```

---

## Estrikti Repèrtwa

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Kouri sou Windows pou ranpli USB la
├── openbsd/
│   └── install_repos.sh     # Kouri sou OpenBSD pou enstale depi USB la
└── README.md
```
