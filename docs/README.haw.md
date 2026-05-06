# WindowsOpenBSDdistributor

E hoʻoiho i nā waihona gladiola i loko o kahi paʻa USB ma Windows, a laila hoʻonohonoho iā lākou ma kahi mīkini OpenBSD — ʻoiai ʻaʻohe hoʻohui pono ʻana i ka Pūnaewele o ka ʻōnaehana OpenBSD.

Ke kākoʻo nei nā palapala hana ʻelua i ka **koho hoʻopili** i hiki ai iā ʻoe ke koho pono i nā waihona e hoʻoiho a hoʻonohonoho i kēlā me kēia manawa.

---

## Kaʻina 1 – Hoʻoiho i ka USB (Windows)

### Nā Koi Mua

* Hoʻokomo ʻia [Git no Windows](https://git-scm.com/download/win) a aia ma `PATH`.
* Kūkulu ʻia kahi paʻa USB (e laʻa, paʻa `E:`).

### Holo i ka Palapala Hana PowerShell

```powershell
# E ʻae i ka holo ʻana o nā palapala hana kūloko (hoʻokahi manawa, holo ma ke ʻano Administrateka inā pono)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Ala | Kauoha |
|---|---|
| **Hoʻopili** – puka aniani koho GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Nā waihona koho** – ʻaʻohe GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Nā waihona āpau** – ʻaʻohe GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Me ka hōʻailona GitHub (e hoʻonui i ka palena nui) | e hoʻohui `-Token ghp_yourToken` i kekahi kauoha ma luna |

**Ka ala hoʻopili** e lawe mai ana i nā waihona gladiola lehulehu āpau mai ka API o GitHub a wehe i ka puka aniani `Out-GridView` e hōʻike ana i nā inoa waihona. E paʻi mau iho **Ctrl** a i ʻole **Shift** e koho i nā waihona he nui, a laila kaomi **OK**.

Ke kope nei ka palapala hana i kēlā me kēia waihona i koho ʻia i loko o `<HuaʻōleLo>:\gladiola_repos\`. Inā ua kope mua ʻia kahi waihona, e lawe hou a hoʻihoʻi i ka `HEAD` hou loa.

E hoʻopau pono i ka paʻa USB ke hōʻike ka palapala hana i ka lanakila.

---

## Kaʻina 2 – Hoʻonohonoho ma OpenBSD

### Nā Koi Mua

* Ke komo ʻana root (a i ʻole `doas`) ma ka mīkini OpenBSD.
* Ua hoʻopili kino ʻia ka USB i ka mīkini OpenBSD.

### Kau i ka USB

```sh
# E ʻimi i ka inoa o ka mea hana (e nānā i ka USB, ʻo sd1 a sd2 paha)
sysctl hw.disknames

# E kau (e hoʻololi i sd1i me kāu mahele maoli)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Holo i ka Palapala Hana Hoʻonohonoho

| Ala | Kauoha |
|---|---|
| **Hoʻopili** – papa inoa helu | `doas sh openbsd/install_repos.sh` |
| **Nā waihona koho** – ʻaʻohe papa inoa | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Nā waihona āpau** – ʻaʻohe papa inoa | `doas sh openbsd/install_repos.sh -a` |
| Kumu / paʻa kūmākena | e hoʻohui `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Ka ala hoʻopili** e hōʻike ana i nā waihona āpau i loaʻa ma `gladiola_repos/` ma ka USB me kahi helu, a laila noi iā ʻoe e komo i nā helu āu e makemake ai (e laʻa `1 3 5`). Kaomi **Enter** me ka ʻole o ka komo e hoʻonohonoho i nā mea āpau.

No kēlā me kēia waihona i koho ʻia, ke hana nei ka palapala hana:
1. Kope iā ia i `<papa kuhikuhi hoʻonohonoho>/` (paʻamau: `/usr/local/gladiola`)
2. Hoʻonoho `chmod 755` ma nā faila `.sh` āpau
3. Holo `make install` inā aia kahi `Makefile` (hōʻike wale ʻia ka hopena ke kuʻi)

### Wehe i ka USB ke Pau

```sh
doas umount /mnt/usb
```

---

## Ka Hāʻawi o ka Papa Kuhikuhi

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Holo ma Windows e hoʻopiha i ka USB
├── openbsd/
│   └── install_repos.sh     # Holo ma OpenBSD e hoʻonohonoho mai ka USB
└── README.md
```
