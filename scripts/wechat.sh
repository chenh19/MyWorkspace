#!/bin/bash

#install wechat
sudo apt-get update && sudo apt-get install fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy libjpeg62:i386 -y
wget -q https://www.dropbox.com/s/t43dz4ws6576r58/deepin-wine-ubuntu-master.zip?dl=0 && unzip -o -q deepin-wine-ubuntu-master.zip?dl=0 && rm deepin-wine-ubuntu-master.zip?dl=0
sudo bash ./deepin-wine-ubuntu-master/deepin-wine-setup.sh
sudo bash ./deepin-wine-ubuntu-master/KDE-install.sh
sudo ln -sf /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1.0 /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1
sudo update-locale LANG=zh_CN.UTF-8
sudo dpkg -i ./deepin-wine-ubuntu-master/deepin.com.wechat_2.6.8.65deepin0_i386.deb
sudo sed -i 's+WINE_CMD="deepin-wine"+WINE_CMD="LC_ALL=zh_CN.UTF-8 deepin-wine"+g' /opt/deepinwine/tools/run_v2.sh
"/opt/deepinwine/apps/Deepin-WeChat/run.sh" -u %u && sleep 10 && killall -9 WeChat.exe
sed -i 's+"LogPixels"=dword:00000060+"LogPixels"=dword:000000c8+g' ~/.deepinwine/Deepin-WeChat/user.reg
