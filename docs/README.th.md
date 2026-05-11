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

| ใช้ GitHub token (เพิ่มขีดจำกัดการเรียกใช้งาน) | เพิ่ม `-Token ghp_yourToken` ในคำสั่งใดก็ได้ด้านบน |

**โหมดโต้ตอบ** จะดึงรีโปสาธารณะของ gladiola ทั้งหมดจาก GitHub API และเปิดหน้าต่าง `Out-GridView` ที่แสดงรายชื่อรีโป กด **Ctrl** หรือ **Shift** เพื่อเลือกหลายรายการ แล้วคลิก **OK**.

สคริปต์จะโคลนรีโปที่เลือกแต่ละรายการไปยัง `<DriveLetter>:\\gladiola_repos\\` หากรีโปถูกโคลนไว้แล้ว สคริปต์จะ fetch และรีเซ็ตไปยัง `HEAD` ล่าสุดแทน.

ถอด USB อย่างปลอดภัยเมื่อสคริปต์รายงานว่าสำเร็จ.

---

## ขั้นตอนที่ 2 – ติดตั้งบน OpenBSD

### ข้อกำหนดเบื้องต้น

* มีสิทธิ์ root หรือ `doas` บน OpenBSD
* USB เชื่อมต่อกับเครื่อง OpenBSD

### เมานต์ USB

```sh
# ค้นหาชื่ออุปกรณ์ (มองหา USB ซึ่งมักเป็น sd1 หรือ sd2)
sysctl hw.disknames

# เมานต์อุปกรณ์ (แทนที่ sd1i ด้วยพาร์ทิชันจริงของคุณ)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### รันสคริปต์ติดตั้ง

| Mode | Command |
|---|---|
| **Interactive** – numbered menu | `doas sh openbsd/install_repos.sh` |
| **Specific repos** – no menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **All repos** – no menu | `doas sh openbsd/install_repos.sh -a` |
| Custom source / destination | add `-s /mnt/usbkey -d /home/myuser/gladiola` |

**โหมดโต้ตอบ** จะแสดงรีโปทุกตัวที่พบใน `gladiola_repos/` บน USB พร้อมหมายเลข แล้วให้คุณกรอกหมายเลขที่ต้องการ (เช่น `1 3 5`) กด **Enter** โดยไม่กรอกอะไรเพื่อให้ติดตั้งทั้งหมด.

สำหรับแต่ละรีโปที่เลือก สคริปต์จะ:
1. คัดลอกไปยัง `<install_dir>/` (ค่าเริ่มต้น `/usr/local/gladiola`)
2. ตั้งค่า `chmod 755` ให้ไฟล์ `.sh` ทั้งหมด
3. รัน `make install` หากมี `Makefile` (จะแสดงผลเฉพาะเมื่อเกิดข้อผิดพลาด)

### ยกเลิกเมานต์เมื่อเสร็จ

```sh
doas umount /mnt/usb
```
