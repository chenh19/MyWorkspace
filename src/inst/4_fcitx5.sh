#!/bin/bash
# This script installs Chinese Pinyin input method (fcitx)

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install Chinese Pinyin input method
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Chinese Pinyin input method? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing Chinese Pinyin input method...${TEXT_RESET} \n" && sleep 1
        [ ! -d ~/.config/fcitx5/ ] && mkdir ~/.config/fcitx5/
        [ ! -d ~/.config/fcitx5/conf/ ] && mkdir ~/.config/fcitx5/conf/
        [ ! -d ~/.local/share/fcitx5/ ] && mkdir ~/.local/share/fcitx5/
        [ ! -d ~/.local/share/fcitx5/themes/ ] && mkdir ~/.local/share/fcitx5/themes/
        [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
        sudo apt-get update && sudo apt-get upgrade -y

        ## install fcitx
        sudo apt-get install fcitx5 fcitx5-pinyin fcitx5-chinese-addons fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-qt5 kde-config-fcitx5 fcitx5-config-qt -y
        sudo apt-get --fix-missing update && sudo apt-get install -y $(check-language-support) && sudo apt-get install -f -y

        ## install themes
        wget -q https://www.dropbox.com/s/fpnlkogqchbzkua/fcitx5-themes.zip?dl=0 && sleep 1
        unzip -o -q fcitx5-themes.zip?dl=0 -d ~/.setup_cache/cfg/ && sleep 1 && rm -f fcitx5-themes.zip?dl=0 && sleep 5
        cp -rf ~/.setup_cache/cfg/fcitx5-themes/* ~/.local/share/fcitx5/themes/

        ## set default im
        echo -e "${TEXT_YELLOW}To set Fcitx5 as the default input method, please:${TEXT_RESET} \n"
        echo -e "${TEXT_YELLOW}> click ${TEXT_GREEN}[OK]${TEXT_YELLOW} and then ${TEXT_GREEN}[Yes]${TEXT_RESET}"
        echo -e "${TEXT_YELLOW}> select ${TEXT_GREEN}[activate Flexible Input Method Framework v5 (fcitx5) @]${TEXT_YELLOW} and click ${TEXT_GREEN}[OK]${TEXT_RESET}"
        echo -e "${TEXT_YELLOW}> click ${TEXT_GREEN}[OK]${TEXT_YELLOW} to finish${TEXT_RESET} \n" && sleep 1
        im-config

        ## config fcitx (takes effect after rebooting)
        cp -rf /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/org.fcitx.Fcitx5.desktop
        cp -rf ~/.setup_cache/cfg/fcitx5/* ~/.config/fcitx5/

        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}Chinese Pinyin input method installed!${TEXT_RESET} \n" && sleep 5;;

  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Chinese Pinyin input method not installed.${TEXT_RESET} \n" && sleep 5;;

esac


# mark setup.sh
sed -i 's+bash ./inst/4_fcitx5.sh+#bash ./inst/4_fcitx5.sh+g' ~/.setup_cache/setup.sh
