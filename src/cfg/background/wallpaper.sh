#!/usr/bin/env bash

# select image and make a copy
src="$1"
srcname=$(basename "$src")
mkdir -p $HOME/.config/background/
cp -f "$src" $HOME/.config/background/

# set wallpaper
plasma-apply-wallpaperimage "$HOME/.config/background/$srcname"

# set lock screen
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'Image' --type string "$HOME/.config/background/$srcname"
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'PreviewImage' --type string "$HOME/.config/background/$srcname"
