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

| Dengan token GitHub (had kadar lebih tinggi) | tambah `-Token ghp_yourToken` pada mana-mana arahan di atas |

**Mod interaktif** mengambil semua repo gladiola awam daripada GitHub API dan membuka tetingkap `Out-GridView` yang menyenaraikan nama repo. Tahan **Ctrl** atau **Shift** untuk pilih berbilang repo, kemudian klik **OK**.

Skrip mengklon setiap repo yang dipilih ke `<DriveLetter>:\\gladiola_repos\\`. Jika repo sudah pernah diklon sebelum ini, skrip akan fetch dan reset kepada `HEAD` terkini.

Keluarkan pemacu USB dengan selamat apabila skrip melaporkan berjaya.

---

## Langkah 2 – Pasang pada OpenBSD

### Prasyarat

* Akses root atau `doas` pada OpenBSD.
* Pemacu USB disambungkan ke mesin OpenBSD.

### Lekapkan USB

```sh
# Cari nama peranti (cari pemacu USB, biasanya sd1 atau sd2)
sysctl hw.disknames

# Mountkannya (gantikan sd1i dengan partisi sebenar anda)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalankan skrip pemasangan

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Mod interaktif** menyenaraikan setiap repo yang ditemui dalam `gladiola_repos/` pada pemacu USB dengan nombor, kemudian meminta anda memasukkan nombor yang dikehendaki (cth. `1 3 5`). Tekan **Enter** tanpa input untuk memasang semuanya.

Bagi setiap repositori yang dipilih, skrip akan:
1. Menyalinnya ke `<install_dir>/` (lalai `/usr/local/gladiola`)
2. Menetapkan `chmod 755` pada semua fail `.sh`
3. Menjalankan `make install` jika `Makefile` wujud (output dipaparkan hanya apabila gagal)

### Nyahlekap apabila selesai

```sh
doas umount /mnt/usb
```
