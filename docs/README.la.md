# WindowsOpenBSDdistributor

Receptacula gladiola in USB disco sub Windows depone, deinde ea in machina OpenBSD institue, etiam si OpenBSD accessum directum ad interrete non habet.

Utraque scriptura **electionem interactivam** sustinet, ut exacte eligas quae receptacula singulis vicibus deponenda vel instituenda sint.

---

## Gradus I – In USB deponere (Windows)

### Praerequisita

* [Git for Windows](https://git-scm.com/download/win) institutum et in `PATH` praesto.
* USB discus conexus (exempli gratia `E:`).

### Scripturam PowerShell exsequere

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Mandatum |
|---|---|
| **Interactivus** – electio GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositoria certa** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Omnia repositoria** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| Cum signo GitHub (maior modus limitis) | adde `-Token ghp_yourToken` cuique mandato supra |

**Modus interactivus** omnia repositoria publica gladiola ex GitHub API accipit et fenestram `Out-GridView` aperit quae nomina repositoriorum ostendit. Tene **Ctrl** vel **Shift** ut plura eligas, deinde preme **OK**.

Scriptum unumquodque repositorium electum in `<DriveLetter>:\\gladiola_repos\\` clonat. Si repositorium iam antea clonatum est, `fetch` facit et ad novissimum `HEAD` reponit.

USB unitatem tuto remove cum scriptum successum nuntiat.

---

## Gradus II – In OpenBSD instituere

### Praerequisita

* Accessus root vel `doas` in OpenBSD.
* USB discus physice ad OpenBSD conexus.

### USB disci montatio

```sh
# Inveni nomen fabricae (quaere USB unitatem, saepe sd1 vel sd2)
sysctl hw.disknames

# Monte eam (sd1i cum vera partitione tua substitue)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Scripturam institutionis exsequere

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Modus interactivus** unumquodque repositorium inventum in `gladiola_repos/` in USB unitate cum numero ostendit, deinde petit ut numeros quos vis inseras (ex. `1 3 5`). Preme **Enter** sine input ut omnia installentur.

Pro unoquoque repositorio electo scriptum:
1. In `<install_dir>/` copiat (defectus `/usr/local/gladiola`)
2. `chmod 755` in omnibus fasciculis `.sh` ponit
3. `make install` currit si `Makefile` adest (output ostenditur tantum in errore)

### Post finem dismonta

```sh
doas umount /mnt/usb
```
