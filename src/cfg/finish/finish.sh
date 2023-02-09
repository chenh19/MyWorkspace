#!/bin/bash

mv finish.sh .finish.sh
sleep 1
echo -e "[Desktop Entry] \nCategories=Qt;KDE;System;FileTools;FileManager; \nComment= \nExec=dolphin %u \nGenericName=File Manager \nIcon=system-file-manager \nInitialPreference=10 \nMimeType=inode/directory; \nName=Dolphin \nPath= \nStartupNotify=true \nStartupWMClass=dolphin \nTerminal=false \nTerminalOptions= \nType=Application" > ~/Desktop/dolphin.desktop
sleep 1
echo -e "[Desktop Action new-private-window] \nExec=/usr/bin/google-chrome-stable --incognito \nName=New Incognito Window \n \n[Desktop Action new-window] \nExec=/usr/bin/google-chrome-stable \nName=New Window \n \n[Desktop Entry] \nActions=new-window;new-private-window; \nCategories=Network;WebBrowser; \nComment=Access the Internet \nExec=/usr/bin/google-chrome-stable %U \nGenericName=Web Browser \nIcon=google-chrome \nMimeType=text/html;image/webp;image/png;image/jpeg;image/gif;application/xml;application/xml;application/xhtml+xml;application/rss+xml;application/rdf+xml;application/pdf; \nName=Chrome \nNoDisplay=false \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application \nVersion=1.0" > ~/Desktop/chrome.desktop
sleep 1
echo -e "[Desktop Entry] \nEmptyIcon=user-trash \nIcon=user-trash-full \nName=Trash \nType=Link \nURL[$e]=trash:/" > ~/Desktop/trash:⁄.desktop
sleep 1
echo -e "## Personalization: \n- [ ] Right click on desktop > Configure Desktop and Wallpaper > change wallpaper \n- [ ] System Settings > Workspace Behavior > Screen Locking > Appearance > Configue > change lock screen \n- [ ] System Settings > Startup and Shutdown > Login Screen (SDDM) > select the first one and change background \n- [ ] System Settings > Users > change avatar" > ~/Desktop/Personalization.md
sleep 1
chmod +x ~/Desktop/*.desktop
sleep 1
cat /proc/bus/input/devices | grep -i syna > ~/.config/touchpadxlibinputrc
sed -i 's+N: Name="+[+g' ~/.config/touchpadxlibinputrc
sed -i 's+"+]+g' ~/.config/touchpadxlibinputrc
sed -i '2,200d' ~/.config/touchpadxlibinputrc
echo -e "clickMethodAreas=false \nclickMethodClickfinger=true \nnaturalScroll=true \npointerAcceleration=0.6 \ntapToClick=true" >> ~/.config/touchpadxlibinputrc
sleep 1
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'State' "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,process.page,history.page,application.page"
sleep 1
## resilio sync
  # ask whether to config resilio sync
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Resilio Sync? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) # notify start
          echo -e " \n${TEXT_YELLOW}Please set the username and password for Resilio Sync. The Resilio Sync pro license is in [~/Documents/resilio/]. After confirguation, please close Google Chrome to continue. ${TEXT_RESET} \n" && sleep 1
          google-chrome https://localhost:8888
          echo -e " \n${TEXT_GREEN}Resilio Sync configured!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}Resilio Sync not configured.${TEXT_RESET} \n" && sleep 1;;
  esac
  
  if [ -d ~/Documents/resilio/ ]; then
  # ask whether to delete resilio sync pro license key
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to delete the Resilio Sync pro license in [~/Documents/resilio/] folder? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) rm -rf ~/Documents/resilio/
          echo -e " \n${TEXT_GREEN}Resilio Sync pro license removed!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}Resilio Sync pro license remains in [~/Documents/resilio/] folder.${TEXT_RESET} \n" && sleep 1;;
  esac
fi
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Resilio Sync? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
    y|Y ) # notify start
          echo -e " \n${TEXT_YELLOW}Please create a user for Resilio Sync and apply the license (license file is [~/Documents/license/Resilio_Sync_Personal_2zJbv2h.btskey]). Then, please close the web browser to continue.${TEXT_RESET} \n" && sleep 1
          google-chrome http://localhost:8888
          # notify end
          echo -e " \n${TEXT_GREEN}Resilio Sync configured!${TEXT_RESET} \n" && sleep 1;;
    * )   # notify cancellation
          echo -e " \n${TEXT_YELLOW}Resilio Sync not configured.${TEXT_RESET} \n" && sleep 1;;
esac
sysupdate
echo -e "igv\nPublic\nR\nLicenses\nTemplates\nsnap\nZotero" > ~/.hidden
echo -e "Enpass\nWeChat Files" > ~/Documents/.hidden
echo -e "bin\ndev\nlib\nlibx32\nmnt\nproc\nsbin\nswapfile\nusr\nboot\netc\nlib32\nlost+found\nopt\nroot\nsnap\nsys\nvar\ncdrom\nlib64\npackages.expandrive.gpg\nrun\nsrv\ntmp" | sudo tee /.hidden
echo -e "rslsync" | sudo tee /home/.hidden
rm -f .finish.sh
