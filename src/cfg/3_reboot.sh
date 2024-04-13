#!/bin/bash
# This script checks for reboot

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'


# final config
## mark ./setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/3_reboot.sh+#bash ./cfg/3_reboot.sh+g' ~/.setup_cache/setup.sh

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

if [ -d ~/Licenses/ ]; then
  # ask whether to delete licenses
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the copies of licenses saved in [~/Licenses/] folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -rf ~/Licenses/
          echo -e " \n${TEXT_GREEN}The copies of licenses have been removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}The copies of licenses remain in [~/Licenses/] folder in case you need them later.${TEXT_RESET} \n" && sleep 1;;
  esac
fi

# Desktop shortcuts
bash ~/.shortcut.sh >/dev/null 2>&1
cp -f /usr/share/applications/org.kde.dolphin.desktop ~/Desktop/ && chmod +x ~/Desktop/org.kde.dolphin.desktop && sleep 1
cp -f /usr/share/applications/google-chrome.desktop ~/Desktop/ && chmod +x ~/Desktop/google-chrome.desktop && sleep 1
echo -e "[Desktop Entry]\nEmptyIcon=user-trash\nIcon=user-trash-full\nName=Trash\nType=Link\nURL[$e]=trash:/" > ~/Desktop/trash:⁄.desktop && sleep 1
echo -e "## Personalization:\n- [ ] Right click on desktop > Configure Desktop and Wallpaper > change wallpaper\n- [ ] System Settings > Workspace Behavior > Screen Locking > Appearance > Configue > change lock screen\n- [ ] System Settings > Startup and Shutdown > Login Screen (SDDM) > select the first one and change background\n- [ ] System Settings > Users > change avatar" > ~/Desktop/Personalization.md
sleep 1

# notify end
echo -e "${TEXT_GREEN}All done!${TEXT_RESET} \n"

# reboot
if [ -f /var/run/reboot-required ]; then
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'System reboot required, would you like to reboot the system now? [y/n]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) sudo echo ""
          echo -e "${TEXT_YELLOW}Rebooting in 5 seconds...${TEXT_RESET} \n" && sleep 5
          systemctl reboot;;
      * ) echo -e " \n${TEXT_YELLOW}Please reboot the system manually later.${TEXT_RESET} \n" && sleep 1;;
  esac
fi
