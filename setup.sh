#!/bin/bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'


# set working directory
[ ! -d ~/.setup_cache ] && mkdir ~/.setup_cache
cd ~/.setup_cache


# notify start
echo -e " \n${TEXT_YELLOW}Downloading setup scripts...${TEXT_RESET} \n" && sleep 1


# download setup scripts
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && unzip -o -q main && rm main
cp -rf ./MyWorkspace-main/setup.sh ./
cp -rf ./MyWorkspace-main/src/ ./
rm -rf ./MyWorkspace-main


# notify end
echo -e " \n${TEXT_GREEN}All scripts downloaded${TEXT_RESET} \n" && sleep 1
