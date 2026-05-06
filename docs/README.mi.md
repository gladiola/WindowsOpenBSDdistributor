# WindowsOpenBSDdistributor

Tikitiria ngā whare kōrero gladiola ki tētahi USB drive i runga i Windows, kātahi ka tāura ki tētahi rorohiko OpenBSD — ahakoa kāore he hononga tika ki te Ipurangi o te pūnaha OpenBSD.

Ko ngā tuhinga e rua e tautoko ana i te **tīpako taunekeneke** kia āhei ai koe ki te tīpako i ngā whare kōrero hei tikitiria, hei tāura rānei i ia wā.

---

## Tūāhua 1 – Tikitiria ki te USB Drive (Windows)

### Ngā Āhuatanga Matua

* [Git mō Windows](https://git-scm.com/download/win) kua tāuruhia, kei roto hoki i te `PATH`.
* He USB drive kua tūhono (hei tauira, puku `E:`).

### Whakahaere i te Tuhinga PowerShell

```powershell
# Tukua te whakahaere tuhinga ā-rohe (kotahi anake, whakahaerehia hei Kaiwhakahaere mehemea hiahiatia)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Āhua | Kī |
|---|---|
| **Taunekeneke** – matapihi tīpako GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Ngā whare kōrero motuhake** – kāore he GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Ngā whare kōrero katoa** – kāore he GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Me te tohu GitHub (ka hiki i te rohe) | tāpirihia `-Token ghp_yourToken` ki tētahi kī o runga ake |

**Ko te āhua taunekeneke** ka tiki i ngā whare kōrero katoa ā-tūmataiti a gladiola mai i te API a GitHub, ka tuwhera hoki i tētahi matapihi `Out-GridView` e rārangi ana i ngā ingoa o ngā whare kōrero. Pupurihia **Ctrl** rānei **Shift** hei tīpako maha whare kōrero, kātahi ka pāwhiria **OK**.

Ka āhua tāruarua te tuhinga i ia whare kōrero i tīpakohia ki `<Reta Puku>:\gladiola_repos\`. Mēnā kua āhua tāruarua tētahi whare kōrero i mua ake, ka tiki hou, ka hūnuku hoki ki te `HEAD` hou rawa atu.

Tangohia tūāhanga te USB drive ina pūrongo ana te tuhinga ki te angitu.

---

## Tūāhua 2 – Tāura ki OpenBSD

### Ngā Āhuatanga Matua

* Uru root (rānei `doas`) i runga i te rorohiko OpenBSD.
* Ko te USB drive kua tūhono ā-tinana ki te rorohiko OpenBSD.

### Tūtohu i te USB Drive

```sh
# Kimihia te ingoa o te pūrere (rapua te USB drive, ko sd1 rānei sd2 ia)
sysctl hw.disknames

# Tūtohungia (anō ko sd1i me tō wahanga ake)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Whakahaere i te Tuhinga Tāura

| Āhua | Kī |
|---|---|
| **Taunekeneke** – tūtohu nama | `doas sh openbsd/install_repos.sh` |
| **Ngā whare kōrero motuhake** – kāore he tūtohu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Ngā whare kōrero katoa** – kāore he tūtohu | `doas sh openbsd/install_repos.sh -a` |
| Pūtake / ūnga ritenga | tāpirihia `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Ko te āhua taunekeneke** ka rārangi i ia whare kōrero i kitea i `gladiola_repos/` i runga i te USB drive me tētahi tau, kātahi ka tono ki a koe kia tāurutia ngā tau e hiahia ana (hei tauira `1 3 5`). Pāwhiria **Urunga** me te kore kuputuhi hei tāura i ngā mea katoa.

Mō ia whare kōrero i tīpakohia, ka mahi te tuhinga:
1. Tāruarua ki `<rārangi tāura>/` (taunoa: `/usr/local/gladiola`)
2. Tautuhi `chmod 755` i ngā kōnae `.sh` katoa
3. Whakahaere `make install` mēnā kei reira he `Makefile` (ka whakaatuhia te putanga i te korenga anake)

### Tangohia te USB Drive Ina Oti

```sh
doas umount /mnt/usb
```

---

## Te Hanganga Rārangi

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Whakahaere i Windows hei whakakī i te USB drive
├── openbsd/
│   └── install_repos.sh     # Whakahaere i OpenBSD hei tāura mai i te USB drive
└── README.md
```
