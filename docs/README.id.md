# WindowsOpenBSDdistributor

Unduh repositori gladiola ke drive USB di Windows, lalu pasang di mesin OpenBSD, bahkan saat OpenBSD tidak memiliki akses internet langsung.

Kedua skrip mendukung **pemilihan interaktif**, sehingga Anda dapat memilih repositori yang tepat untuk diunduh atau dipasang setiap kali.

---

## Langkah 1 – Unduh ke USB (Windows)

### Prasyarat

* [Git for Windows](https://git-scm.com/download/win) terpasang dan tersedia di `PATH`.
* Drive USB terhubung (misalnya `E:`).

### Jalankan skrip PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Perintah |
|---|---|
| **Interaktif** – pemilih GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositori tertentu** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Semua repositori** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Langkah 2 – Pasang di OpenBSD

### Prasyarat

* Akses root atau `doas` di OpenBSD.
* Drive USB tersambung ke mesin OpenBSD.

### Mount USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalankan skrip instalasi

```sh
doas sh openbsd/install_repos.sh
```

### Unmount setelah selesai

```sh
doas umount /mnt/usb
```
