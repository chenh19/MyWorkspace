#!/bin/bash
# This script fixes missing dependencies

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Double checking any missing dependencies...${TEXT_RESET} \n" && sleep 1

# fix missings
sudo apt-get --fix-missing update
sudo apt-get install -y $(check-language-support)
sduo apt-get install -f -y


# cleanup
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}All dependencies fulfilled!${TEXT_RESET} \n" && sleep 5