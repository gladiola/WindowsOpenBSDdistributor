# WindowsOpenBSDdistributor

Scarica i repository gladiola su una chiavetta USB su Windows, poi installali su una macchina OpenBSD — anche quando il sistema OpenBSD non ha accesso diretto a Internet.

Entrambi gli script supportano la **selezione interattiva** in modo da poter scegliere esattamente quali repository scaricare o installare ogni volta.

---

## Passo 1 – Scaricare sulla chiavetta USB (Windows)

### Prerequisiti

* [Git per Windows](https://git-scm.com/download/win) installato e nel `PATH`.
* Una chiavetta USB collegata (es. unità `E:`).

### Eseguire lo script PowerShell

```powershell
# Consentire l'esecuzione di script locali (una tantum, eseguire come Amministratore se necessario)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modalità | Comando |
|---|---|
| **Interattiva** – finestra di selezione GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repository specifici** – senza GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Tutti i repository** – senza GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Con token GitHub (aumenta il limite di velocità) | aggiungere `-Token ghp_ilTuoToken` a qualsiasi comando sopra |

**La modalità interattiva** recupera tutti i repository pubblici gladiola dall'API GitHub e apre una finestra `Out-GridView` con i nomi dei repository. Tieni premuto **Ctrl** o **Shift** per selezionare più repository, poi fai clic su **OK**.

Lo script clona ogni repository scelto in `<LetteraUnità>:\gladiola_repos\`. Se un repository è già stato clonato in precedenza, recupera e reimposta all'ultimo `HEAD`.

Espelli la chiavetta USB in modo sicuro quando lo script segnala il successo.

---

## Passo 2 – Installare su OpenBSD

### Prerequisiti

* Accesso root (o `doas`) sulla macchina OpenBSD.
* La chiavetta USB fisicamente collegata alla macchina OpenBSD.

### Montare la chiavetta USB

```sh
# Trovare il nome del dispositivo (cercare la chiavetta USB, spesso sd1 o sd2)
sysctl hw.disknames

# Montarla (sostituire sd1i con la propria partizione effettiva)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Eseguire lo script di installazione

| Modalità | Comando |
|---|---|
| **Interattiva** – menu numerato | `doas sh openbsd/install_repos.sh` |
| **Repository specifici** – senza menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Tutti i repository** – senza menu | `doas sh openbsd/install_repos.sh -a` |
| Origine / destinazione personalizzata | aggiungere `-s /mnt/usbkey -d /home/mioutente/gladiola` |

**La modalità interattiva** elenca ogni repository trovato in `gladiola_repos/` sulla chiavetta USB con un numero, poi ti chiede di inserire i numeri desiderati (es. `1 3 5`). Premi **Invio** senza input per installare tutto.

Per ogni repository selezionato lo script:
1. Lo copia in `<dir_installazione>/` (predefinito: `/usr/local/gladiola`)
2. Imposta `chmod 755` su tutti i file `.sh`
3. Esegue `make install` se è presente un `Makefile` (output mostrato solo in caso di errore)

### Smontare la chiavetta USB al termine

```sh
doas umount /mnt/usb
```

---

## Struttura delle directory

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Eseguire su Windows per popolare la chiavetta USB
├── openbsd/
│   └── install_repos.sh     # Eseguire su OpenBSD per installare dalla chiavetta USB
└── README.md
```
