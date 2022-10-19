#!/bin/bash
# This script installs deepin-wine WeChat

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install wechat
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install WeChat? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing WeChat...${TEXT_RESET} \n" && sleep 1

        # install dependencies
        sudo apt-get update && sudo apt-get install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy libjpeg62:i386 -y

        # install deepin-wine
        wget -q https://www.dropbox.com/s/t43dz4ws6576r58/deepin-wine-ubuntu-master.zip?dl=0 && echo '"Deepin-wine WeChat" packages downloaded.' && sleep 5 #_to_be_updated
        unzip -o -q deepin-wine-ubuntu-master.zip?dl=0 && sleep 1 && rm -f deepin-wine-ubuntu-master.zip?dl=0 && sleep 1
        sudo bash ./deepin-wine-ubuntu-master/deepin-wine-setup.sh
        sudo bash ./deepin-wine-ubuntu-master/KDE-install.sh
        sudo ln -sf /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1.0 /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1
        
        # configure locale
        echo -e " \n${TEXT_YELLOW}Please use [Space] to select ${TEXT_GREEN}zh_CN.UTF-8${TEXT_YELLOW} and then [Enter] to continue.${TEXT_RESET} \n" && sleep 5
        sudo dpkg-reconfigure locales
        #sudo update-locale LANG=zh_CN.UTF-8 #doesn't work

        # install wechat
        sudo dpkg -i ./deepin-wine-ubuntu-master/deepin.com.wechat_2.6.8.65deepin0_i386.deb

        # configure language
        sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v2.sh
        "/opt/deepinwine/apps/Deepin-WeChat/run.sh" -u %u && sleep 10 && killall -9 WeChat.exe && sleep 5

        # cleanup
        rm -rf ./deepin-wine-ubuntu-master/ && sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}WeChat installed!${TEXT_RESET} \n" && sleep 1;;

  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}WeChat not installed.${TEXT_RESET} \n" && sleep 1;;

esac


# mark setup.sh
sed -i 's+bash ./inst/5_wechat.sh+#bash ./inst/5_wechat.sh+g' ~/.setup_cache/setup.sh
