# WindowsOpenBSDdistributor

Lade gladiola-Repositories auf einen USB-Stick unter Windows herunter und installiere sie auf einer OpenBSD-Maschine – auch wenn das OpenBSD-System keinen direkten Internetzugang hat.

Beide Skripte unterstützen **interaktive Auswahl**, sodass du genau festlegen kannst, welche Repositories du jedes Mal herunterladen oder installieren möchtest.

---

## Schritt 1 – Auf USB-Stick herunterladen (Windows)

### Voraussetzungen

* [Git für Windows](https://git-scm.com/download/win) installiert und im `PATH`.
* Ein eingesteckter USB-Stick (z. B. Laufwerk `E:`).

### Das PowerShell-Skript ausführen

```powershell
# Ausführung lokaler Skripte erlauben (einmalig, ggf. als Administrator)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modus | Befehl |
|---|---|
| **Interaktiv** – GUI-Auswahlfenster | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Bestimmte Repos** – ohne GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Alle Repos** – ohne GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Mit GitHub-Token (erhöht Rate-Limit) | `-Token ghp_deinToken` an einen beliebigen Befehl anhängen |

**Interaktiver Modus** ruft alle öffentlichen gladiola-Repositories von der GitHub-API ab und öffnet ein `Out-GridView`-Fenster mit den Repository-Namen. Halte **Strg** oder **Umschalt** gedrückt, um mehrere Repositories auszuwählen, und klicke dann auf **OK**.

Das Skript klont jedes gewählte Repository nach `<Laufwerksbuchstabe>:\gladiola_repos\`. Wenn ein Repository bereits zuvor geklont wurde, holt es die neuesten Änderungen und setzt es auf den aktuellen `HEAD` zurück.

Werfe den USB-Stick sicher aus, sobald das Skript den Erfolg meldet.

---

## Schritt 2 – Auf OpenBSD installieren

### Voraussetzungen

* Root- (oder `doas`-) Zugriff auf die OpenBSD-Maschine.
* Der USB-Stick physisch mit der OpenBSD-Maschine verbunden.

### USB-Stick einbinden

```sh
# Gerätename ermitteln (nach dem USB-Stick suchen, oft sd1 oder sd2)
sysctl hw.disknames

# Einbinden (sd1i durch deine tatsächliche Partition ersetzen)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Das Installationsskript ausführen

| Modus | Befehl |
|---|---|
| **Interaktiv** – nummeriertes Menü | `doas sh openbsd/install_repos.sh` |
| **Bestimmte Repos** – ohne Menü | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Alle Repos** – ohne Menü | `doas sh openbsd/install_repos.sh -a` |
| Benutzerdefinierte Quelle / Ziel | `-s /mnt/usbkey -d /home/meinuser/gladiola` hinzufügen |

**Interaktiver Modus** listet alle Repositories in `gladiola_repos/` auf dem USB-Stick mit einer Nummer auf und fordert dich dann auf, die gewünschten Nummern einzugeben (z. B. `1 3 5`). Drücke **Enter** ohne Eingabe, um alles zu installieren.

Für jedes gewählte Repository führt das Skript Folgendes aus:
1. Kopiert es in `<Installationsverzeichnis>/` (Standard: `/usr/local/gladiola`)
2. Setzt `chmod 755` auf alle `.sh`-Dateien
3. Führt `make install` aus, wenn eine `Makefile` vorhanden ist (Ausgabe nur bei Fehler)

### USB-Stick nach Abschluss aushängen

```sh
doas umount /mnt/usb
```

---

## Verzeichnisstruktur

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Unter Windows ausführen, um den USB-Stick zu befüllen
├── openbsd/
│   └── install_repos.sh     # Unter OpenBSD ausführen, um vom USB-Stick zu installieren
└── README.md
```
