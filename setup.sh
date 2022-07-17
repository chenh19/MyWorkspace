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
sudo echo ""
echo -e "${TEXT_YELLOW}Checking internet connection...${TEXT_RESET} \n"
wget -q --spider http://google.com
until [[ $? -eq 0 ]] ; do
    read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'No internet connection! please first connect to internet then press [Enter] to continue.'$TEXT_RESET)"$' \n'
    echo ""
    wget -q --spider http://google.com
done
echo -e "${TEXT_GREEN}Internet is connected!${TEXT_RESET} \n" && sleep 1

# prepare setup scripts
echo -e "${TEXT_YELLOW}Downloading setup scripts...${TEXT_RESET} \n" && sleep 1
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && sleep 1
unzip -o -q main && sleep 1 && rm main
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./src/ ] && mkdir ./src/
cp -rf ./MyWorkspace-main/src/*.sh ./src/ 
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/ 
rm -rf ./MyWorkspace-main/
echo -e "${TEXT_GREEN}All scripts downloaded${TEXT_RESET} \n" && sleep 1

# avoid re-downloading
sed -i 's+Downloading setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
sed -i '27,39d' ~/.setup_cache/setup.sh
sed -i '39,43d' ~/.setup_cache/inst/wechat.sh

# setup
bash ./inst/deb.sh
bash ./inst/flathub.sh
bash ./inst/appimage.sh
bash ./inst/ukuu.sh
bash ./inst/fcitx.sh
bash ./inst/wechat.sh
bash ./inst/game.sh
bash ./inst/biodaily.sh
bash ./inst/biodevr.sh
bash ./inst/biodevpy.sh

# config
bash ./cfg/gitssh.sh
bash ./cfg/sysmdl.sh
bash ./cfg/sysstg.sh
bash ./cfg/sysapp.sh
bash ./cfg/sysdsp.sh
bash ./cfg/usrapp.sh
bash ./cfg/update.sh
bash ./cfg/reboot.sh
