#!/bin/sh
#
# install_repos.sh – Install gladiola repositories from a USB drive on OpenBSD.
#
# USAGE
#   sh install_repos.sh [-s <usb_mount>] [-d <install_dir>] [-r <repo,...>] [-a]
#
# OPTIONS
#   -s <usb_mount>   Mount point where the USB drive is attached.
#                    Defaults to /mnt/usb
#   -d <install_dir> Directory where the repositories will be installed.
#                    Defaults to /usr/local/gladiola
#   -r <repo,...>    Comma-separated list of repository names to install.
#                    If omitted and -a is not set, an interactive numbered
#                    menu is shown so you can choose.
#   -a               Install every repository on the USB drive without prompting.
#
# DESCRIPTION
#   The script expects the USB drive to contain a directory called
#   "gladiola_repos" at its root (as created by windows/download_repos.ps1).
#   It installs either the selected or all sub-directories found there.
#
#   For each repository the script:
#     1. Copies it to <install_dir>/
#     2. Sets chmod 755 on all *.sh files
#     3. Runs "make install" if a Makefile is present
#
# REQUIREMENTS
#   * Run as root (needed to write to /usr/local and to configure pf scripts).
#   * The USB drive must already be mounted at <usb_mount>.
#     Example: mount -t msdos /dev/sd1i /mnt/usb
#
# EXAMPLES
#   # Interactive menu – choose which repos to install
#   mount -t msdos /dev/sd1i /mnt/usb
#   sh install_repos.sh
#
#   # Install specific repos non-interactively
#   sh install_repos.sh -r OBJC-codespaces,OpenBSDHomemadeBlockScripts
#
#   # Install everything without prompting
#   sh install_repos.sh -a
#
#   # Custom paths
#   sh install_repos.sh -s /mnt/usbkey -d /home/user/gladiola

set -e

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------

USB_MOUNT="/mnt/usb"
INSTALL_DIR="/usr/local/gladiola"
SELECTED_REPOS=""   # comma-separated names; empty = prompt
INSTALL_ALL=0

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while getopts "s:d:r:a" opt; do
    case "$opt" in
        s) USB_MOUNT="$OPTARG" ;;
        d) INSTALL_DIR="$OPTARG" ;;
        r) SELECTED_REPOS="$OPTARG" ;;
        a) INSTALL_ALL=1 ;;
        *) echo "Usage: $0 [-s usb_mount] [-d install_dir] [-r repo,...] [-a]" >&2; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

info()  { printf '\033[0;36m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[0;32m[ OK ]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[0;33m[WARN]\033[0m  %s\n' "$*"; }
die()   { printf '\033[0;31m[ERR ]\033[0m  %s\n' "$*" >&2; exit 1; }

# Returns 0 (true) if $1 is in the comma-separated list $2
in_list() {
    _name="$1"
    _list=",$2,"
    case "$_list" in
        *,"$_name",*) return 0 ;;
        *)             return 1 ;;
    esac
}

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
    die "This script must be run as root. Try: doas sh $0 $*"
fi

if [ ! -d "$USB_MOUNT" ]; then
    die "USB mount point '$USB_MOUNT' does not exist."
fi

REPOS_DIR="$USB_MOUNT/gladiola_repos"

if [ ! -d "$REPOS_DIR" ]; then
    die "Expected directory '$REPOS_DIR' not found on the USB drive. Make sure you ran windows/download_repos.ps1 first."
fi

# ---------------------------------------------------------------------------
# Discover available repositories from the USB drive
# ---------------------------------------------------------------------------

AVAILABLE=""
REPO_COUNT=0
for d in "$REPOS_DIR"/*/; do
    [ -d "$d" ] || continue
    AVAILABLE="$AVAILABLE $(basename "$d")"
    REPO_COUNT=$((REPO_COUNT + 1))
done

if [ "$REPO_COUNT" -eq 0 ]; then
    die "No repositories found in '$REPOS_DIR'. Make sure download_repos.ps1 ran successfully."
fi

# ---------------------------------------------------------------------------
# Interactive numbered menu (when no -r or -a flag was given)
# ---------------------------------------------------------------------------

if [ "$INSTALL_ALL" -eq 0 ] && [ -z "$SELECTED_REPOS" ]; then
    printf '\nRepositories available on USB drive:\n\n'

    i=1
    for REPO in $AVAILABLE; do
        printf '  %3d) %s\n' "$i" "$REPO"
        i=$((i + 1))
    done

    printf '\nEnter the numbers of the repositories to install,\n'
    printf 'separated by spaces (e.g. 1 3 5), or press Enter to install all:\n> '
    read -r SELECTION

    if [ -z "$SELECTION" ]; then
        INSTALL_ALL=1
    else
        # Build SELECTED_REPOS from the chosen numbers
        i=1
        for REPO in $AVAILABLE; do
            for NUM in $SELECTION; do
                if [ "$NUM" -eq "$i" ] 2>/dev/null; then
                    if [ -z "$SELECTED_REPOS" ]; then
                        SELECTED_REPOS="$REPO"
                    else
                        SELECTED_REPOS="$SELECTED_REPOS,$REPO"
                    fi
                fi
            done
            i=$((i + 1))
        done

        if [ -z "$SELECTED_REPOS" ]; then
            die "No valid numbers entered. Nothing to install."
        fi
    fi
fi

# ---------------------------------------------------------------------------
# Ensure install directory exists
# ---------------------------------------------------------------------------

if [ ! -d "$INSTALL_DIR" ]; then
    info "Creating install directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# ---------------------------------------------------------------------------
# Copy and configure selected repositories
# ---------------------------------------------------------------------------

FAILED=""
INSTALLED=0

for REPO in $AVAILABLE; do
    # Skip if not selected (unless installing all)
    if [ "$INSTALL_ALL" -eq 0 ] && ! in_list "$REPO" "$SELECTED_REPOS"; then
        continue
    fi

    SRC="$REPOS_DIR/$REPO"
    DEST="$INSTALL_DIR/$REPO"

    info "Installing $REPO -> $DEST"

    # Copy repository (preserve timestamps; -R = recursive)
    cp -pR "$SRC" "$INSTALL_DIR/"

    # Make sure shell scripts are executable
    find "$DEST" -name '*.sh' -exec chmod 755 {} \;

    # If a Makefile is present, run make install
    if [ -f "$DEST/Makefile" ]; then
        info "  Running 'make install' in $DEST"
        make_output=$(make -C "$DEST" install 2>&1)
        make_status=$?
        if [ $make_status -eq 0 ]; then
            ok "  make install succeeded for $REPO"
        else
            warn "  'make install' failed for $REPO – continuing."
            printf '%s\n' "$make_output" >&2
        fi
    fi

    ok "$REPO installed."
    INSTALLED=$((INSTALLED + 1))
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

printf '\n'
if [ -n "$FAILED" ]; then
    warn "The following repositories were not installed:$FAILED"
    exit 1
else
    ok "$INSTALLED repositories installed to $INSTALL_DIR"
fi
