#!/bin/bash

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="/etc/update-motd.d"

if [ "$(id -u)" -ne 0 ]; then
    echo "Re-running with sudo..."
    exec sudo bash "$0" "$@"
fi

# Scripts to symlink from this repo
symlink=(
    05-logo
    20-sysinfo
    35-diskspace
    40-services
    89-updates-available
)

# System scripts to deactivate
deactivate=(
    00-header
    50-motd-news
    90-updates-available
)

for name in "${symlink[@]}"; do
    dest="$TARGET/$name"
    if [ -L "$dest" ]; then
        echo "skip     $name (already symlinked)"
        continue
    fi
    ln -s "$REPO/$name" "$dest"
    echo "linked   $name"
done

for name in "${deactivate[@]}"; do
    dest="$TARGET/$name"
    if [ ! -f "$dest" ]; then
        echo "skip     $name (not found)"
        continue
    fi
    if [ ! -x "$dest" ]; then
        echo "skip     $name (already inactive)"
        continue
    fi
    chmod -x "$dest"
    echo "disabled $name"
done
