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

if [ -f ~/Documents/gitssh.txt ]; then
  # ask whether to delete git ssh key
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete your Git SSH key saved in [~/Documents/gitssh.txt] file? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -f ~/Documents/gitssh.txt
          echo -e " \n${TEXT_GREEN}Your Git SSH Key removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}Your Git SSH Key remains in [~/Documents/gitssh.txt] file.${TEXT_RESET} \n" && sleep 1;;
  esac
fi


# notify end
echo -e "${TEXT_GREEN}All done!${TEXT_RESET} \n"

# detect whether reboot is required
if [ -f /var/run/reboot-required ]; then
  # ask whether reboot
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'System reboot required! Would you like to reboot the system now? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) # notify reboot
	  sudo echo ""
	  echo -e "${TEXT_YELLOW}Rebooting in 5 seconds...${TEXT_RESET} \n" && sleep 5
	  reboot;;
    * )   # notify cancellation
	  echo -e " \n${TEXT_YELLOW}Please manually reboot later.${TEXT_RESET} \n" && sleep 5;;
  esac
fi
