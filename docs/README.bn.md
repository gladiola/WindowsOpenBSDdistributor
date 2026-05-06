# WindowsOpenBSDdistributor

Windows-এ gladiola রিপোজিটরিগুলো একটি USB ড্রাইভে ডাউনলোড করুন, তারপর OpenBSD মেশিনে ইনস্টল করুন — এমনকি যখন OpenBSD সিস্টেমের সরাসরি ইন্টারনেট সংযোগ নেই তখনও।

উভয় স্ক্রিপ্টই **ইন্টারেক্টিভ নির্বাচন** সমর্থন করে যাতে আপনি প্রতিবার ঠিক কোন রিপোজিটরিগুলো ডাউনলোড বা ইনস্টল করবেন তা বেছে নিতে পারেন।

---

## ধাপ ১ – USB ড্রাইভে ডাউনলোড করুন (Windows)

### পূর্বশর্ত

* [Git for Windows](https://git-scm.com/download/win) ইনস্টল করা এবং `PATH`-এ থাকতে হবে।
* একটি USB ড্রাইভ সংযুক্ত (যেমন, ড্রাইভ `E:`)।

### PowerShell স্ক্রিপ্ট চালান

```powershell
# স্থানীয় স্ক্রিপ্ট চালানোর অনুমতি দিন (একবার, প্রয়োজনে Administrator হিসেবে চালান)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| মোড | কমান্ড |
|---|---|
| **ইন্টারেক্টিভ** – GUI নির্বাচন উইন্ডো | `.\windows\download_repos.ps1 -DriveLetter E` |
| **নির্দিষ্ট রিপোজিটরি** – GUI ছাড়া | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **সব রিপোজিটরি** – GUI ছাড়া | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| GitHub টোকেন সহ (রেট লিমিট বাড়ায়) | যেকোনো কমান্ডে `-Token ghp_yourToken` যোগ করুন |

**ইন্টারেক্টিভ মোড** GitHub API থেকে সব পাবলিক gladiola রিপোজিটরি সংগ্রহ করে এবং রিপোজিটরির নামের তালিকা সহ একটি `Out-GridView` উইন্ডো খোলে। একাধিক রিপোজিটরি নির্বাচনের জন্য **Ctrl** বা **Shift** চেপে ধরুন, তারপর **OK** ক্লিক করুন।

স্ক্রিপ্টটি প্রতিটি নির্বাচিত রিপোজিটরি `<ড্রাইভলেটার>:\gladiola_repos\`-এ ক্লোন করে। যদি কোনো রিপোজিটরি আগে থেকেই ক্লোন করা থাকে, তাহলে সর্বশেষ `HEAD`-এ ফেচ ও রিসেট করে।

স্ক্রিপ্ট সফলতা রিপোর্ট করলে USB ড্রাইভটি নিরাপদে বের করুন।

---

## ধাপ ২ – OpenBSD-তে ইনস্টল করুন

### পূর্বশর্ত

* OpenBSD মেশিনে root (বা `doas`) অ্যাক্সেস।
* USB ড্রাইভটি OpenBSD মেশিনে শারীরিকভাবে সংযুক্ত।

### USB ড্রাইভ মাউন্ট করুন

```sh
# ডিভাইসের নাম খুঁজুন (USB ড্রাইভ দেখুন, প্রায়ই sd1 বা sd2)
sysctl hw.disknames

# মাউন্ট করুন (sd1i আপনার প্রকৃত পার্টিশন দিয়ে প্রতিস্থাপন করুন)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### ইনস্টল স্ক্রিপ্ট চালান

| মোড | কমান্ড |
|---|---|
| **ইন্টারেক্টিভ** – নম্বরযুক্ত মেনু | `doas sh openbsd/install_repos.sh` |
| **নির্দিষ্ট রিপোজিটরি** – মেনু ছাড়া | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **সব রিপোজিটরি** – মেনু ছাড়া | `doas sh openbsd/install_repos.sh -a` |
| কাস্টম উৎস / গন্তব্য | `-s /mnt/usbkey -d /home/myuser/gladiola` যোগ করুন |

**ইন্টারেক্টিভ মোড** USB ড্রাইভের `gladiola_repos/`-এ পাওয়া প্রতিটি রিপোজিটরি একটি নম্বর সহ তালিকাভুক্ত করে, তারপর আপনাকে পছন্দের নম্বরগুলো (যেমন `1 3 5`) লিখতে বলে। সবকিছু ইনস্টল করতে ইনপুট ছাড়াই **Enter** চাপুন।

প্রতিটি নির্বাচিত রিপোজিটরির জন্য স্ক্রিপ্টটি:
1. `<ইনস্টল_ডিরেক্টরি>/`-তে কপি করে (ডিফল্ট: `/usr/local/gladiola`)
2. সব `.sh` ফাইলে `chmod 755` সেট করে
3. `Makefile` থাকলে `make install` চালায় (ব্যর্থতায় শুধু আউটপুট দেখায়)

### শেষ হলে USB ড্রাইভ আনমাউন্ট করুন

```sh
doas umount /mnt/usb
```

---

## ডিরেক্টরি কাঠামো

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # USB ড্রাইভ পূরণ করতে Windows-এ চালান
├── openbsd/
│   └── install_repos.sh     # USB ড্রাইভ থেকে ইনস্টল করতে OpenBSD-তে চালান
└── README.md
```
