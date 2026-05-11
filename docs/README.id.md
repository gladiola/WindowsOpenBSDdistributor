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

| Dengan token GitHub (batas rate lebih tinggi) | tambahkan `-Token ghp_yourToken` ke perintah mana pun di atas |

**Mode interaktif** mengambil semua repo publik gladiola dari GitHub API dan membuka jendela `Out-GridView` yang menampilkan nama repo. Tahan **Ctrl** atau **Shift** untuk memilih beberapa repo, lalu klik **OK**.

Skrip akan meng-clone setiap repo yang dipilih ke `<DriveLetter>:\\gladiola_repos\\`. Jika repo sudah pernah di-clone sebelumnya, skrip akan fetch dan reset ke `HEAD` terbaru.

Keluarkan USB drive dengan aman saat skrip melaporkan berhasil.

---

## Langkah 2 – Pasang di OpenBSD

### Prasyarat

* Akses root atau `doas` di OpenBSD.
* Drive USB tersambung ke mesin OpenBSD.

### Mount USB

```sh
# Cari nama perangkat (lihat USB drive, biasanya sd1 atau sd2)
sysctl hw.disknames

# Mount perangkat (ganti sd1i dengan partisi yang sesuai)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalankan skrip instalasi

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Mode interaktif** menampilkan setiap repo yang ditemukan di `gladiola_repos/` pada USB dengan nomor, lalu meminta Anda memasukkan nomor yang diinginkan (mis. `1 3 5`). Tekan **Enter** tanpa input untuk menginstal semuanya.

Untuk setiap repositori yang dipilih, skrip akan:
1. Menyalinnya ke `<install_dir>/` (default `/usr/local/gladiola`)
2. Menetapkan `chmod 755` pada semua file `.sh`
3. Menjalankan `make install` jika ada `Makefile` (output hanya ditampilkan saat gagal)

### Unmount setelah selesai

```sh
doas umount /mnt/usb
```
