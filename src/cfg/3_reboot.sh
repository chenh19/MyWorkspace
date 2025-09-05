#!/usr/bin/env bash
# This script checks for reboot

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"


# final config
## mark ./setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/3_reboot.sh+#bash ./cfg/3_reboot.sh+g' ~/.setup_cache/setup.sh

# final cleanup
sudo echo ""
echo -e "${TEXT_YELLOW}Cleaning up setup cache...${TEXT_RESET}\n" && sleep 1
[ -f ~/.scale.sh ] && bash ~/.scale.sh >/dev/null 2>&1
[ -f ~/.shortcut.sh ] && bash ~/.shortcut.sh >/dev/null 2>&1
[ -f ~/.size-restore.sh ] && bash ~/.size-restore.sh >/dev/null 2>&1
[ -d ~/.setup_cache/ ] && rm -rf ~/.setup_cache/

# notify end
echo -e "${TEXT_GREEN}All done! The copies of licenses remain in [~/Licenses/] folder in case you need them later.${TEXT_RESET}\n\n" && sleep 1

# reboot # to update
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'System reboot required, would you like to reboot the system now? [y/n]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  y|Y ) sudo echo ""
        echo -e "${TEXT_YELLOW}Rebooting in 5 seconds...${TEXT_RESET}\n" && sleep 5
        systemctl reboot;;
    * ) echo -e "\n${TEXT_YELLOW}Please reboot the system manually later.${TEXT_RESET}\n" && sleep 1;;
esac
