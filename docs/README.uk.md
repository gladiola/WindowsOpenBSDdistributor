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

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## Крок 2 — Встановлення на OpenBSD

### Передумови

* Доступ root або `doas` на OpenBSD.
* USB-носій фізично підключений до OpenBSD.

### Змонтуйте USB

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Запустіть скрипт встановлення

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**Interactive mode** lists every repo found in `gladiola_repos/` on the USB drive with a number, then prompts you to enter the numbers you want (e.g. `1 3 5`). Press **Enter** with no input to install everything.

For each selected repository the script:
1. Copies it to `<install_dir>/` (default `/usr/local/gladiola`)
2. Sets `chmod 755` on all `.sh` files
3. Runs `make install` if a `Makefile` is present (output shown only on failure)

### Відмонтуйте після завершення

```sh
doas umount /mnt/usb
```
