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

---

## Steg 2 – Installera på OpenBSD

### Förkrav

* Root- eller `doas`-åtkomst på OpenBSD.
* USB-minnet anslutet till OpenBSD-maskinen.

### Montera USB-minnet

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Kör installationsskriptet

```sh
doas sh openbsd/install_repos.sh
```

### Avmontera när du är klar

```sh
doas umount /mnt/usb
```
