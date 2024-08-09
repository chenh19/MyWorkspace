#!/bin/bash
# This script installs Chinese Pinyin input method (fcitx)

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing Chinese Pinyin input method...${TEXT_RESET} \n" && sleep 1
[ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
[ ! -d ~/.config/fcitx5/ ] && mkdir ~/.config/fcitx5/
[ ! -d ~/.config/fcitx5/conf/ ] && mkdir ~/.config/fcitx5/conf/
[ ! -d ~/.local/share/fcitx5/ ] && mkdir ~/.local/share/fcitx5/
[ ! -d ~/.local/share/fcitx5/themes/ ] && mkdir ~/.local/share/fcitx5/themes/
sudo apt-get update -qq && sudo apt-get upgrade -y

## install fcitx
sudo apt-get install fcitx5 fcitx5-pinyin fcitx5-chinese-addons fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-qt5 kde-config-fcitx5 fcitx5-config-qt -y
sudo apt-get --fix-missing update && sudo apt-get install -f -y

## install themes
[ ! -f fcitx5-themes.zip ] && wget -q "https://www.dropbox.com/scl/fi/7fldgym73qz3oq88z4ruh/fcitx5-themes.zip?rlkey=y9ko399f3pxkmne2mdkbxgxo9" -O fcitx5-themes.zip && sleep 1
unzip -o -q fcitx5-themes.zip -d ./cfg/ && sleep 1 && rm -f fcitx5-themes.zip && sleep 1
cp -rf ./cfg/fcitx5-themes/* ~/.local/share/fcitx5/themes/ && sleep 1

## config fcitx (takes effect after rebooting)
cp -f /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/org.fcitx.Fcitx5.desktop
cp -rf ./cfg/fcitx5/* ~/.config/fcitx5/
echo -e "${TEXT_YELLOW}To set Fcitx5 as the default input method, please:${TEXT_RESET} \n"
echo -e "${TEXT_YELLOW}> click ${TEXT_GREEN}[OK]${TEXT_YELLOW} and then ${TEXT_GREEN}[Yes]${TEXT_RESET}"
echo -e "${TEXT_YELLOW}> select ${TEXT_GREEN}[activate Flexible Input Method Framework v5 (fcitx5)]${TEXT_YELLOW} and click ${TEXT_GREEN}[OK]${TEXT_RESET}"
echo -e "${TEXT_YELLOW}> click ${TEXT_GREEN}[OK]${TEXT_YELLOW} to finish${TEXT_RESET} \n" && sleep 1
im-config

## config locales
echo -e " \n${TEXT_YELLOW}Please use [Space] to select ${TEXT_GREEN}zh_CN.UTF-8${TEXT_YELLOW} and then [Enter] to continue.${TEXT_RESET} \n" && sleep 5
sudo dpkg-reconfigure locales

## config environment
echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nGTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment

# cleanup
rm -rf ./cfg/fcitx5-themes/
sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Chinese Pinyin input method installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/2_fcitx.sh+#bash ./inst/2_fcitx.sh+g' ~/.setup_cache/setup.sh
