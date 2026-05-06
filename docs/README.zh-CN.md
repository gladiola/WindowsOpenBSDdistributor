# WindowsOpenBSDdistributor

在 Windows 上将 gladiola 仓库下载到 USB 驱动器，然后安装到 OpenBSD 机器上——即使 OpenBSD 系统没有直接的互联网连接也没问题。

两个脚本均支持**交互式选择**，让您每次都可以精确选择要下载或安装的仓库。

---

## 第一步 – 下载到 USB 驱动器（Windows）

### 前提条件

* 已安装 [Git for Windows](https://git-scm.com/download/win) 并加入 `PATH`。
* 已插入 USB 驱动器（例如盘符 `E:`）。

### 运行 PowerShell 脚本

```powershell
# 允许运行本地脚本（一次性设置，如需要请以管理员身份运行）
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| 模式 | 命令 |
|---|---|
| **交互模式** – GUI 选择窗口 | `.\windows\download_repos.ps1 -DriveLetter E` |
| **指定仓库** – 无 GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **所有仓库** – 无 GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| 使用 GitHub Token（提升速率限制） | 在上方任意命令后加上 `-Token ghp_yourToken` |

**交互模式**会从 GitHub API 获取所有公开的 gladiola 仓库，并打开列有仓库名称的 `Out-GridView` 窗口。按住 **Ctrl** 或 **Shift** 可多选，然后点击**确定**。

脚本会将每个选定的仓库克隆到 `<盘符>:\gladiola_repos\`。若仓库此前已克隆，则会拉取更新并重置到最新的 `HEAD`。

脚本报告成功后，请安全弹出 USB 驱动器。

---

## 第二步 – 在 OpenBSD 上安装

### 前提条件

* 在 OpenBSD 机器上具有 root（或 `doas`）访问权限。
* USB 驱动器已物理连接到 OpenBSD 机器。

### 挂载 USB 驱动器

```sh
# 查找设备名称（寻找 USB 驱动器，通常为 sd1 或 sd2）
sysctl hw.disknames

# 挂载（将 sd1i 替换为您的实际分区）
doas mount -t msdos /dev/sd1i /mnt/usb
```

### 运行安装脚本

| 模式 | 命令 |
|---|---|
| **交互模式** – 编号菜单 | `doas sh openbsd/install_repos.sh` |
| **指定仓库** – 无菜单 | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **所有仓库** – 无菜单 | `doas sh openbsd/install_repos.sh -a` |
| 自定义来源 / 目标 | 加上 `-s /mnt/usbkey -d /home/myuser/gladiola` |

**交互模式**会列出 USB 驱动器上 `gladiola_repos/` 中每个仓库的编号，然后提示您输入所需的编号（例如 `1 3 5`）。不输入任何内容直接按**回车**即可安装全部。

对于每个选定的仓库，脚本会：
1. 将其复制到 `<安装目录>/`（默认：`/usr/local/gladiola`）
2. 对所有 `.sh` 文件设置 `chmod 755`
3. 若存在 `Makefile` 则运行 `make install`（仅在失败时显示输出）

### 完成后卸载 USB 驱动器

```sh
doas umount /mnt/usb
```

---

## 目录结构

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # 在 Windows 上运行以填充 USB 驱动器
├── openbsd/
│   └── install_repos.sh     # 在 OpenBSD 上运行以从 USB 驱动器安装
└── README.md
```
