# WindowsOpenBSDdistributor

የ gladiola ማከማቻዎችን በ Windows ላይ ወደ USB ድራይቭ ያውርዱ፣ ከዚያ ወደ OpenBSD ማሽን ይጫኑ — OpenBSD ስርዓቱ ቀጥተኛ የኢንተርኔት ድረስ ባይኖረውም ይሰራል።

ሁለቱም ስክሪፕቶች **ተጋቢ ምርጫ**ን ይደግፋሉ፣ ስለዚህ በእያንዳንዱ ጊዜ ምን ማከማቻዎችን ማውረድ ወይም መጫን እንደሚፈልጉ ትክክለኛ ምርጫ ማድረግ ይችላሉ።

---

## ደረጃ 1 – ወደ USB ድራይቭ ያውርዱ (Windows)

### ቅድመ ሁኔታዎች

* [Git ለ Windows](https://git-scm.com/download/win) ተጭኖ በ `PATH` ውስጥ ይሁን።
* USB ድራይቭ ተሰኪ (ለምሳሌ፣ ድራይቭ `E:`)።

### የ PowerShell ስክሪፕቱን ያሂዱ

```powershell
# የአካባቢ ስክሪፕቶችን ማሂደት ፍቀዱ (አንድ ጊዜ፣ አስፈላጊ ከሆነ እንደ አስተዳዳሪ ያሂዱ)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| ሁኔታ | ትዕዛዝ |
|---|---|
| **ተጋቢ** – የ GUI ምርጫ መስኮት | `.\windows\download_repos.ps1 -DriveLetter E` |
| **ልዩ ማከማቻዎች** – ያለ GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **ሁሉም ማከማቻዎች** – ያለ GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| ከ GitHub ቶከን ጋር (የፍጥነት ገደቡን ይጨምራል) | ወደ ማንኛውም ከላይ ትዕዛዝ `-Token ghp_yourToken` ያክሉ |

**ተጋቢ ሁኔታ** ሁሉንም የ gladiola ህዝባዊ ማከማቻዎችን ከ GitHub API ያመጣና የማከማቻ ስሞችን የሚዘረዝር `Out-GridView` መስኮት ይከፍታል። ብዙ ማከማቻዎችን ለመምረጥ **Ctrl** ወይም **Shift** ይያዙ፣ ከዚያ **እሺ** ይጫኑ።

ስክሪፕቱ እያንዳንዱን የተመረጠ ማከማቻ ወደ `<ድራይቭ ፊደል>:\gladiola_repos\` ይቅዳል። ማከማቻ ቀደም ሲል ተቀድቶ ከነበረ፣ ወደ ቅርብ `HEAD` ያመጣና ይመልሳል።

ስክሪፕቱ ስኬት ሲዘግብ USB ድራይቩን በጥንቃቄ ያስወጡ።

---

## ደረጃ 2 – በ OpenBSD ላይ ይጫኑ

### ቅድመ ሁኔታዎች

* በ OpenBSD ማሽን ላይ root (ወይም `doas`) ድረስ።
* USB ድራይቭ ከ OpenBSD ማሽን ጋር አካላዊ ሲሆን ተሰካ።

### USB ድራይቩን ያሰኩ

```sh
# የኦፕሬቲንግ ስርዓቱ ስም ያግኙ (USB ድራይቭ ይፈልጉ፣ ብዙ ጊዜ sd1 ወይም sd2)
sysctl hw.disknames

# ያሰኩ (sd1i ወደ ትክክለኛ ክፍልዎ ይቀይሩ)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### የጭነት ስክሪፕቱን ያሂዱ

| ሁኔታ | ትዕዛዝ |
|---|---|
| **ተጋቢ** – ቁጥር ያለው ምናሌ | `doas sh openbsd/install_repos.sh` |
| **ልዩ ማከማቻዎች** – ያለ ምናሌ | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **ሁሉም ማከማቻዎች** – ያለ ምናሌ | `doas sh openbsd/install_repos.sh -a` |
| ብጁ ምንጭ / መዳረሻ | `-s /mnt/usbkey -d /home/myuser/gladiola` ያክሉ |

**ተጋቢ ሁኔታ** በ USB ድራይቭ ላይ ባለ `gladiola_repos/` ውስጥ የተገኘ እያንዳንዱን ማከማቻ በቁጥር ይዘረዝርና ከዚያ የሚፈልጓቸውን ቁጥሮች (ለምሳሌ `1 3 5`) እንዲያስገቡ ይጠይቃቸዋል። ሁሉንም ለመጫን ያለ ግቤት **Enter** ይጫኑ።

ለእያንዳንዱ የተመረጠ ማከማቻ፣ ስክሪፕቱ፦
1. ወደ `<የጭነት ማህደር>/` ይቅዳዋል (ነባሪ፦ `/usr/local/gladiola`)
2. ሁሉም `.sh` ፋይሎች ላይ `chmod 755` ያዘጋጃል
3. `Makefile` ካለ `make install` ያሂዳል (ውጤቱ የሚታየው ያለ ስኬት ሲሆን ብቻ ነው)

### ሲጨርሱ USB ድራይቩን ያውጡ

```sh
doas umount /mnt/usb
```

---

## የፋይል ማህደር አቀማመጥ

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # USB ድራይቭ ለሞልት በ Windows ይሂዱ
├── openbsd/
│   └── install_repos.sh     # ከ USB ድራይቭ ለመጫን በ OpenBSD ይሂዱ
└── README.md
```
