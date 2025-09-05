#!/usr/bin/env bash

# select image and make a copy
src="$1"
srcname=$(basename "$src")
mkdir -p /usr/share/sddm/themes/breeze/
cp -f "$src" /usr/share/sddm/themes/breeze/
chmod 644 "/usr/share/sddm/themes/breeze/$srcname"
mkdir -p /usr/share/sddm/themes/debian-breeze/
cp -f "$src" /usr/share/sddm/themes/debian-breeze/
chmod 644 "/usr/share/sddm/themes/debian-breeze/$srcname"

# set sddm
kwriteconfig6 --file /usr/share/sddm/themes/breeze/theme.conf --group General --key 'background' --type string "$srcname"
kwriteconfig6 --file /usr/share/sddm/themes/debian-breeze/theme.conf --group General --key 'background' --type string "$srcname"
