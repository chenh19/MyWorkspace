#!/bin/bash
# This script does xxx

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache ] && mkdir ~/.setup_cache
cd ~/.setup_cache


# notify start
echo -e " \n${TEXT_YELLOW}Starting...${TEXT_RESET} \n" && sleep 1


# xxx


# notify end
echo -e " \n${TEXT_GREEN}Done!${TEXT_RESET} \n" && sleep 1
