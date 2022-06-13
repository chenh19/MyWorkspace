#!/bin/bash
# This script installs Chinese Pinyin input method

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing Chinese Pinyin input method...${TEXT_RESET} \n" && sleep 1

## install fcitx
sudo apt-get update && sudo apt-get install fcitx kde-config-fcitx fcitx-sunpinyin -y

## setup environment
echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" \nXMODIFIERS=@im=fcitx \nQT_IM_MODULE=fcitx \nGTK_IM_MODULE=fcitx' > ./environment
sudo mv -f ./environment /etc/environment

## setup autostart
cp -rf /usr/share/applications/fcitx.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/fcitx.desktop

## start once to generate the config files
fcitx && sleep 10 && killall -9 fcitx

## config fcitx (takes effect after rebooting)
sed -i 's+#TriggerKey=CTRL_SPACE+TriggerKey=SUPER_SPACE+g' ~/.config/fcitx/config
sed -i 's+sunpinyin:False+sunpinyin:True+g' ~/.config/fcitx/profile
sed -i 's+#IMName=+IMName=sunpinyin+g' ~/.config/fcitx/profile


# cleanup
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Chinese Pinyin input method installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/fcitx.sh+#bash ./src/fcitx.sh+g' ~/.setup_cache/setup.sh
