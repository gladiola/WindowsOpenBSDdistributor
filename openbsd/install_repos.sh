#!/bin/sh
#
# install_repos.sh – Install gladiola repositories from a USB drive on OpenBSD.
#
# USAGE
#   sh install_repos.sh [-s <usb_mount>] [-d <install_dir>]
#
# OPTIONS
#   -s <usb_mount>   Mount point where the USB drive is attached.
#                    Defaults to /mnt/usb
#   -d <install_dir> Directory where the repositories will be installed.
#                    Defaults to /usr/local/gladiola
#
# DESCRIPTION
#   The script expects the USB drive to contain a directory called
#   "gladiola_repos" at its root (as created by windows/download_repos.ps1).
#   It installs every sub-directory found inside gladiola_repos/, so whatever
#   repos were downloaded on Windows will all be installed automatically.
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
#   # Mount the USB drive first, then run:
#   mount -t msdos /dev/sd1i /mnt/usb
#   sh install_repos.sh
#
#   # Custom paths:
#   sh install_repos.sh -s /mnt/usbkey -d /home/user/gladiola

set -e

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------

USB_MOUNT="/mnt/usb"
INSTALL_DIR="/usr/local/gladiola"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while getopts "s:d:" opt; do
    case "$opt" in
        s) USB_MOUNT="$OPTARG" ;;
        d) INSTALL_DIR="$OPTARG" ;;
        *) echo "Usage: $0 [-s usb_mount] [-d install_dir]" >&2; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

info()  { printf '\033[0;36m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[0;32m[ OK ]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[0;33m[WARN]\033[0m  %s\n' "$*"; }
die()   { printf '\033[0;31m[ERR ]\033[0m  %s\n' "$*" >&2; exit 1; }

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
# Ensure install directory exists
# ---------------------------------------------------------------------------

if [ ! -d "$INSTALL_DIR" ]; then
    info "Creating install directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# ---------------------------------------------------------------------------
# Discover repositories from the USB drive
# ---------------------------------------------------------------------------

REPO_COUNT=0
for d in "$REPOS_DIR"/*/; do
    [ -d "$d" ] && REPO_COUNT=$((REPO_COUNT + 1))
done

if [ "$REPO_COUNT" -eq 0 ]; then
    die "No repositories found in '$REPOS_DIR'. Make sure download_repos.ps1 ran successfully."
fi

info "Found $REPO_COUNT repositories in $REPOS_DIR"

# ---------------------------------------------------------------------------
# Copy and configure each repository
# ---------------------------------------------------------------------------

FAILED=""

for SRC in "$REPOS_DIR"/*/; do
    [ -d "$SRC" ] || continue

    REPO=$(basename "$SRC")
    DEST="$INSTALL_DIR/$REPO"

    info "Installing $REPO -> $DEST"

    # Copy repository (preserve timestamps; -R = recursive)
    cp -pR "$SRC" "$INSTALL_DIR/"

    # Make sure shell scripts are executable
    find "$DEST" -name '*.sh' -exec chmod 755 {} \;

    # If a Makefile is present, run make install
    if [ -f "$DEST/Makefile" ]; then
        info "  Running 'make install' in $DEST"
        make_log=$(make -C "$DEST" install 2>&1)
        make_status=$?
        if [ $make_status -eq 0 ]; then
            ok "  make install succeeded for $REPO"
        else
            warn "  'make install' failed for $REPO – continuing."
            printf '%s\n' "$make_log" >&2
        fi
    fi

    ok "$REPO installed."
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

printf '\n'
if [ -n "$FAILED" ]; then
    warn "The following repositories were not installed:$FAILED"
    exit 1
else
    ok "All repositories installed to $INSTALL_DIR"
fi
