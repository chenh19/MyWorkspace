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
        sudo apt-get update && sudo apt-get install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy libjpeg62:i386 -y
        
        # install deepin wine
        wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
        
        # install weixin
        echo "" && sudo apt-get install com.qq.weixin.deepin -y
        
        # configure language
        echo -e " \n${TEXT_YELLOW}Please use [Space] to select ${TEXT_GREEN}zh_CN.UTF-8${TEXT_YELLOW} and then [Enter] to continue.${TEXT_RESET} \n" && sleep 5
        sudo dpkg-reconfigure locales
        [ -f /opt/deepinwine/tools/run.sh ] && sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run.sh
        [ -f /opt/deepinwine/tools/run_v2.sh ] && sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v2.sh
        [ -f /opt/deepinwine/tools/run_v3.sh ] && sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v3.sh
        [ -f /opt/deepinwine/tools/run_v4.sh ] && sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v4.sh
        [ -f /opt/deepinwine/tools/run_v5.sh ] && sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v5.sh

        # create shortcut
        sudo cp -f /opt/shortcut/com.qq.weixin.deepin.desktop /usr/share/applications/

        # run wechat for once
        "/opt/apps/com.qq.weixin.deepin/files/run.sh" -f %f && sleep 10 && killall -9 WeChat.exe && sleep 5

        # cleanup
        #rm -rf ./deepin-wine-ubuntu-master/
        sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}WeChat installed!${TEXT_RESET} \n" && sleep 1;;

  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}WeChat not installed.${TEXT_RESET} \n" && sleep 1;;

esac


# mark setup.sh
sed -i 's+bash ./inst/5_wechat.sh+#bash ./inst/5_wechat.sh+g' ~/.setup_cache/setup.sh
