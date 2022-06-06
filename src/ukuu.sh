#!/bin/bash
# This script installs Ubuntu Kernel Update Utility (UKUU)

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# notify start
echo -e " \n${TEXT_YELLOW}Installing UKUU...${TEXT_RESET} \n" && sleep 1

# download and install UKUU
wget -O - https://teejeetech.com/install-ukuu-8ALv9hCkUG.sh | bash

# write license key
[ ! -d ~/.config/ukuu/ ] && mkdir ~/.config/ukuu/
echo -e "SGFuZyBDaGVufGNoZW5faEBvdXRsb29rLmNvbXwzUE9NLURMWkEtVFdIRy1ITzgwLUM2Nlg=" > ~/.config/ukuu/license.dat

# notify end
echo -e " \n${TEXT_GREEN}UKUU activated!${TEXT_RESET} \n" && sleep 1
