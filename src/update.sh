#!/bin/bash
# This script updates all packages in the system (deb/flatpak/snap)

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# notify start
echo -e " \n${TEXT_YELLOW}Updating system packages...${TEXT_RESET} \n" && sleep 1

# apt update
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean

# flatpak update
sudo flatpak update -y

# snap update
sudo snap refresh

# notify end
echo -e " \n${TEXT_GREEN}All system packages updated!${TEXT_RESET} \n" && sleep 1
