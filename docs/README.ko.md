# WindowsOpenBSDdistributor

Windows에서 gladiola 저장소를 USB 드라이브에 다운로드한 다음, OpenBSD 시스템에 직접 인터넷 접속이 없는 경우에도 OpenBSD 머신에 설치합니다.

두 스크립트 모두 **대화형 선택**을 지원하므로 매번 다운로드하거나 설치할 저장소를 정확히 선택할 수 있습니다.

---

## 1단계 – USB 드라이브에 다운로드 (Windows)

### 사전 요구 사항

* [Git for Windows](https://git-scm.com/download/win)가 설치되어 `PATH`에 추가되어 있어야 합니다.
* USB 드라이브가 연결되어 있어야 합니다 (예: 드라이브 `E:`).

### PowerShell 스크립트 실행

```powershell
# 로컬 스크립트 실행 허용 (최초 1회, 필요 시 관리자 권한으로 실행)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| 모드 | 명령 |
|---|---|
| **대화형** – GUI 선택 창 | `.\windows\download_repos.ps1 -DriveLetter E` |
| **특정 저장소** – GUI 없음 | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **모든 저장소** – GUI 없음 | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| GitHub 토큰 사용 (속도 제한 향상) | 위의 모든 명령에 `-Token ghp_yourToken` 추가 |

**대화형 모드**는 GitHub API에서 모든 공개 gladiola 저장소를 가져와 저장소 이름을 나열하는 `Out-GridView` 창을 엽니다. **Ctrl** 또는 **Shift**를 누른 채 여러 저장소를 선택한 다음 **확인**을 클릭합니다.

스크립트는 선택한 각 저장소를 `<드라이브문자>:\gladiola_repos\`에 복제합니다. 저장소가 이미 복제된 경우 최신 `HEAD`로 가져와 재설정합니다.

스크립트가 성공을 보고하면 USB 드라이브를 안전하게 꺼냅니다.

---

## 2단계 – OpenBSD에 설치

### 사전 요구 사항

* OpenBSD 머신에서 root (또는 `doas`) 접근 권한이 있어야 합니다.
* USB 드라이브가 OpenBSD 머신에 물리적으로 연결되어 있어야 합니다.

### USB 드라이브 마운트

```sh
# 장치 이름 찾기 (USB 드라이브 검색, 보통 sd1 또는 sd2)
sysctl hw.disknames

# 마운트 (sd1i를 실제 파티션으로 교체)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### 설치 스크립트 실행

| 모드 | 명령 |
|---|---|
| **대화형** – 번호 메뉴 | `doas sh openbsd/install_repos.sh` |
| **특정 저장소** – 메뉴 없음 | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **모든 저장소** – 메뉴 없음 | `doas sh openbsd/install_repos.sh -a` |
| 사용자 정의 원본 / 대상 | `-s /mnt/usbkey -d /home/myuser/gladiola` 추가 |

**대화형 모드**는 USB 드라이브의 `gladiola_repos/`에 있는 각 저장소를 번호와 함께 나열한 다음 원하는 번호를 입력하도록 요청합니다 (예: `1 3 5`). 입력 없이 **Enter**를 누르면 모두 설치합니다.

선택한 각 저장소에 대해 스크립트는:
1. `<설치_디렉토리>/`에 복사합니다 (기본값: `/usr/local/gladiola`)
2. 모든 `.sh` 파일에 `chmod 755`를 설정합니다
3. `Makefile`이 있으면 `make install`을 실행합니다 (실패 시에만 출력 표시)

### 완료 후 USB 드라이브 마운트 해제

```sh
doas umount /mnt/usb
```

---

## 디렉토리 레이아웃

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # USB 드라이브를 채우기 위해 Windows에서 실행
├── openbsd/
│   └── install_repos.sh     # USB 드라이브에서 설치하기 위해 OpenBSD에서 실행
└── README.md
```
