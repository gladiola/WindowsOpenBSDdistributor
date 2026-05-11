# WindowsOpenBSDdistributor

Undhuh repositori gladiola menyang drive USB ing Windows, banjur pasang ing mesin OpenBSD sanajan OpenBSD ora nduweni akses internet langsung.

Loro skrip iki ndhukung **pilihan interaktif**, supaya sampeyan bisa milih repositori sing pas kanggo diundhuh utawa dipasang saben wektu.

---

## Langkah 1 – Undhuh menyang USB (Windows)

### Syarat

* [Git for Windows](https://git-scm.com/download/win) wis dipasang lan kasedhiya ing `PATH`.
* Drive USB wis kasambung (umpamane `E:`).

### Jalanake skrip PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Prentah |
|---|---|
| **Interaktif** – pilihan GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositori tartamtu** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Kabeh repositori** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Langkah 2 – Pasang ing OpenBSD

### Syarat

* Duwe akses root utawa `doas` ing OpenBSD.
* Drive USB kasambung menyang mesin OpenBSD.

### Mount USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalanake skrip instalasi

```sh
doas sh openbsd/install_repos.sh
```

### Unmount yen wis rampung

```sh
doas umount /mnt/usb
```
