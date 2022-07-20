 #!/bin/bash
# This script checks for reboot

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'


# final config
sed -i 's+bash ./cfg/7_reboot.sh+#bash ./cfg/7_reboot.sh+g' ~/.setup_cache/setup.sh
echo -e "[Desktop Entry] \nCategories=Qt;KDE;System;FileTools;FileManager; \nComment= \nExec=dolphin %u \nGenericName=File Manager \nIcon=system-file-manager \nInitialPreference=10 \nMimeType=inode/directory; \nName=Dolphin \nPath= \nStartupNotify=true \nStartupWMClass=dolphin \nTerminal=false \nTerminalOptions= \nType=Application" > ~/Desktop/dolphin.desktop
echo -e "[Desktop Action new-private-window] \nExec=/usr/bin/google-chrome-stable --incognito \nName=New Incognito Window \n \n[Desktop Action new-window] \nExec=/usr/bin/google-chrome-stable \nName=New Window \n \n[Desktop Entry] \nActions=new-window;new-private-window; \nCategories=Network;WebBrowser; \nComment=Access the Internet \nExec=/usr/bin/google-chrome-stable %U \nGenericName=Web Browser \nIcon=google-chrome \nMimeType=text/html;image/webp;image/png;image/jpeg;image/gif;application/xml;application/xml;application/xhtml+xml;application/rss+xml;application/rdf+xml;application/pdf; \nName=Chrome \nNoDisplay=false \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application \nVersion=1.0" > ~/Desktop/chrome.desktop
echo -e "[Desktop Entry] \nEmptyIcon=user-trash \nIcon=user-trash-full \nName=Trash \nType=Link \nURL[$e]=trash:/" > ~/Desktop/trash:⁄.desktop
echo -e "## Personalization: \n- [ ] Right click on desktop > Configure Desktop and Wallpaper > change wallpaper \n- [ ] System Settings > Workspace Behavior > Screen Locking > Appearance > Configue > change lock screen \n- [ ] System Settings > Startup and Shutdown > Login Screen (SDDM) > select the first one and change background \n- [ ] System Settings > Users > change avatar" > ~/Desktop/Personalization.md
sleep 1 && chmod +x ~/Desktop/*.desktop
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'State' "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"

# final cleanup
if [ -d ~/.setup_cache/ ]; then

  # ask whether to delete setup scripts
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the setup scripts in ~/.setup-cache/ folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
  
    y|Y ) rm -rf ~/.setup_cache/
          echo -e " \n${TEXT_GREEN}All setup scripts removed!${TEXT_RESET} \n" && sleep 1;;
	  
    * )   echo -e " \n${TEXT_YELLOW}Setup scripts kept in ~/.setup-cache/ folder.${TEXT_RESET} \n" && sleep 1;;
    
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
