#!/bin/bash

## Install fcitx
sudo apt-get update && sudo apt-get install fcitx kde-config-fcitx fcitx-sunpinyin -y

## Setup environment
echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" \nXMODIFIERS=@im=fcitx \nQT_IM_MODULE=fcitx \nGTK_IM_MODULE=fcitx' > ./fcitx/environment
sudo cp -rf ./fcitx/environment /etc/environment

## setup autostart
echo -e '[Desktop Entry] \nCategories=System;Utility; \nComment=Start Input Method \nExec=fcitx \nGenericName=Input Method \nIcon=fcitx \nName=Fcitx \nStartupNotify=false \nTerminal=false \nType=Application \nX-GNOME-AutoRestart=false \nX-GNOME-Autostart-Notify=false \nX-KDE-StartupNotify=false \nX-KDE-autostart-after=panel' > ~/.config/autostart/fcitx.desktop
sudo chmod +x ~/.config/autostart/fcitx.desktop

## config fcitx
#sed -i 's+TriggerKey=SUPER_SPACE+TriggerKey=SUPER_SPACE+g' ~/.config/fcitx/config
#sed -i 's+sunpinyin:FALSE+sunpinyin:True+g' ~/.config/fcitx/profile
