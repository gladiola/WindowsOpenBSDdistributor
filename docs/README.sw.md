# WindowsOpenBSDdistributor

Pakua hifadhi za gladiola kwenye hifadhi ya USB kwenye Windows, kisha uzisanikishe kwenye mashine ya OpenBSD — hata wakati mfumo wa OpenBSD hauna ufikiaji wa moja kwa moja wa Intaneti.

Hati mbili zinaunga mkono **uteuzi wa mwingiliano** ili uweze kuchagua hasa ni hifadhi zipi za kupakua au kusanikisha kila wakati.

---

## Hatua ya 1 – Pakua kwenye Hifadhi ya USB (Windows)

### Mahitaji ya Awali

* [Git kwa Windows](https://git-scm.com/download/win) imewekwa na ipo kwenye `PATH`.
* Hifadhi ya USB imeunganishwa (mfano, hifadhi `E:`).

### Endesha Hati ya PowerShell

```powershell
# Ruhusu utekelezaji wa hati za ndani (mara moja, endesha kama Msimamizi ikiwa inahitajika)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Hali | Amri |
|---|---|
| **Mwingiliano** – dirisha la kuchagua GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Hifadhi maalum** – bila GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Hifadhi zote** – bila GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Na tokeni ya GitHub (inaongeza kikomo cha kasi) | ongeza `-Token ghp_tokenYako` kwa amri yoyote hapo juu |

**Hali ya mwingiliano** hupata hifadhi zote za umma za gladiola kutoka kwa API ya GitHub na hufungua dirisha la `Out-GridView` linaloonyesha majina ya hifadhi. Shika **Ctrl** au **Shift** kuchagua hifadhi nyingi, kisha bonyeza **Sawa**.

Hati huiga kila hifadhi iliyochaguliwa kwenye `<HerufuHifadhi>:\gladiola_repos\`. Ikiwa hifadhi tayari ilichaguliwa hapo awali, itapata na kuweka upya hadi `HEAD` ya hivi karibuni.

Toa hifadhi ya USB kwa usalama wakati hati inaripoti mafanikio.

---

## Hatua ya 2 – Sanikisha kwenye OpenBSD

### Mahitaji ya Awali

* Ufikiaji wa root (au `doas`) kwenye mashine ya OpenBSD.
* Hifadhi ya USB imeunganishwa kimwili na mashine ya OpenBSD.

### Weka Hifadhi ya USB

```sh
# Pata jina la kifaa (tafuta hifadhi ya USB, mara nyingi sd1 au sd2)
sysctl hw.disknames

# Iweke (badilisha sd1i na kizigeu chako halisi)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Endesha Hati ya Usanikishaji

| Hali | Amri |
|---|---|
| **Mwingiliano** – menyu ya nambari | `doas sh openbsd/install_repos.sh` |
| **Hifadhi maalum** – bila menyu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Hifadhi zote** – bila menyu | `doas sh openbsd/install_repos.sh -a` |
| Chanzo / marudio maalum | ongeza `-s /mnt/usbkey -d /home/mtumiaji/gladiola` |

**Hali ya mwingiliano** inaonyesha orodha ya hifadhi zote zilizopo katika `gladiola_repos/` kwenye hifadhi ya USB na nambari, kisha inakuomba uingize nambari unazotaka (mfano `1 3 5`). Bonyeza **Enter** bila uingizaji ili kusanikisha kila kitu.

Kwa kila hifadhi iliyochaguliwa, hati inafanya:
1. Kuiiga kwenye `<saraka_usanikishaji>/` (chaguo-msingi: `/usr/local/gladiola`)
2. Kuweka `chmod 755` kwenye faili zote za `.sh`
3. Kuendesha `make install` ikiwa `Makefile` ipo (matokeo yanaonyeshwa tu wakati wa kushindwa)

### Ondoa Hifadhi ya USB Ukimaliza

```sh
doas umount /mnt/usb
```

---

## Mpangilio wa Saraka

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Endesha kwenye Windows kujaza hifadhi ya USB
├── openbsd/
│   └── install_repos.sh     # Endesha kwenye OpenBSD kusanikisha kutoka hifadhi ya USB
└── README.md
```
