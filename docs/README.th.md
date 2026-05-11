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

---

## ขั้นตอนที่ 2 – ติดตั้งบน OpenBSD

### ข้อกำหนดเบื้องต้น

* มีสิทธิ์ root หรือ `doas` บน OpenBSD
* USB เชื่อมต่อกับเครื่อง OpenBSD

### เมานต์ USB

```sh
sysctl hw.disknames
doas mount -t msdos /dev/sd1i /mnt/usb
```

### รันสคริปต์ติดตั้ง

```sh
doas sh openbsd/install_repos.sh
```

### ยกเลิกเมานต์เมื่อเสร็จ

```sh
doas umount /mnt/usb
```
