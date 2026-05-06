# WindowsOpenBSDdistributor

قم بتنزيل مستودعات gladiola إلى محرك USB على Windows، ثم ثبّتها على جهاز OpenBSD — حتى عندما لا يمتلك نظام OpenBSD اتصالاً مباشراً بالإنترنت.

يدعم كلا البرنامجَين النصيَّين **الاختيار التفاعلي** حتى تتمكن من تحديد المستودعات التي تريد تنزيلها أو تثبيتها بدقة في كل مرة.

---

## الخطوة 1 – التنزيل إلى محرك USB (Windows)

### المتطلبات الأساسية

* تثبيت [Git لنظام Windows](https://git-scm.com/download/win) وإضافته إلى `PATH`.
* توصيل محرك USB (مثلاً محرك `E:`).

### تشغيل برنامج PowerShell النصي

```powershell
# السماح بتشغيل البرامج النصية المحلية (مرة واحدة، قم بالتشغيل كمسؤول إذا لزم الأمر)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| الوضع | الأمر |
|---|---|
| **تفاعلي** – نافذة اختيار رسومية | `.\windows\download_repos.ps1 -DriveLetter E` |
| **مستودعات محددة** – بدون واجهة رسومية | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **جميع المستودعات** – بدون واجهة رسومية | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| مع رمز GitHub (يرفع حد المعدل) | أضف `-Token ghp_yourToken` إلى أي أمر أعلاه |

**الوضع التفاعلي** يجلب جميع مستودعات gladiola العامة من واجهة برمجة تطبيقات GitHub ويفتح نافذة `Out-GridView` تسرد أسماء المستودعات. اضغط باستمرار على **Ctrl** أو **Shift** لتحديد مستودعات متعددة، ثم انقر على **موافق**.

يستنسخ البرنامج النصي كل مستودع مختار في `<حرف_المحرك>:\gladiola_repos\`. إذا كان المستودع قد استُنسخ مسبقاً، فإنه يسترجع ويعيد الضبط إلى آخر `HEAD`.

أخرج محرك USB بأمان عندما يُبلّغ البرنامج النصي عن النجاح.

---

## الخطوة 2 – التثبيت على OpenBSD

### المتطلبات الأساسية

* وصول root (أو `doas`) على جهاز OpenBSD.
* محرك USB متصل فعلياً بجهاز OpenBSD.

### تركيب محرك USB

```sh
# البحث عن اسم الجهاز (ابحث عن محرك USB، غالباً sd1 أو sd2)
sysctl hw.disknames

# تركيبه (استبدل sd1i بقسمك الفعلي)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### تشغيل برنامج التثبيت النصي

| الوضع | الأمر |
|---|---|
| **تفاعلي** – قائمة مرقّمة | `doas sh openbsd/install_repos.sh` |
| **مستودعات محددة** – بدون قائمة | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **جميع المستودعات** – بدون قائمة | `doas sh openbsd/install_repos.sh -a` |
| مصدر / وجهة مخصصة | أضف `-s /mnt/usbkey -d /home/myuser/gladiola` |

**الوضع التفاعلي** يسرد كل مستودع موجود في `gladiola_repos/` على محرك USB برقم، ثم يطلب منك إدخال الأرقام التي تريدها (مثلاً `1 3 5`). اضغط **Enter** بدون إدخال لتثبيت الكل.

لكل مستودع مختار، يقوم البرنامج النصي بما يلي:
1. نسخه إلى `<دليل_التثبيت>/` (الافتراضي: `/usr/local/gladiola`)
2. ضبط `chmod 755` على جميع ملفات `.sh`
3. تشغيل `make install` إذا كان `Makefile` موجوداً (يظهر الناتج فقط عند الفشل)

### إلغاء تركيب محرك USB عند الانتهاء

```sh
doas umount /mnt/usb
```

---

## هيكل الدليل

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # يُشغَّل على Windows لملء محرك USB
├── openbsd/
│   └── install_repos.sh     # يُشغَّل على OpenBSD للتثبيت من محرك USB
└── README.md
```
