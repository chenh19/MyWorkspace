#!/bin/bash
# bash <(wget -qO- https://raw.githubusercontent.com/chenh19/MyWorkspace/main/src/cfg/%23patch/jxq-xps13-fix.sh)

# remove deepin-wine apt source
[ -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list ] && sudo rm -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list
[ -f /etc/profile.d/deepin-wine.i-m.dev.sh ] && sudo rm -f /etc/profile.d/deepin-wine.i-m.dev.sh
if grep -q "deepin-wine" /etc/apt/sources.list ; then sudo sed -i '/deepin-wine/d' /etc/apt/sources.list ; fi
sudo apt-get update && sudo apt-get autoremove -y && sudo apt-get clean

# icons
[ ! -f main.zip ] && wget -q https://github.com/chenh19/MyWorkspace/archive/refs/heads/main.zip && sleep 1
unzip -o -q main.zip && sleep 1 && rm main.zip
sudo cp -rf ./MyWorkspace-main/src/cfg/icon/ /opt/ && sleep 1 && rm -rf ./MyWorkspace-main/

# sysupdate
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/sysupdate/main/install.sh)

# check "sudo apt update" and remove warning if needed
# sysupdate
