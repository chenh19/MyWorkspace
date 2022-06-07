#!/bin/bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# download all setup scripts
sudo echo ""
echo -e "${TEXT_YELLOW}Downloading setup scripts...${TEXT_RESET} \n" && sleep 1
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && unzip -o -q main && rm main
[ ! -d ./src/ ] && mkdir ./src/
mv -f ./MyWorkspace-main/setup.sh ./ && mv -f ./MyWorkspace-main/src/* ./src/ && rm -rf ./MyWorkspace-main/
echo -e " \n${TEXT_GREEN}All scripts downloaded${TEXT_RESET} \n" && sleep 1

# setup
#bash ./src/deb.sh
#bash ./src/flathub.sh
#bash ./src/ukuu.sh

read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install SnapGene, IGV, and PyMOL? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in 
  y|Y ) bash ./src/snapgene.sh;;
  n|N ) echo "skip";;
  * ) echo "skip";;
esac

bash ./src/snapgene.sh
#bash ./src/rstudio.sh
#bash ./src/update.sh

# final cleanup
#rm -rf ~/.setup_cache ~/setup.sh
