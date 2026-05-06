# WindowsOpenBSDdistributor

Baixe os repositórios gladiola para uma unidade USB no Windows e, em seguida, instale-os em uma máquina OpenBSD — mesmo quando o sistema OpenBSD não tem acesso direto à Internet.

Ambos os scripts suportam **seleção interativa** para que você possa escolher exatamente quais repositórios baixar ou instalar a cada vez.

---

## Passo 1 – Baixar para a unidade USB (Windows)

### Pré-requisitos

* [Git para Windows](https://git-scm.com/download/win) instalado e no `PATH`.
* Uma unidade USB conectada (p. ex., unidade `E:`).

### Executar o script PowerShell

```powershell
# Permitir execução de scripts locais (uma vez, execute como Administrador se necessário)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modo | Comando |
|---|---|
| **Interativo** – janela de seleção GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositórios específicos** – sem GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Todos os repositórios** – sem GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Com token do GitHub (aumenta o limite de taxa) | adicione `-Token ghp_seuToken` a qualquer comando acima |

**O modo interativo** busca todos os repositórios públicos gladiola da API do GitHub e abre uma janela `Out-GridView` listando os nomes dos repositórios. Segure **Ctrl** ou **Shift** para selecionar vários repositórios e clique em **OK**.

O script clona cada repositório escolhido em `<LetraUnidade>:\gladiola_repos\`. Se um repositório já foi clonado anteriormente, ele busca e redefine para o `HEAD` mais recente.

Ejete a unidade USB com segurança quando o script reportar sucesso.

---

## Passo 2 – Instalar no OpenBSD

### Pré-requisitos

* Acesso root (ou `doas`) na máquina OpenBSD.
* A unidade USB fisicamente conectada à máquina OpenBSD.

### Montar a unidade USB

```sh
# Encontrar o nome do dispositivo (procurar a unidade USB, geralmente sd1 ou sd2)
sysctl hw.disknames

# Montá-la (substituir sd1i pela sua partição real)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Executar o script de instalação

| Modo | Comando |
|---|---|
| **Interativo** – menu numerado | `doas sh openbsd/install_repos.sh` |
| **Repositórios específicos** – sem menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Todos os repositórios** – sem menu | `doas sh openbsd/install_repos.sh -a` |
| Origem / destino personalizado | adicione `-s /mnt/usbkey -d /home/meuusuario/gladiola` |

**O modo interativo** lista cada repositório encontrado em `gladiola_repos/` na unidade USB com um número e, em seguida, solicita que você insira os números desejados (p. ex., `1 3 5`). Pressione **Enter** sem entrada para instalar tudo.

Para cada repositório selecionado, o script:
1. Copia para `<dir_instalação>/` (padrão: `/usr/local/gladiola`)
2. Define `chmod 755` em todos os arquivos `.sh`
3. Executa `make install` se um `Makefile` estiver presente (saída exibida somente em caso de falha)

### Desmontar a unidade USB quando terminar

```sh
doas umount /mnt/usb
```

---

## Estrutura de diretórios

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Executar no Windows para popular a unidade USB
├── openbsd/
│   └── install_repos.sh     # Executar no OpenBSD para instalar a partir da unidade USB
└── README.md
```
