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
echo -e " \n${TEXT_GREEN}The copies of licenses remain in [~/Licenses/] folder in case you need them later.${TEXT_RESET} \n"
if [ -d ~/.setup_cache/ ]; then
  # ask whether to delete setup scripts
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the setup scripts in [~/.setup-cache/] folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -rf ~/.setup_cache/
          echo -e " \n${TEXT_GREEN}All setup scripts removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}Setup scripts remain in [~/.setup-cache/] folder.${TEXT_RESET} \n" && sleep 1;;
  esac
fi

# Desktop shortcuts
bash ~/.shortcut.sh >/dev/null 2>&1
cp -f /usr/share/applications/org.kde.dolphin.desktop ~/Desktop/Dolphin.desktop && chmod +x ~/Desktop/Dolphin.desktop && sleep 3
cp -f /usr/share/applications/google-chrome.desktop ~/Desktop/Chrome.desktop && chmod +x ~/Desktop/Chrome.desktop && sleep 3
echo -e "[Desktop Entry]\nEmptyIcon=user-trash\nIcon=user-trash-full\nName=Trash\nType=Link\nURL[$e]=trash:/" > ~/Desktop/Trash.desktop && sleep 3
echo -e "## Personalization:\n- [ ] Right click on desktop > Configure Desktop and Wallpaper > change wallpaper\n- [ ] System Settings > Workspace Behavior > Screen Locking > Appearance > Configue > change lock screen\n- [ ] System Settings > Startup and Shutdown > Login Screen (SDDM) > select the first one and change background\n- [ ] System Settings > Users > change avatar\n- [ ] Replace ~/.face with your avatar" > ~/Desktop/Personalization.md
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
