# WindowsOpenBSDdistributor

Завантажуйте репозиторії gladiola на USB-носій у Windows і встановлюйте їх на OpenBSD-машину, навіть якщо OpenBSD не має прямого доступу до інтернету.

Обидва скрипти підтримують **інтерактивний вибір**, тому ви можете щоразу точно обирати потрібні репозиторії.

---

## Крок 1 — Завантаження на USB (Windows)

### Передумови

* Встановлено [Git for Windows](https://git-scm.com/download/win), доступний у `PATH`.
* Підключений USB-носій (наприклад, `E:`).

### Запустіть скрипт PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Режим | Команда |
|---|---|
| **Інтерактивний** – GUI-вибір | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Вибрані репозиторії** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Усі репозиторії** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| З токеном GitHub (вищий ліміт запитів) | додайте `-Token ghp_yourToken` до будь-якої команди вище |

**Інтерактивний режим** отримує всі публічні репозиторії gladiola через GitHub API і відкриває вікно `Out-GridView` зі списком назв репозиторіїв. Утримуйте **Ctrl** або **Shift** для вибору кількох репозиторіїв, потім натисніть **OK**.

Скрипт клонує кожен вибраний репозиторій у `<DriveLetter>:\\gladiola_repos\\`. Якщо репозиторій уже був клонований раніше, виконується fetch і скидання до найновішого `HEAD`.

Безпечно витягніть USB-накопичувач, коли скрипт повідомить про успіх.

---

## Крок 2 — Встановлення на OpenBSD

### Передумови

* Доступ root або `doas` на OpenBSD.
* USB-носій фізично підключений до OpenBSD.

### Змонтуйте USB

```sh
# Знайдіть назву пристрою (шукайте USB-накопичувач, часто sd1 або sd2)
sysctl hw.disknames

# Змонтуйте його (замініть sd1i на ваш фактичний розділ)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Запустіть скрипт встановлення

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Інтерактивний режим** показує кожен репозиторій, знайдений у `gladiola_repos/` на USB-накопичувачі, з номером, а потім просить ввести потрібні номери (наприклад, `1 3 5`). Натисніть **Enter** без введення, щоб встановити все.

Для кожного вибраного репозиторію скрипт:
1. Копіює його до `<install_dir>/` (типово `/usr/local/gladiola`)
2. Встановлює `chmod 755` для всіх файлів `.sh`
3. Запускає `make install`, якщо присутній `Makefile` (вивід показується лише у разі помилки)

### Відмонтуйте після завершення

```sh
doas umount /mnt/usb
```
