# WindowsOpenBSDdistributor

Windows पर gladiola रिपॉज़िटरी को USB ड्राइव में डाउनलोड करें, फिर उन्हें OpenBSD मशीन पर इंस्टॉल करें — यहाँ तक कि जब OpenBSD सिस्टम का सीधा इंटरनेट एक्सेस न हो।

दोनों स्क्रिप्ट **इंटरैक्टिव चयन** का समर्थन करती हैं ताकि आप हर बार ठीक वही रिपॉज़िटरी चुन सकें जिन्हें डाउनलोड या इंस्टॉल करना है।

---

## चरण 1 – USB ड्राइव में डाउनलोड करें (Windows)

### पूर्वापेक्षाएँ

* [Git for Windows](https://git-scm.com/download/win) इंस्टॉल हो और `PATH` में हो।
* एक USB ड्राइव लगी हो (जैसे ड्राइव `E:`)।

### PowerShell स्क्रिप्ट चलाएँ

```powershell
# स्थानीय स्क्रिप्ट चलाने की अनुमति दें (एक बार, यदि आवश्यक हो तो Administrator के रूप में चलाएँ)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| मोड | कमांड |
|---|---|
| **इंटरैक्टिव** – GUI चयन विंडो | `.\windows\download_repos.ps1 -DriveLetter E` |
| **विशिष्ट रिपॉज़िटरी** – GUI रहित | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **सभी रिपॉज़िटरी** – GUI रहित | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| GitHub टोकन के साथ (दर सीमा बढ़ाता है) | किसी भी कमांड में `-Token ghp_yourToken` जोड़ें |

**इंटरैक्टिव मोड** GitHub API से सभी सार्वजनिक gladiola रिपॉज़िटरी प्राप्त करता है और रिपॉज़िटरी नामों की सूची के साथ एक `Out-GridView` विंडो खोलता है। एकाधिक रिपॉज़िटरी चुनने के लिए **Ctrl** या **Shift** दबाए रखें, फिर **OK** क्लिक करें।

स्क्रिप्ट प्रत्येक चुनी हुई रिपॉज़िटरी को `<ड्राइव लेटर>:\gladiola_repos\` में क्लोन करती है। यदि कोई रिपॉज़िटरी पहले से क्लोन की गई है, तो वह नवीनतम `HEAD` पर fetch और reset करती है।

स्क्रिप्ट सफलता की रिपोर्ट करने के बाद USB ड्राइव को सुरक्षित रूप से निकालें।

---

## चरण 2 – OpenBSD पर इंस्टॉल करें

### पूर्वापेक्षाएँ

* OpenBSD मशीन पर root (या `doas`) एक्सेस।
* USB ड्राइव OpenBSD मशीन से भौतिक रूप से जुड़ी हो।

### USB ड्राइव माउंट करें

```sh
# डिवाइस का नाम खोजें (USB ड्राइव देखें, अक्सर sd1 या sd2)
sysctl hw.disknames

# माउंट करें (sd1i को अपने वास्तविक पार्टीशन से बदलें)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### इंस्टॉल स्क्रिप्ट चलाएँ

| मोड | कमांड |
|---|---|
| **इंटरैक्टिव** – नंबर मेनू | `doas sh openbsd/install_repos.sh` |
| **विशिष्ट रिपॉज़िटरी** – मेनू रहित | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **सभी रिपॉज़िटरी** – मेनू रहित | `doas sh openbsd/install_repos.sh -a` |
| कस्टम स्रोत / गंतव्य | `-s /mnt/usbkey -d /home/myuser/gladiola` जोड़ें |

**इंटरैक्टिव मोड** USB ड्राइव पर `gladiola_repos/` में पाई गई प्रत्येक रिपॉज़िटरी को एक नंबर के साथ सूचीबद्ध करता है, फिर आपसे वांछित नंबर दर्ज करने के लिए कहता है (जैसे `1 3 5`)। सब कुछ इंस्टॉल करने के लिए बिना इनपुट के **Enter** दबाएँ।

प्रत्येक चुनी हुई रिपॉज़िटरी के लिए स्क्रिप्ट:
1. उसे `<इंस्टॉल_डायरेक्टरी>/` में कॉपी करती है (डिफ़ॉल्ट: `/usr/local/gladiola`)
2. सभी `.sh` फ़ाइलों पर `chmod 755` सेट करती है
3. यदि `Makefile` मौजूद है तो `make install` चलाती है (आउटपुट केवल विफलता पर दिखाया जाता है)

### पूरा होने पर USB ड्राइव अनमाउंट करें

```sh
doas umount /mnt/usb
```

---

## निर्देशिका संरचना

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # USB ड्राइव भरने के लिए Windows पर चलाएँ
├── openbsd/
│   └── install_repos.sh     # USB ड्राइव से इंस्टॉल करने के लिए OpenBSD पर चलाएँ
└── README.md
```
