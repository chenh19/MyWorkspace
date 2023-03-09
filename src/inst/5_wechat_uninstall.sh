#!/bin/bash
#This script tries to remove dependency disrupting deepin-wine installed from [zq1997/deepin-wine](https://github.com/zq1997/deepin-wine)

## set terminal font color
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

## uninstall deepin-wine wechat
sudo apt-get remove com.qq.weixin.deepin -y

## remove deepin-wine apt source
[ -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list ] && sudo rm -f /etc/apt/sources.list.d/deepin-wine.i-m.dev.list
[ -f /etc/profile.d/deepin-wine.i-m.dev.sh ] && sudo rm -f /etc/profile.d/deepin-wine.i-m.dev.sh
if grep -q "deepin-wine" /etc/apt/sources.list ; then sudo sed -i '/deepin-wine/d' /etc/apt/sources.list ; fi

## cleanup
[ -d "~/Documents/WeChat File/" ] && rm -rf "~/Documents/WeChat File/"
[ -d ~/.deepinwine/ ] && rm -rf ~/.deepinwine/

## refresh apt sources
sudo apt-get update

## prompt end
echo -e " \n${TEXT_GREEN}All done! Hopefully your system dependencies will be stable again! ${TEXT_RESET} \n"
