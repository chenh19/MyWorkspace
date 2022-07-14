#!/bin/bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# check internet connection

# download all setup scripts
sudo echo ""
echo -e "${TEXT_YELLOW}Downloading setup scripts...${TEXT_RESET} \n" && sleep 3
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && unzip -o -q main && rm main
[ ! -d ./src/ ] && mkdir ./src/
mv -f ./MyWorkspace-main/setup.sh ./ && mv -f ./MyWorkspace-main/src/* ./src/ 
[ ! -d ./cfg/ ] && mkdir ./cfg/
mv -f ./MyWorkspace-main/cfg/* ./src/ 
rm -rf ./MyWorkspace-main/
echo -e " \n${TEXT_GREEN}All scripts downloaded${TEXT_RESET} \n" && sleep 1

# avoid re-downloading
sed -i 's+Downloading setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
sed -i '19,30d' ~/.setup_cache/setup.sh

# setup
bash ./src/deb.sh
bash ./src/flathub.sh
bash ./src/appimage.sh
bash ./src/ukuu.sh
bash ./src/fcitx.sh
bash ./src/wechat.sh
bash ./src/game.sh
bash ./src/biodaily.sh
bash ./src/biodevr.sh
bash ./src/settings.sh
bash ./src/update.sh
bash ./src/reboot.sh
