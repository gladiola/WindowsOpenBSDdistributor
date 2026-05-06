# WindowsOpenBSDdistributor

Téléchargez les dépôts gladiola sur une clé USB sous Windows, puis installez-les sur une machine OpenBSD — même lorsque le système OpenBSD ne dispose pas d'un accès Internet direct.

Les deux scripts prennent en charge la **sélection interactive** afin que vous puissiez choisir exactement quels dépôts télécharger ou installer à chaque fois.

---

## Étape 1 – Télécharger sur la clé USB (Windows)

### Prérequis

* [Git pour Windows](https://git-scm.com/download/win) installé et présent dans le `PATH`.
* Une clé USB branchée (par exemple, le lecteur `E:`).

### Exécuter le script PowerShell

```powershell
# Autoriser l'exécution de scripts locaux (une seule fois, exécuter en tant qu'Administrateur si nécessaire)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Mode | Commande |
|---|---|
| **Interactif** – fenêtre de sélection GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Dépôts spécifiques** – sans GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Tous les dépôts** – sans GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Avec un token GitHub (augmente la limite de taux) | ajouter `-Token ghp_votreToken` à n'importe quelle commande ci-dessus |

**Le mode interactif** récupère tous les dépôts publics gladiola depuis l'API GitHub et ouvre une fenêtre `Out-GridView` listant les noms des dépôts. Maintenez **Ctrl** ou **Maj** pour sélectionner plusieurs dépôts, puis cliquez sur **OK**.

Le script clone chaque dépôt sélectionné dans `<LettreLecteur>:\gladiola_repos\`. Si un dépôt a déjà été cloné auparavant, il récupère et réinitialise au dernier `HEAD`.

Éjectez la clé USB en toute sécurité lorsque le script signale le succès.

---

## Étape 2 – Installer sur OpenBSD

### Prérequis

* Accès root (ou `doas`) sur la machine OpenBSD.
* La clé USB physiquement connectée à la machine OpenBSD.

### Monter la clé USB

```sh
# Trouver le nom du périphérique (chercher la clé USB, souvent sd1 ou sd2)
sysctl hw.disknames

# La monter (remplacer sd1i par votre partition réelle)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Exécuter le script d'installation

| Mode | Commande |
|---|---|
| **Interactif** – menu numéroté | `doas sh openbsd/install_repos.sh` |
| **Dépôts spécifiques** – sans menu | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Tous les dépôts** – sans menu | `doas sh openbsd/install_repos.sh -a` |
| Source / destination personnalisée | ajouter `-s /mnt/usbkey -d /home/monutilisateur/gladiola` |

**Le mode interactif** liste chaque dépôt trouvé dans `gladiola_repos/` sur la clé USB avec un numéro, puis vous invite à saisir les numéros souhaités (par ex. `1 3 5`). Appuyez sur **Entrée** sans saisie pour tout installer.

Pour chaque dépôt sélectionné, le script :
1. Le copie dans `<répertoire_installation>/` (par défaut `/usr/local/gladiola`)
2. Définit `chmod 755` sur tous les fichiers `.sh`
3. Exécute `make install` si un `Makefile` est présent (sortie affichée uniquement en cas d'échec)

### Démonter la clé USB une fois terminé

```sh
doas umount /mnt/usb
```

---

## Structure des répertoires

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # À exécuter sur Windows pour remplir la clé USB
├── openbsd/
│   └── install_repos.sh     # À exécuter sur OpenBSD pour installer depuis la clé USB
└── README.md
```
