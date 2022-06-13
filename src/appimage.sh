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
wget -q https://github.com/balena-io/etcher/releases/download/v1.7.9/balena-etcher-electron-1.7.9-linux-x64.zip
wget -q https://github.com/tropy/tropy/releases/download/v1.11.1/tropy-1.11.1-x64.tar.bz2
axel -n 64 http://static-main.frdic.com/pkg/eudic.AppImage?v=2022-05-26

# copy appimages
#sudo mv -f ./appimage/applications/* /usr/share/applications/
#sudo mv -f ./appimage/opt/* /opt/
#sudo mv -f ./FastQC/ /opt/


# cleanup
rm -rf ./appimage

# notify end
echo -e " \n${TEXT_GREEN}AppImages Deployed!${TEXT_RESET} \n" && sleep 1

# mark setup.sh
sed -i 's+bash ./src/appimage.sh+#bash ./src/appimage.sh+g' ~/.setup_cache/setup.sh