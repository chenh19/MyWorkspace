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

# download and organize setup scripts
echo -e "${TEXT_YELLOW}Preparing setup scripts...${TEXT_RESET} \n" && sleep 1
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && sleep 1
unzip -o -q main && sleep 1 && rm main
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./inst/ ] && mkdir ./inst/
cp -rf ./MyWorkspace-main/src/inst/* ./inst/
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/
rm -rf ./MyWorkspace-main/

# save wechat sacling config for later
#echo "" >> ./cfg/usrapp.sh
#sed -n 39,43p ~/.setup_cache/inst/wechat.sh >> ./cfg/usrapp.sh
#sed -i '39,43d' ~/.setup_cache/inst/wechat.sh

# remove tabs
#sed -i -e 's/[ \t]*//' ./cfg/usrapp.sh

# add tabs
#sed -i 's/^/  /' ./cfg/usrapp.sh
#sed -i 's/^/        /' ./cfg/usrapp.sh
#sed -i 's/^/          /' ./cfg/usrapp.sh
#sed -i 's/^/                /' ./cfg/usrapp.sh

# ./cfg.cache

# add end
#echo -e '        # notify end \n        echo -e " \n${TEXT_GREEN}RStudio installed!${TEXT_RESET} \n" && sleep 5;; \n                 \n  * ) # notify cancellation \n        echo -e " \n${TEXT_YELLOW}RStudio not installed.${TEXT_RESET} \n" && sleep 5;; \nesac' >> ./cfg/usrapp.sh

# avoid re-downloading
#sed -i 's+Downloading setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
#sed -i '27,40d' ~/.setup_cache/setup.sh
echo -e "${TEXT_GREEN}All setup scripts ready!${TEXT_RESET} \n" && sleep 1

# setup
#bash ./inst/deb.sh
#bash ./inst/flathub.sh
#bash ./inst/appimage.sh
#bash ./inst/ukuu.sh
#bash ./inst/fcitx.sh
#bash ./inst/wechat.sh
#bash ./inst/game.sh
#bash ./inst/biodaily.sh
#bash ./inst/biodevr.sh
#bash ./inst/biodevpy.sh

# config
#bash ./cfg/gitssh.sh
#bash ./cfg/sysmdl.sh
#bash ./cfg/sysstg.sh
#bash ./cfg/sysapp.sh
#bash ./cfg/sysdsp.sh
#bash ./cfg/usrapp.sh
#bash ./cfg/update.sh
#bash ./cfg/reboot.sh
