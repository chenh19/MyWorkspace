#!/usr/bin/env bash

# select image and make a copy
src="$1"
srcname=$(basename "$src")
filename="${srcname// /_}"
file="$HOME/.config/background/$filename"
mkdir -p $HOME/.config/background/
cp -f "$src" "$file"

# set wallpaper
plasma-apply-wallpaperimage "$file"

# set lock screen
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'Image' --type string "$file"
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'PreviewImage' --type string "$file"
