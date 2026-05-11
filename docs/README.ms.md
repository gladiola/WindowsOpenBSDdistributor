# WindowsOpenBSDdistributor

Muat turun repositori gladiola ke pemacu USB di Windows, kemudian pasang pada mesin OpenBSD walaupun OpenBSD tidak mempunyai akses internet langsung.

Kedua-dua skrip menyokong **pemilihan interaktif**, jadi anda boleh memilih repositori yang tepat untuk dimuat turun atau dipasang setiap kali.

---

## Langkah 1 – Muat turun ke USB (Windows)

### Prasyarat

* [Git for Windows](https://git-scm.com/download/win) dipasang dan tersedia dalam `PATH`.
* Pemacu USB disambungkan (contohnya `E:`).

### Jalankan skrip PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mod | Perintah |
|---|---|
| **Interaktif** – pemilih GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositori tertentu** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Semua repositori** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## Langkah 2 – Pasang pada OpenBSD

### Prasyarat

* Akses root atau `doas` pada OpenBSD.
* Pemacu USB disambungkan ke mesin OpenBSD.

### Lekapkan USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalankan skrip pemasangan

```sh
doas sh openbsd/install_repos.sh
```

### Nyahlekap apabila selesai

```sh
doas umount /mnt/usb
```
