# WindowsOpenBSDdistributor

ดาวน์โหลดรีโพสิตอรี gladiola ลงแฟลชไดรฟ์ USB บน Windows แล้วติดตั้งบนเครื่อง OpenBSD ได้ แม้ระบบ OpenBSD จะไม่มีอินเทอร์เน็ตโดยตรง

สคริปต์ทั้งสองรองรับ **การเลือกแบบโต้ตอบ** เพื่อให้คุณเลือกรีโพสิตอรีที่ต้องการดาวน์โหลดหรือติดตั้งได้อย่างแม่นยำทุกครั้ง

---

## ขั้นตอนที่ 1 – ดาวน์โหลดลง USB (Windows)

### ข้อกำหนดเบื้องต้น

* ติดตั้ง [Git for Windows](https://git-scm.com/download/win) และอยู่ใน `PATH`
* เสียบไดรฟ์ USB (เช่น `E:`)

### รันสคริปต์ PowerShell

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| โหมด | คำสั่ง |
|---|---|
| **โต้ตอบ** – หน้าต่างเลือกแบบ GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **ระบุรีโพเฉพาะ** | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **ทุกรีโพ** | `.\windows\download_repos.ps1 -DriveLetter E -All` |

| With a GitHub token (raises rate limit) | add `-Token ghp_yourToken` to any command above |

**Interactive mode** fetches all public gladiola repos from the GitHub API and opens an `Out-GridView` window listing repo names. Hold **Ctrl** or **Shift** to select multiple repos, then click **OK**.

The script clones each chosen repo into `<DriveLetter>:\\gladiola_repos\\`. If a repo was already cloned previously it fetches and resets to the latest `HEAD` instead.

Safely eject the USB drive when the script reports success.

---

## ขั้นตอนที่ 2 – ติดตั้งบน OpenBSD

### ข้อกำหนดเบื้องต้น

* มีสิทธิ์ root หรือ `doas` บน OpenBSD
* USB เชื่อมต่อกับเครื่อง OpenBSD

### เมานต์ USB

```sh
# Find the device name (look for the USB drive, often sd1 or sd2)
sysctl hw.disknames

# Mount it (replace sd1i with your actual partition)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### รันสคริปต์ติดตั้ง

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

### ยกเลิกเมานต์เมื่อเสร็จ

```sh
doas umount /mnt/usb
```
