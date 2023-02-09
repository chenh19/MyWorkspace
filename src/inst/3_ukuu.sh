#!/bin/bash
# This script installs Ubuntu Kernel Update Utility (UKUU) and latest Linux kernel

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing UKUU...${TEXT_RESET} \n" && sleep 1

# download and install UKUU
wget -O - https://teejeetech.com/install-ukuu-8ALv9hCkUG.sh | bash
[ ! -d ~/.config/ukuu/ ] && mkdir ~/.config/ukuu/
[ -f ~/Licenses/license.dat ] && cp -rf ~/Licenses/license.dat ~/.config/ukuu/

# install latest kernel
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install the latest Linux kernal now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
      y|Y ) # add ppa
            echo -e " \n${TEXT_YELLOW}Installing the latest Linux kernel...${TEXT_RESET} \n"
            sudo ukuu --scripted --install-latest
            # notify end
            echo -e " \n${TEXT_GREEN}Linux kernel up to date! The latest kernel will be loaded automatically on the next reboot.${TEXT_RESET} \n" && sleep 1;;
        * ) # notify cancellation
              echo -e " \n${TEXT_YELLOW}Linux kernel remains as default and may be updated manually.${TEXT_RESET} \n" && sleep 1;;
esac

# mark setup.sh
sed -i 's+bash ./inst/3_ukuu.sh+#bash ./inst/3_ukuu.sh+g' ~/.setup_cache/setup.sh
