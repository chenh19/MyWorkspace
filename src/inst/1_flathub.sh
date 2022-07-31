#!/bin/bash
# This script installs flathub and Discover backend

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing Flathub...${TEXT_RESET} \n" && sleep 1
sudo apt-get update && sudo apt-get upgrade -y

# add flathub to discover (KDE app store)
sudo apt-get install flatpak plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install apps
sudo flatpak install -y --noninteractive flathub org.kde.kclock
sudo flatpak install -y --noninteractive flathub org.kde.kweather
sudo flatpak install -y --noninteractive flathub com.github.joseexposito.touche
sudo flatpak install -y --noninteractive flathub com.usebottles.bottles

# config
## touchegg
[ ! -d ~/.config/touchegg/ ] && mkdir ~/.config/touchegg/
cp -f ./cfg/touchegg/* ~/.config/touchegg/


# cleanup
sudo snap remove firefox
[ -d ~/snap/ ] && sudo rm -rf ~/snap/
[ -d ~/Downloads/firefox.tmp/ ] && sudo rm -rf ~/Downloads/firefox.tmp/
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Flathub installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./inst/1_flathub.sh+#bash ./inst/1_flathub.sh+g' ~/.setup_cache/setup.sh
