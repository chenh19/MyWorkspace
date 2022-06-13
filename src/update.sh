#!/bin/bash
# This script updates all packages in the system (deb/flatpak/snap)

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Updating system packages...${TEXT_RESET} \n" && sleep 1

# apt update & cleanup
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y

# flatpak update
sudo flatpak update -y

# snap update
sudo snap refresh

# R packges update
echo -e "update.packages(ask = FALSE, checkBuilt = TRUE)" > ./update.R
sudo Rscript ./update.R


# cleanup
rm update.R && sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}All system packages updated!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/update.sh+#bash ./src/update.sh+g' ~/.setup_cache/setup.sh
