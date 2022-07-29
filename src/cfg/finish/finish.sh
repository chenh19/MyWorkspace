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
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'State' "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"
sleep 1
cat /proc/bus/input/devices | grep -i syna > ~/.config/touchpadxlibinputrc
sed -i 's+N: Name="+[+g' ~/.config/touchpadxlibinputrc
sed -i 's+"+]+g' ~/.config/touchpadxlibinputrc
sed -i '2,200d' ~/.config/touchpadxlibinputrc
echo -e "clickMethodAreas=false \nclickMethodClickfinger=true \nnaturalScroll=true \npointerAcceleration=0.6 \ntapToClick=true" | tee -a ~/.config/touchpadxlibinputrc
sleep 1
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,process.page,history.page,application.page"
sleep 1
rm -f .finish.sh
