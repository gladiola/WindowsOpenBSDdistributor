# WindowsOpenBSDdistributor

Descarga los repositorios de gladiola a una unidad USB en Windows y luego instálalos en una máquina OpenBSD, incluso cuando el sistema OpenBSD no tiene acceso directo a Internet.

Ambos scripts admiten **selección interactiva** para que puedas elegir exactamente qué repositorios descargar o instalar cada vez.

---

## Paso 1 – Descargar a la unidad USB (Windows)

### Requisitos previos

* [Git para Windows](https://git-scm.com/download/win) instalado y en el `PATH`.
* Una unidad USB conectada (p. ej., unidad `E:`).

### Ejecutar el script de PowerShell

```powershell
# Permitir ejecutar scripts locales (una sola vez, ejecutar como Administrador si es necesario)
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

| Modo | Comando |
|---|---|
| **Interactivo** – ventana de selección GUI | `.\windows\download_repos.ps1 -DriveLetter E` |
| **Repositorios específicos** – sin GUI | `.\windows\download_repos.ps1 -DriveLetter E -Repos "OBJC-codespaces","OpenBSDHomemadeBlockScripts"` |
| **Todos los repositorios** – sin GUI | `.\windows\download_repos.ps1 -DriveLetter E -All` |
| Con token de GitHub (aumenta el límite de velocidad) | agrega `-Token ghp_tuToken` a cualquier comando anterior |

**El modo interactivo** obtiene todos los repositorios públicos de gladiola desde la API de GitHub y abre una ventana `Out-GridView` con los nombres de los repositorios. Mantén presionado **Ctrl** o **Shift** para seleccionar múltiples repositorios y luego haz clic en **Aceptar**.

El script clona cada repositorio elegido en `<LetraUnidad>:\gladiola_repos\`. Si un repositorio ya fue clonado anteriormente, obtiene y restablece la última versión `HEAD`.

Expulsa la unidad USB de forma segura cuando el script reporte éxito.

---

## Paso 2 – Instalar en OpenBSD

### Requisitos previos

* Acceso como root (o `doas`) en la máquina OpenBSD.
* La unidad USB conectada físicamente a la máquina OpenBSD.

### Montar la unidad USB

```sh
# Encontrar el nombre del dispositivo (buscar la unidad USB, generalmente sd1 o sd2)
sysctl hw.disknames

# Montarla (reemplaza sd1i con tu partición real)
doas mount -t msdos /dev/sd1i /mnt/usb
```

### Ejecutar el script de instalación

| Modo | Comando |
|---|---|
| **Interactivo** – menú numerado | `doas sh openbsd/install_repos.sh` |
| **Repositorios específicos** – sin menú | `doas sh openbsd/install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts` |
| **Todos los repositorios** – sin menú | `doas sh openbsd/install_repos.sh -a` |
| Origen / destino personalizado | agrega `-s /mnt/usbkey -d /home/miusuario/gladiola` |

**El modo interactivo** lista cada repositorio encontrado en `gladiola_repos/` en la unidad USB con un número, luego te pide que ingreses los números que deseas (p. ej., `1 3 5`). Presiona **Enter** sin entrada para instalar todo.

Para cada repositorio seleccionado, el script:
1. Lo copia en `<dir_instalación>/` (predeterminado: `/usr/local/gladiola`)
2. Establece `chmod 755` en todos los archivos `.sh`
3. Ejecuta `make install` si hay un `Makefile` presente (la salida solo se muestra en caso de error)

### Desmontar la unidad USB cuando termines

```sh
doas umount /mnt/usb
```

---

## Estructura de directorios

```
WindowsOpenBSDdistributor/
├── windows/
│   └── download_repos.ps1   # Ejecutar en Windows para poblar la unidad USB
├── openbsd/
│   └── install_repos.sh     # Ejecutar en OpenBSD para instalar desde la unidad USB
└── README.md
```
