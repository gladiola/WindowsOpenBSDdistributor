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

---

## Крок 2 — Встановлення на OpenBSD

### Передумови

* Доступ root або `doas` на OpenBSD.
* USB-носій фізично підключений до OpenBSD.

### Змонтуйте USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Запустіть скрипт встановлення

```sh
doas sh openbsd/install_repos.sh
```

### Відмонтуйте після завершення

```sh
doas umount /mnt/usb
```
