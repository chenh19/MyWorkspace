#!/bin/bash
# This script installs appimages

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Deploying AppImages...${TEXT_RESET} \n" && sleep 1

# install multithreaded downloader
sudo apt-get update && sudo apt-get install -y axel

# download appimages
#wget -q https://www.dropbox.com/s/oi8ffh9ogsir4ac/appimage.zip?dl=0 && unzip -o -q appimage.zip?dl=0 && rm appimage.zip?dl=0 #_backup_link
# Etcher
[ ! -d ~/.setup_cache/etcher/ ] && mkdir ~/.setup_cache/etcher/
wget -q https://github.com/balena-io/etcher/releases/download/v1.7.9/balena-etcher-electron-1.7.9-linux-x64.zip && sleep 3
unzip -o -q *.zip && rm *.zip && mv $(ls *.AppImage) balenaEtcher.AppImage && mv -f ./*.AppImage ./etcher/ && sleep 3
./etcher/balenaEtcher.AppImage --appimage-extract && sleep 3
cp -rf ./squashfs-root/usr/share/icons/hicolor/512x512/apps/balena-etcher-electron.png ./etcher/ && rm -rf ./squashfs-root/
mv $(ls ./etcher/*.png) ./etcher/balenaEtcher.png && sleep 1
# Tropy
[ ! -d ~/.setup_cache/tropy/ ] && mkdir ~/.setup_cache/tropy/
wget -q https://github.com/tropy/tropy/releases/download/v1.11.1/tropy-1.11.1-x64.tar.bz2 && sleep 3
tar -xjf *.tar.bz2 -C ./tropy/ && rm *tar.bz2 && sleep 3
cp -rf ./tropy/resources/icons/hicolor/1024x1024/apps/tropy.png ./tropy/ && sleep 1
# Eudic
[ ! -d ~/.setup_cache/eudic/ ] && mkdir ~/.setup_cache/eudic/
axel -n 64 http://static-main.frdic.com/pkg/eudic.AppImage?v=2022-05-26 && sleep 10
sudo ./eudic.AppImage --appimage-extract && sleep 5
cp -rf ./squashfs-root/*.png ./eudic/ && sudo rm -rf ./squashfs-root/
mv -f ./eudic.AppImage ./eudic/
mv $(ls ./eudic/*.png) ./eudic/eudic.png && sleep 1

# move to /opt folder
sudo cp -rf ./etcher/ ./tropy/ ./eudic/ /opt/

# create desktop icons
# Etcher
echo -e "[Desktop Entry] \nCategories=Utility; \nComment=Bootable USB Creator \nExec=/opt/etcher/balenaEtcher.AppImage \nGenericName= \nIcon=/opt/etcher/balenaEtcher.png \nMimeType= \nName=Etcher \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./etcher.desktop
# Tropy
echo -e "[Desktop Entry] \nCategories=Graphics; \nComment=Image Manager \nExec=/opt/tropy/tropy \nGenericName= \nIcon=/opt/tropy/tropy.png \nMimeType= \nName=Tropy \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./tropy.desktop
# Eudic
echo -e "[Desktop Entry] \nCategories=Office; \nComment=Dictionary \nExec=XDG_CURRENT_DESKTOP=GNOME /opt/eudic/eudic.AppImage \nGenericName= \nIcon=/opt/eudic/eudic.png \nMimeType= \nName=EuDic \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application" > ./eudic.desktop

# move to /usr/share/applications folder
sudo cp -rf ./*.desktop /usr/share/applications/


# cleanup
rm -rf ./etcher/ ./tropy/ ./eudic/ && rm ./*.desktop
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}AppImages Deployed!${TEXT_RESET} \n" && sleep 1

# mark setup.sh
sed -i 's+bash ./src/appimage.sh+#bash ./src/appimage.sh+g' ~/.setup_cache/setup.sh
