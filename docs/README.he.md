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

| עם טוקן GitHub (מגבלת קצב גבוהה יותר) | הוסף `-Token ghp_yourToken` לכל אחת מהפקודות למעלה |

**מצב אינטראקטיבי** מושך את כל מאגרי gladiola הציבוריים מ-GitHub API ופותח חלון `Out-GridView` עם שמות המאגרים. החזק **Ctrl** או **Shift** כדי לבחור כמה מאגרים, ואז לחץ **OK**.

הסקריפט משכפל כל מאגר שנבחר אל `<DriveLetter>:\\gladiola_repos\\`. אם המאגר כבר שוכפל בעבר, הוא יבצע fetch ויאפס ל-`HEAD` העדכני ביותר.

הוצא את כונן ה-USB בצורה בטוחה כשהסקריפט מדווח על הצלחה.

---

## שלב 2 – התקנה על OpenBSD

### דרישות מוקדמות

* הרשאות root או `doas` ב-OpenBSD.
* כונן ה-USB מחובר פיזית למכונת OpenBSD.

### עגן את כונן ה-USB

```sh
# מצא את שם ההתקן (חפש את כונן ה-USB, בדרך כלל sd1 או sd2)
sysctl hw.disknames

# בצע עגינה (החלף את sd1i במחיצה בפועל שלך)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### הרץ את סקריפט ההתקנה

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**מצב אינטראקטיבי** מציג כל מאגר שנמצא ב-`gladiola_repos/` שעל כונן ה-USB עם מספר, ואז מבקש להזין את המספרים הרצויים (לדוגמה `1 3 5`). לחץ **Enter** ללא קלט כדי להתקין הכול.

לכל מאגר שנבחר הסקריפט:
1. מעתיק אותו אל `<install_dir>/` (ברירת מחדל `/usr/local/gladiola`)
2. מגדיר `chmod 755` לכל קבצי `.sh`
3. מריץ `make install` אם קיים `Makefile` (פלט מוצג רק במקרה של כשל)

### נתק עגינה בסיום

```sh
doas umount /mnt/usb
```
