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
bash ./src/deb.sh
bash ./src/flathub.sh
bash ./src/appimage.sh
bash ./src/ukuu.sh
bash ./src/fcitx.sh
bash ./src/wechat.sh
bash ./src/game.sh
bash ./src/biodaily.sh
bash ./src/biodevr.sh
bash ./src/debloat.sh
bash ./src/update.sh
bash ./src/settings.sh
bash ./src/reboot.sh


# final cleanup
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the setup scripts in ~/.setup-cache/ folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) rm -rf ~/.setup_cache/
        echo -e " \n${TEXT_GREEN}All setup scripts removed!${TEXT_RESET} \n" && sleep 1;;
  * )   echo -e " \n${TEXT_YELLOW}Setup scripts kept in ~/.setup-cache/ folder.${TEXT_RESET} \n" && sleep 1;;
esac

# notify end
echo -e "${TEXT_GREEN}All done!${TEXT_RESET} \n";;
