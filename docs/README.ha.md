# WindowsOpenBSDdistributor

Zazzage ma'ajan gladiola zuwa USB drive a kan Windows, sannan ka girka su a kan na'urar OpenBSD — ko da yake tsarin OpenBSD ba shi da damar Intanet kai tsaye.

Rubututtukan biyu suna goyan bayan **zabin hulɗa** don ku iya zaɓar daidai waɗanne ma'ajanin za ku zazzage ko girka kowane lokaci.

---

## Mataki na 1 – Zazzage zuwa USB Drive (Windows)

### Buƙatun Farko

* [Git don Windows](https://git-scm.com/download/win) an girka kuma yana cikin `PATH`.
* USB drive an haɗa (misali, fayil `E:`).

### Gudanar da Rubutun PowerShell

```powershell
# Ba da izinin gudanar da rubutun gida (sau ɗaya, gudanar a matsayin Mai Gudanarwa idan ya cancanta)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Yanayi | Umarni |
|---|---|
| **Hulɗa** – taga zaɓin GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Ma'ajanan da aka zaɓa** – ba GUI ba | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Dukkan ma'ajanan** – ba GUI ba | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Da alamar GitHub (yana ƙara iyaka) | ƙara `-Token ghp_alamarKa` ga kowane umarni a sama |

**Yanayin hulɗa** yana kawo dukkan ma'ajanan gladiola na jama'a daga GitHub API kuma yana buɗe taga `Out-GridView` da ke lissafa sunayen ma'ajanan. Riƙe **Ctrl** ko **Shift** don zaɓar ma'ajanan da yawa, sannan danna **OK**.

Rubutun yana kwafin kowane ma'ajan da aka zaɓa zuwa `<HarafiFayil>:\gladiola_repos\`. Idan an riga an kwafi ma'ajan a da, zai kawo kuma ya mayar da shi zuwa `HEAD` na ƙarshe.

Cire USB drive lafiya lokacin da rubutun ya ba da rahoton nasara.

---

## Mataki na 2 – Girka a OpenBSD

### Buƙatun Farko

* Damar root (ko `doas`) a kan na'urar OpenBSD.
* USB drive an haɗa ta jiki da na'urar OpenBSD.

### Haɗa USB Drive

```sh
# Nemo sunan na'ura (nemi USB drive, sau da yawa sd1 ko sd2)
sysctl hw.disknames

# Haɗa (maye sd1i da rarraba naka na gaske)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Gudanar da Rubutun Girka

| Yanayi | Umarni |
|---|---|
| **Hulɗa** – menu mai lamba | `doas sh openbsd/install_repos.sh` |
| **Ma'ajanan da aka zaɓa** – ba menu ba | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Dukkan ma'ajanan** – ba menu ba | `doas sh openbsd/install_repos.sh -a` |
| Tushe / manufa ta musamman | ƙara `-s /mnt/usbkey -d /home/maisaya/gladiola` |

**Yanayin hulɗa** yana lissafa kowane ma'ajan da aka samu a `gladiola_repos/` a kan USB drive tare da lamba, sannan yana roƙonka ka shigar da lambobin da kake so (misali `1 3 5`). Danna **Shigar** ba tare da shigarwa ba don girka komai.

Don kowane ma'ajan da aka zaɓa, rubutun yana:
1. Kwafa zuwa `<jagorar_girka>/` (tsoho: `/usr/local/gladiola`)
2. Saita `chmod 755` a duk fayilolin `.sh`
3. Gudanar da `make install` idan `Makefile` yana nan (fitarwa an nuna kawai a ɓacewa)

### Cire USB Drive Lokacin Gama

```sh
doas umount /mnt/usb
```

---

## Tsarin Jagorar

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Gudanar a Windows don cika USB drive
├── openbsd/
│   └── install_repos.sh     # Gudanar a OpenBSD don girka daga USB drive
└── README.md
```
