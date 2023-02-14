#!/bin/bash
# This script checks for reboot

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'


# final config
## mark ./setup.sh
sed -i 's+bash ./cfg/7_reboot.sh+#bash ./cfg/7_reboot.sh+g' ~/.setup_cache/setup.sh
## config after rebooting
cp -f ./cfg/finish/finish.sh ~/Desktop/ && chmod +x ~/Desktop/finish.sh

# final cleanup
if [ -d ~/.setup_cache/ ]; then
  # ask whether to delete setup scripts
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the setup scripts in [~/.setup-cache/] folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -rf ~/.setup_cache/
          echo -e " \n${TEXT_GREEN}All setup scripts removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}Setup scripts remain in [~/.setup-cache/] folder.${TEXT_RESET} \n" && sleep 1;;
  esac
fi

if [ -f ~/Licenses/license.dat ]; then
  # ask whether to delete licenses
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the copies of licenses saved in [~/Licenses/] folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -rf ~/Licenses/
          echo -e " \n${TEXT_GREEN}The copies of licenses have been removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}The copies of licenses remain in [~/Licenses/] folder in case you need them later.${TEXT_RESET} \n" && sleep 1;;
  esac
fi


# notify end
echo -e "${TEXT_GREEN}All done!${TEXT_RESET} \n"

# reboot
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'System reboot required! Would you like to reboot the system now? [y/n]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify reboot
	sudo echo ""
	echo -e "${TEXT_YELLOW}Rebooting in 5 seconds...${TEXT_RESET} \n" && sleep 5
	reboot;;
  * )   # notify cancellation
	echo -e " \n${TEXT_YELLOW}Please reboot the system manually later.${TEXT_RESET} \n" && sleep 1;;
esac
