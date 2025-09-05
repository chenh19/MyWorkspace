#!/usr/bin/env bash

# select image and make a copy
src="$1"
mkdir -p ~/.config/background/
cp -f "$src" ~/.config/background/
srcname=$(basename "$src")
file="$HOME/.config/background/$srcname"
filename="$srcname"

# set wallpaper
plasma-apply-wallpaperimage "$file"

# set lock screen
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'Image' --type string "$file"
kwriteconfig6 --file ~/.config/kscreenlockerrc --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key 'PreviewImage' --type string "$file"

# set sddm
sudo mkdir -p /usr/share/sddm/themes/breeze/
sudo cp "$file" /usr/share/sddm/themes/breeze/
sudo chmod 644 "/usr/share/sddm/themes/breeze/$filename"
sudo kwriteconfig6 --file /usr/share/sddm/themes/breeze/theme.conf --group General --key 'background' --type string "$filename"
sudo mkdir -p /usr/share/sddm/themes/debian-breeze/
sudo cp "$file" /usr/share/sddm/themes/debian-breeze/
sudo chmod 644 "/usr/share/sddm/themes/debian-breeze/$filename"
sudo kwriteconfig6 --file /usr/share/sddm/themes/debian-breeze/theme.conf --group General --key 'background' --type string "$filename"
