# WindowsOpenBSDdistributor

在 Windows 上將 gladiola 儲存庫下載至 USB 隨身碟，然後安裝到 OpenBSD 機器上——即使 OpenBSD 系統沒有直接的網路連線也沒問題。

兩個腳本均支援**互動式選擇**，讓您每次都可以精確選擇要下載或安裝的儲存庫。

---

## 步驟 1 – 下載到 USB 隨身碟（Windows）

### 先決條件

* 已安裝 [Git for Windows](https://git-scm.com/download/win) 並加入 `PATH`。
* 已插入 USB 隨身碟（例如磁碟機 `E:`）。

### 執行 PowerShell 腳本

```powershell
# 允許執行本機腳本（一次性設定，如有需要請以系統管理員身份執行）
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| 模式 | 指令 |
|---|---|
| **互動模式** – GUI 選擇視窗 | `.\windows\download_repos.ps1 -DriveLetter E` |
| **指定儲存庫** – 無 GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **所有儲存庫** – 無 GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| 使用 GitHub Token（提升速率限制） | 在上方任意指令後加上 `-Token ghp_yourToken` |

**互動模式**會從 GitHub API 擷取所有公開的 gladiola 儲存庫，並開啟列有儲存庫名稱的 `Out-GridView` 視窗。按住 **Ctrl** 或 **Shift** 可多選，然後按一下 **確定**。

腳本會將每個選定的儲存庫複製到 `<磁碟機代號>:\gladiola_repos\`。若儲存庫先前已複製，則會擷取更新並重設至最新的 `HEAD`。

腳本回報成功後，請安全退出 USB 隨身碟。

---

## 步驟 2 – 在 OpenBSD 上安裝

### 先決條件

* 在 OpenBSD 機器上具有 root（或 `doas`）存取權限。
* USB 隨身碟已實體連接至 OpenBSD 機器。

### 掛載 USB 隨身碟

```sh
# 尋找裝置名稱（尋找 USB 隨身碟，通常為 sd1 或 sd2）
sysctl hw.disknames

# 掛載（請將 sd1i 替換為您的實際分割區）
doas mount -t msdos /dev/sd1i /mnt/usb
```

### 執行安裝腳本

| 模式 | 指令 |
|---|---|
| **互動模式** – 編號選單 | `doas sh openbsd/install_repos.sh` |
| **指定儲存庫** – 無選單 | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **所有儲存庫** – 無選單 | `doas sh openbsd/install_repos.sh -a` |
| 自訂來源 / 目的地 | 加上 `-s /mnt/usbkey -d /home/myuser/gladiola` |

**互動模式**會列出 USB 隨身碟上 `gladiola_repos/` 中每個儲存庫的編號，然後提示您輸入所需的編號（例如 `1 3 5`）。不輸入任何內容直接按 **Enter** 即可安裝全部。

對於每個選定的儲存庫，腳本會：
1. 將其複製到 `<安裝目錄>/`（預設：`/usr/local/gladiola`）
2. 對所有 `.sh` 檔案設定 `chmod 755`
3. 若存在 `Makefile` 則執行 `make install`（僅在失敗時顯示輸出）

### 完成後卸載 USB 隨身碟

```sh
doas umount /mnt/usb
```

---

## 目錄結構

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # 在 Windows 上執行以填充 USB 隨身碟
├── openbsd/
│   └── install_repos.sh     # 在 OpenBSD 上執行以從 USB 隨身碟安裝
└── README.md
```
