# WindowsOpenBSDdistributor

Gba àwọn ipamọ gladiola sí ìrìn USB lórí Windows, lẹhinna fi sórí ẹrọ OpenBSD — kódà nígbà tí ètò OpenBSD kò ní ìsopọ̀ Íńtánẹ́ẹ̀tì tààrà.

Àwọn ìwé afọwọkọ méjèjì ṣe àtìlẹyìn fún **yíyàn ìfọwọsowọpọ** kí o bàa lè yan pẹ̀lẹ́pẹ̀lẹ́ àwọn ipamọ tí o fẹ́ gba tàbí fi sórí ẹrọ lójoojúmọ́.

---

## Ìgbésẹ̀ 1 – Gba sí Ìrìn USB (Windows)

### Àwọn Ìbéèrè Àkọ́kọ́

* [Git fún Windows](https://git-scm.com/download/win) ti fi sórí ẹrọ tí ó sì wà nínú `PATH`.
* Ìrìn USB tí a ti fi sírí (bí àpẹẹrẹ, ìrìn `E:`).

### Ṣe Ìwé Afọwọkọ PowerShell

```powershell
# Gbà láàyè ìṣe àwọn ìwé afọwọkọ àdúgbò (ẹẹkan, ṣe bí Alákóso tí ó bá jẹ́ dandan)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Ipo | Àṣẹ |
|---|---|
| **Ìfọwọsowọpọ** – fèrèsé yíyàn GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Àwọn ipamọ kan pàtó** – láìsí GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Gbogbo àwọn ipamọ** – láìsí GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Pẹ̀lú àmì GitHub (gbé ìdíwọ̀n rẹ̀ ga) | ṣàfikún `-Token ghp_yourToken` sí àṣẹ èyíkéyìí lókè |

**Ipo ìfọwọsowọpọ** gba gbogbo àwọn ipamọ gladiola gbangba látọ̀dọ̀ GitHub API tí ó sì ṣí fèrèsé `Out-GridView` kan tí ó ń ṣe àkójọ àwọn orúkọ ipamọ. Dípa **Ctrl** tàbí **Shift** láti yan ọ̀pọ̀lọpọ̀ ipamọ, lẹhinna tẹ **OK**.

Ìwé afọwọkọ náà ń gbé kọọkan ipamọ tí a yàn sí `<LẹtaÌrìn>:\gladiola_repos\`. Bí ipamọ kan bá ti gba tẹ́lẹ̀ rí, yóò tún rẹ̀ sọdọ `HEAD` tí ó ń bọ̀wọ́ jùlọ.

Yọ ìrìn USB rẹ kúrò pẹ̀lẹ́pẹ̀lẹ́ nígbà tí ìwé afọwọkọ náà ń jábọ̀ àṣeyọrí.

---

## Ìgbésẹ̀ 2 – Fi Sórí Ẹrọ OpenBSD

### Àwọn Ìbéèrè Àkọ́kọ́

* Àṣẹ root (tàbí `doas`) lórí ẹrọ OpenBSD.
* Ìrìn USB tí a ti sopọ̀ mọ́ ẹrọ OpenBSD lára.

### Sòkè Ìrìn USB

```sh
# Rí orúkọ ẹrọ náà (wá ìrìn USB, ní ọ̀pọ̀lọpọ̀ ìgbà ni sd1 tàbí sd2)
sysctl hw.disknames

# Sòkè rẹ̀ (rọ́pò sd1i pẹ̀lú àpínlẹ̀ gangan rẹ)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Ṣe Ìwé Afọwọkọ Fídísórí

| Ipo | Àṣẹ |
|---|---|
| **Ìfọwọsowọpọ** – àkójọ pẹ̀lú nọ́mbà | `doas sh openbsd/install_repos.sh` |
| **Àwọn ipamọ kan pàtó** – láìsí àkójọ | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Gbogbo àwọn ipamọ** – láìsí àkójọ | `doas sh openbsd/install_repos.sh -a` |
| Orísun / ìbùdó àánú | ṣàfikún `-s /mnt/usbkey -d /home/olùmúlò/gladiola` |

**Ipo ìfọwọsowọpọ** ń ṣe àkójọ gbogbo ipamọ tí a rí nínú `gladiola_repos/` lórí ìrìn USB pẹ̀lú nọ́mbà kan, lẹhinna béèrè lọ́wọ́ rẹ láti tẹ àwọn nọ́mbà tí o fẹ́ (bí àpẹẹrẹ `1 3 5`). Tẹ **Tẹ̀ Wọlé** láìsí títẹ sí láti fi gbogbo wọn sórí ẹrọ.

Fún kọọkan ipamọ tí a yàn, ìwé afọwọkọ náà:
1. Ń ràn án lọ sí `<ìpamọ̀_fídísórí>/` (àdédé: `/usr/local/gladiola`)
2. Ṣeto `chmod 755` lórí gbogbo fáìlì `.sh`
3. Ṣe `make install` tí `Makefile` bá wà (ìfihàn àbájáde fún àsìmọ́tẹlẹ̀ nìkan)

### Sọ Ìrìn USB Kúrò Nígbà Tí O Parí

```sh
doas umount /mnt/usb
```

---

## Ètò Àkọọ́lẹ̀

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Ṣe lórí Windows láti kún ìrìn USB
├── openbsd/
│   └── install_repos.sh     # Ṣe lórí OpenBSD láti fi sórí ẹrọ látọwọ ìrìn USB
└── README.md
```
