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
        sudo apt-get update && sudo apt-get upgrade -y
        
        ## install fcitx
        sudo apt-get install fcitx kde-config-fcitx fcitx-sunpinyin -y

        ## setup environment
        sudo cp -f ./cfg/environment/environment /etc/

        ## setup autostart
        [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
        cp -rf /usr/share/applications/fcitx.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/fcitx.desktop

        ## start once to generate the config files
        fcitx && sleep 10 && killall -9 fcitx

        ## config fcitx (takes effect after rebooting)
        sed -i 's+#TriggerKey=CTRL_SPACE+TriggerKey=SUPER_SPACE SHIFT_LSHIFT+g' ~/.config/fcitx/config
        sed -i 's+#SwitchKey=L_SHIFT+SwitchKey=SHIFT Both+g' ~/.config/fcitx/config
        sed -i 's+sunpinyin:False+sunpinyin:True+g' ~/.config/fcitx/profile
        sed -i 's+#IMName=+IMName=sunpinyin+g' ~/.config/fcitx/profile

        # cleanup
        sudo apt remove fcitx5 kde-config-fcitx5 -y
        sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}Chinese Pinyin input method installed!${TEXT_RESET} \n" && sleep 5;;

  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Chinese Pinyin input method not installed.${TEXT_RESET} \n" && sleep 5;;

esac


# mark setup.sh
sed -i 's+bash ./inst/4_fcitx.sh+#bash ./inst/4_fcitx.sh+g' ~/.setup_cache/setup.sh
