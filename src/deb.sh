#!/bin/bash
# This script installs deb packages by apt

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Deb packages installing...${TEXT_RESET} \n" && sleep 1

# install updates
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y

# install java
sudo apt-get update && sudo apt-get install default-jre default-jdk -y

# install apps (directly)
sudo apt-get install kwrite kcalc krita partitionmanager seahorse evolution evolution-ews xdotool kdocker curl -y

# install apps (downloaded
[ ! -d ./deb/ ] && mkdir ./deb/
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -q https://github.com/JoseExposito/touchegg/releases/download/2.0.14/touchegg_2.0.14_amd64.deb
mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./*.deb

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./deb

# notify end
echo -e " \n${TEXT_GREEN}Deb pacakges installed!${TEXT_RESET} \n" && sleep 1
