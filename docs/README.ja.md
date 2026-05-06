# WindowsOpenBSDdistributor

Windows で gladiola リポジトリを USB ドライブにダウンロードし、OpenBSD マシンにインストールします。OpenBSD システムが直接インターネットに接続できない環境でも利用できます。

両スクリプトとも**対話的な選択**に対応しており、毎回ダウンロードまたはインストールするリポジトリを正確に選択できます。

---

## ステップ 1 – USB ドライブへのダウンロード（Windows）

### 前提条件

* [Git for Windows](https://git-scm.com/download/win) がインストールされ `PATH` に追加されていること。
* USB ドライブが接続されていること（例：ドライブ `E:`）。

### PowerShell スクリプトの実行

```powershell
# ローカルスクリプトの実行を許可する（初回のみ。必要に応じて管理者として実行）
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| モード | コマンド |
|---|---|
| **対話形式** – GUI 選択ウィンドウ | `.\windows\download_repos.ps1 -DriveLetter E` |
| **特定のリポジトリ** – GUI なし | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **すべてのリポジトリ** – GUI なし | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| GitHub トークン付き（レート制限を緩和） | 上記コマンドに `-Token ghp_yourToken` を追加 |

**対話形式モード** では、GitHub API からすべての公開 gladiola リポジトリを取得し、リポジトリ名を一覧表示する `Out-GridView` ウィンドウを開きます。**Ctrl** または **Shift** を押しながら複数のリポジトリを選択し、**OK** をクリックしてください。

スクリプトは選択した各リポジトリを `<ドライブ文字>:\gladiola_repos\` にクローンします。すでにクローン済みのリポジトリは最新の `HEAD` に fetch してリセットします。

スクリプトが成功を報告したら、USB ドライブを安全に取り出してください。

---

## ステップ 2 – OpenBSD へのインストール

### 前提条件

* OpenBSD マシンで root（または `doas`）アクセスがあること。
* USB ドライブが OpenBSD マシンに物理的に接続されていること。

### USB ドライブのマウント

```sh
# デバイス名を確認する（USB ドライブを探す。通常 sd1 または sd2）
sysctl hw.disknames

# マウントする（sd1i を実際のパーティションに置き換える）
doas mount -t msdos /dev/sd1i /mnt/usb
```

### インストールスクリプトの実行

| モード | コマンド |
|---|---|
| **対話形式** – 番号付きメニュー | `doas sh openbsd/install_repos.sh` |
| **特定のリポジトリ** – メニューなし | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **すべてのリポジトリ** – メニューなし | `doas sh openbsd/install_repos.sh -a` |
| カスタム送信元 / 宛先 | `-s /mnt/usbkey -d /home/myuser/gladiola` を追加 |

**対話形式モード** では、USB ドライブ上の `gladiola_repos/` にある各リポジトリを番号付きで一覧表示し、希望する番号（例：`1 3 5`）の入力を求めます。入力なしで **Enter** を押すとすべてインストールします。

選択した各リポジトリに対して、スクリプトは次を実行します：
1. `<インストールディレクトリ>/` にコピー（デフォルト：`/usr/local/gladiola`）
2. すべての `.sh` ファイルに `chmod 755` を設定
3. `Makefile` があれば `make install` を実行（失敗時のみ出力を表示）

### 完了後に USB ドライブをアンマウントする

```sh
doas umount /mnt/usb
```

---

## ディレクトリ構成

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Windows で実行して USB ドライブを準備する
├── openbsd/
│   └── install_repos.sh     # OpenBSD で実行して USB ドライブからインストールする
└── README.md
```
