#!/bin/bash
# This script installs flathub and Discover backend

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# notify start
echo -e " \n${TEXT_YELLOW}Installing Flathub...${TEXT_RESET} \n" && sleep 1

# add flathub to discover (KDE app store)
sudo apt-get install flatpak -y
sudo apt-get install plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# notify end
echo -e " \n${TEXT_GREEN}Flathub installed!${TEXT_RESET} \n" && sleep 1
