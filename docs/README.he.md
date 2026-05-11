# WindowsOpenBSDdistributor

הורד מאגרי gladiola לכונן USB ב-Windows, ואז התקן אותם על מכונת OpenBSD גם כאשר אין למערכת OpenBSD גישה ישירה לאינטרנט.

שני הסקריפטים תומכים ב-**בחירה אינטראקטיבית**, כך שאפשר לבחור בדיוק אילו מאגרים להוריד או להתקין בכל פעם.

---

## שלב 1 – הורדה ל-USB (Windows)

### דרישות מוקדמות

* [Git for Windows](https://git-scm.com/download/win) מותקן וזמין ב-`PATH`.
* כונן USB מחובר (למשל `E:`).

### הרץ את סקריפט PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| מצב | פקודה |
|---|---|
| **אינטראקטיבי** – חלון בחירה GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **מאגרים מסוימים** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **כל המאגרים** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

---

## שלב 2 – התקנה על OpenBSD

### דרישות מוקדמות

* הרשאות root או `doas` ב-OpenBSD.
* כונן ה-USB מחובר פיזית למכונת OpenBSD.

### עגן את כונן ה-USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### הרץ את סקריפט ההתקנה

```sh
doas sh openbsd/install_repos.sh
```

### נתק עגינה בסיום

```sh
doas umount /mnt/usb
```
