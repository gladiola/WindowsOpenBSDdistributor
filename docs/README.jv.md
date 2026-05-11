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

| Kanthi token GitHub (wates rate luwih dhuwur) | tambahna `-Token ghp_yourToken` ing salah siji printah ing ndhuwur |

**Mode interaktif** njupuk kabeh repo gladiola publik saka GitHub API lan mbukak jendhela `Out-GridView` sing nampilake jeneng repo. Tahan **Ctrl** utawa **Shift** kanggo milih akeh repo, banjur klik **OK**.

Skrip bakal nge-clone saben repo sing dipilih menyang `<DriveLetter>:\\gladiola_repos\\`. Yen repo wis tau di-clone sadurunge, skrip bakal fetch lan reset menyang `HEAD` paling anyar.

Copot USB drive kanthi aman nalika skrip nglaporake sukses.

---

## Langkah 2 – Pasang ing OpenBSD

### Syarat

* Duwe akses root utawa `doas` ing OpenBSD.
* Drive USB kasambung menyang mesin OpenBSD.

### Mount USB

```sh
# Goleki jeneng piranti (goleki USB drive, biasane sd1 utawa sd2)
sysctl hw.disknames

# Mount piranti (ganti sd1i nganggo partisi nyata sampeyan)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Jalanake skrip instalasi

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Mode interaktif** ndhaptar saben repo sing ditemokake ing `gladiola_repos/` ing USB nganggo nomer, banjur njaluk sampeyan ngetik nomer sing dikarepake (umpamane `1 3 5`). Pencet **Enter** tanpa input kanggo nginstal kabeh.

Kanggo saben repositori sing dipilih, skrip bakal:
1. Nyalin menyang `<install_dir>/` (gawan `/usr/local/gladiola`)
2. Nyetel `chmod 755` kanggo kabeh file `.sh`
3. Mlakuake `make install` yen ana `Makefile` (output mung dituduhake nalika gagal)

### Unmount yen wis rampung

```sh
doas umount /mnt/usb
```
