#!/bin/bash
# This script installs appimages

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Deploying AppImages...${TEXT_RESET} \n" && sleep 1

# download appimages
# Etcher
[ ! -d ~/.setup_cache/etcher/ ] && mkdir ~/.setup_cache/etcher/
wget -q https://github.com/balena-io/etcher/releases/download/v1.7.9/balena-etcher-electron-1.7.9-linux-x64.zip && sleep 5 #_to_be_updated
unzip -o -q *.zip && sleep 1 && rm *.zip && mv $(ls *.AppImage) balenaEtcher.AppImage && mv -f ./*.AppImage ./etcher/ && sleep 1
./etcher/balenaEtcher.AppImage --appimage-extract && sleep 1
cp -rf ./squashfs-root/usr/share/icons/hicolor/512x512/apps/balena-etcher-electron.png ./etcher/ && rm -rf ./squashfs-root/
mv $(ls ./etcher/*.png) ./etcher/balenaEtcher.png && sleep 1
# Tropy
[ ! -d ~/.setup_cache/tropy/ ] && mkdir ~/.setup_cache/tropy/
wget -q https://github.com/tropy/tropy/releases/download/v1.11.1/tropy-1.11.1-x64.tar.bz2 && sleep 5 #_to_be_updated
tar -xjf *.tar.bz2 -C ./tropy/ && sleep 1 && rm *tar.bz2
cp -rf ./tropy/resources/icons/hicolor/1024x1024/apps/tropy.png ./tropy/ && sleep 1
# Eudic
[ ! -d ~/.setup_cache/eudic/ ] && mkdir ~/.setup_cache/eudic/
wget -q https://www.dropbox.com/s/i4bvaktkxik5v1x/eudic.zip?dl=0 && sleep 5 #_to_be_updated
unzip -o -q eudic.zip?dl=0 && sleep 1 && rm eudic.zip?dl=0 && sleep 5

# move to /opt folder
sudo cp -rf ./etcher/ ./tropy/ ./eudic/ /opt/
sleep 1 && sudo chmod +x /opt/etcher/balenaEtcher.AppImage /opt/tropy/tropy /opt/eudic/eudic.AppImage

# create desktop icons
# Etcher
echo -e "[Desktop Entry] \nCategories=Utility; \nComment=Bootable USB Creator \nExec=/opt/etcher/balenaEtcher.AppImage \nGenericName= \nIcon=/opt/etcher/balenaEtcher.png \nMimeType= \nName=Etcher \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./etcher.desktop
# Tropy
echo -e "[Desktop Entry] \nCategories=Graphics; \nComment=Image Manager \nExec=/opt/tropy/tropy \nGenericName= \nIcon=/opt/tropy/tropy.png \nMimeType= \nName=Tropy \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./tropy.desktop
# Eudic
echo -e "[Desktop Entry] \nCategories=Office; \nComment=Dictionary \nExec=XDG_CURRENT_DESKTOP=GNOME /opt/eudic/eudic.AppImage \nGenericName= \nIcon=/opt/eudic/eudic.png \nMimeType= \nName=EuDic \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./eudic.desktop

# move to /usr/share/applications folder
sudo cp -rf ./*.desktop /usr/share/applications/ && sleep 5

# config
# Etcher
[ ! -d ~/.config/balena-etcher-electron/ ] && mkdir ~/.config/balena-etcher-electron/
echo -e '{ \n  "errorReporting": false, \n  "updatesEnabled": true, \n  "desktopNotifications": true, \n  "autoBlockmapping": true, \n  "decompressFirst": true \n}' > ~/.config/balena-etcher-electron/config.json


# cleanup
rm -rf ./etcher/ ./tropy/ ./eudic/ && rm ./*.desktop
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}AppImages Deployed!${TEXT_RESET} \n" && sleep 1

# mark setup.sh
sed -i 's+bash ./src/appimage.sh+#bash ./src/appimage.sh+g' ~/.setup_cache/setup.sh
