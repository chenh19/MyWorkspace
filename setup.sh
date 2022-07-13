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
mv -f ./MyWorkspace-main/setup.sh ./ && mv -f ./MyWorkspace-main/src/* ./src/ && rm -rf ./MyWorkspace-main/
echo -e " \n${TEXT_GREEN}All scripts downloaded${TEXT_RESET} \n" && sleep 1

# avoid re-downloading
sed -i 's+Downloading setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
sed -i '17,24d' ~/.setup_cache/setup.sh

# setup
#bash ./src/deb.sh #tested
#bash ./src/flathub.sh #tested
#bash ./src/appimage.sh #tested
#bash ./src/ukuu.sh #tested
#bash ./src/fcitx.sh #tested
#bash ./src/wechat.sh #tested
#bash ./src/game.sh #tested
#bash ./src/biodaily.sh #tested
#bash ./src/biodev.sh
#bash ./src/debloat.sh #tested
#bash ./src/update.sh #tested
#bash ./src/settings.sh
#bash ./src/reboot.sh #tested
#bash <(wget -qO- https://raw.githubusercontent.com/chenh19/alt_rm/main/install.sh) #tested


# final cleanup
#ask whether to delete cache
#rm -rf ~/.setup_cache/
