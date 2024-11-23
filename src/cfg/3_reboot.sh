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
sudo echo ""
echo -e "${TEXT_YELLOW}Cleaning up setup cache...${TEXT_RESET} \n" && sleep 1
if [ -d ~/.setup_cache/ ]; then rm -rf ~/.setup_cache/; fi
bash ~/.shortcut.sh >/dev/null 2>&1
cp -f /usr/share/applications/org.kde.dolphin.desktop ~/Desktop/Dolphin.desktop && chmod +x ~/Desktop/Dolphin.desktop
cp -f /usr/share/applications/google-chrome.desktop ~/Desktop/Chrome.desktop && chmod +x ~/Desktop/Chrome.desktop
echo -e "[Desktop Entry]\nEmptyIcon=user-trash\nIcon=user-trash-full\nName=Trash\nType=Link\nURL[$e]=trash:/" > ~/Desktop/Trash.desktop
#echo -e "## Personalization:\n- [ ] Right click on desktop > Configure Desktop and Wallpaper > change wallpaper\n- [ ] System Settings > Workspace Behavior > Screen Locking > Appearance > Configue > change lock screen\n- [ ] System Settings > Startup and Shutdown > Login Screen (SDDM) > select the first one and change background\n- [ ] System Settings > Users > change avatar\n- [ ] Replace ~/.face with your avatar" > ~/Desktop/Personalization.md

# notify end
echo -e "${TEXT_GREEN}All done! The copies of licenses remain in [~/Licenses/] folder in case you need them later.${TEXT_RESET} \n"

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
