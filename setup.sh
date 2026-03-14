#!/bin/bash

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="/etc/update-motd.d"

if [ "$(id -u)" -ne 0 ]; then
    echo "Re-running with sudo..."
    exec sudo bash "$0" "$@"
fi

for script in "$REPO"/[0-9]*; do
    name="$(basename "$script")"
    dest="$TARGET/$name"

    if [ -L "$dest" ]; then
        echo "skip   $name (symlink exists)"
        continue
    fi

    ln -s "$script" "$dest"
    echo "linked $name -> $dest"
done
