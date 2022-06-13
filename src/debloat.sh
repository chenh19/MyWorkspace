#!/bin/bash
# This script removes unnecessary packages

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Debloating...${TEXT_RESET} \n" && sleep 1

# debloat
sudo snap remove firefox && sudo rm -r ~/snap/
sudo apt-get remove thunderbird krdc konversation ktorrent skanlite usb-creator-kde kmahjongg kmines kpat ksudoku -y


# cleanup
sudo apt-get update && sudo apt autoremove -y && sudo apt clean

# notify end
echo -e " \n${TEXT_GREEN}Debloated!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/debloat.sh+#bash ./src/debloat.sh+g' ~/.setup_cache/setup.sh
