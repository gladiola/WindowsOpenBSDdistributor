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
#   It copies each repository to <install_dir> and, where applicable,
#   sets executable bits on shell scripts and attempts a "make install".
#
#   Repositories handled:
#     OBJC-codespaces            – Objective-C / Codespaces setup files
#     OBJC-slowlorisdetector     – Slowloris detector (Objective-C)
#     OBJC-allowlisting          – HTTP allow-listing helper (Objective-C)
#     OBJC-HomemadeBlockProgram  – IP block program (Objective-C)
#     OpenBSDHomemadeBlockScripts – Shell-based block scripts for OpenBSD/pf
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
# Repository list
# ---------------------------------------------------------------------------

REPOS="
OBJC-codespaces
OBJC-slowlorisdetector
OBJC-allowlisting
OBJC-HomemadeBlockProgram
OpenBSDHomemadeBlockScripts
"

# ---------------------------------------------------------------------------
# Copy and configure each repository
# ---------------------------------------------------------------------------

FAILED=""

for REPO in $REPOS; do
    SRC="$REPOS_DIR/$REPO"
    DEST="$INSTALL_DIR/$REPO"

    if [ ! -d "$SRC" ]; then
        warn "Repository '$REPO' not found on USB drive – skipping."
        FAILED="$FAILED $REPO"
        continue
    fi

    info "Installing $REPO -> $DEST"

    # Copy repository (preserve timestamps; -R = recursive)
    cp -pR "$SRC" "$INSTALL_DIR/"

    # Make sure shell scripts are executable
    find "$DEST" -name '*.sh' -exec chmod 755 {} \;

    # If a Makefile with an install target is present, run it
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
# Post-install note for OpenBSDHomemadeBlockScripts
# ---------------------------------------------------------------------------

BLOCK_DEST="$INSTALL_DIR/OpenBSDHomemadeBlockScripts"
if [ -d "$BLOCK_DEST" ]; then
    printf '\n'
    info "OpenBSDHomemadeBlockScripts post-install note:"
    info "  Shell scripts are in: $BLOCK_DEST"
    info "  Review each script and update the interface/log paths to match"
    info "  your system before adding them to cron or rc.local."
fi

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
