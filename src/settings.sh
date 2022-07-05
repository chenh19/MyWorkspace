#!/bin/bash
# This script configures KDE plasma settings

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


#-------------------------------------------------------------------------------------

# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Configuring KDE plasma...${TEXT_RESET} \n" && sleep 1

######################################################################################

# Appearance

## System Settings > Appearance > Global Theme > Breeze
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Light or Dark theme? [l/d/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  l|L ) plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        echo -e " \n${TEXT_YELLOW}Set global theme: Breeze Light${TEXT_RESET} \n" && sleep 1;;
  d|D ) plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        echo -e " \n${TEXT_YELLOW}Set global theme: Breeze Dark${TEXT_RESET} \n" && sleep 1;;
  * ) 	plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        echo -e " \n${TEXT_YELLOW}Set global theme: Breeze Light (default)${TEXT_RESET} \n" && sleep 1;;
esac

## System Settings > Appearance > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "M"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"

## System Settings > Appearance > Cursors > Size > 48 (take effect after rebooting)
kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorSize "48"

######################################################################################

# Workspace Behavior

## System Settings > Workspace Behavior > Desktop effects > uncheck "screen edge"
kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key screenedgeEnabled "false"

## System Settings > Workspace Behavior > Screen Edges > "no actiion" for all corners
kwriteconfig5 --file ~/.config/kwinrc --group Effect-PresentWindows --key BorderActivateAll "9"

## System Settings > Workspace Behavior > Virtual Desktop > uncheck "Navigation wraps around"
kwriteconfig5 --file ~/.config/kwinrc --group Windows --key RollOverDesktops "false"

######################################################################################

# Shotcuts (take effect after rebooting)

## System Settings > Shortcuts > Shortcuts > Add Application: 
### Konsole: Meta+R
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.konsole.desktop --key NewTab "none,none,Open a New Tab"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.konsole.desktop --key NewWindow "Meta+R,none,Open a New Window"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.konsole.desktop --key _k_friendly_name "Konsole"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.konsole.desktop --key _launch "none,none,Konsole"

### System Monitor: Ctrl+Shift+Esc
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.plasma-systemmonitor.desktop --key _k_friendly_name "System Monitor"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.plasma-systemmonitor.desktop --key _launch "Ctrl+Shift+Esc,none,System Monitor"

## Workspace Behavior > Activities > Switching > Customize two Global shortcuts as "None"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'manage activities' "none,none,Show Activity Switcher"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'next activity' "none,none,Walk through activities"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'previous activity' "none,none,Walk through activities (Reverse)"

## System Settings > Shortcuts > Shortcuts > KWin:
### Close Window > Meta+Q
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Window Close' "Meta+Q\tAlt+F4,Alt+F4,Close Window"
sed -i '/Window Close/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc

### Switch One Desktop to the Left: Meta+Ctrl+Left
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Left' "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"

### Switch One Desktop to the Right: Meta+Ctrl+Right
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Right' "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"

### Toggle Overview: Meta+Tab
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Overview' "Meta+Tab\tMeta+W,Meta+W,Toggle Overview"
sed -i '/Overview/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc

######################################################################################

# Startup and Shutdown

## System Settings > Startup and Shutdown > Desktop Session > When logging in > Start with an empty session
kwriteconfig5 --file ~/.config/ksmserverrc --group General --key loginMode "emptySession"

######################################################################################

# Search

## System Settings > Search > File Search > check "Enable File Search"
kwriteconfig5 --file ~/.config/baloofilerc --group Basic --key Indexing-Enabled "Settings"
kwriteconfig5 --file ~/.config/baloofilerc --group 'Basic Settings' --key Indexing-Enabled "true"
kwriteconfig5 --file ~/.config/krunnerrc --group PlasmaRunnerManager --key migrated "true"
kwriteconfig5 --file ~/.config/krunnerrc --group Plugins --key baloosearchEnabled "true"

## System Settings > Search > Plasma Search > KRunner position: Center
kwriteconfig5 --file ~/.config/krunnerrc --group General --key FreeFloating "true"

## System Settings > Search > Plasma Search > KRunner history: uncheck "Retain previous search"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key RetainPriorSearch "false"

######################################################################################

# Notification

## System Settings > Notification > Configure > Other Applications > uncheck "Show popups"
kwriteconfig5 --file ~/.config/plasmanotifyrc --group 'Applications' --group '@other' --key 'ShowPopups' "false"

######################################################################################

# Firewall

## System Settings > Firewall > check "Enabled"
sudo ufw enable

######################################################################################

# Input Devices (take effect after rebooting)

## System Settings > Input Devices > Touchpad > Pointer acceleration: 0.6-1.0
## System Settings > Input Devices > Touchpad > check "Tap-to-click", "Tap-and-drag", "Right-click", "Two fingers", "Invert scroll direction", "Press anywhere with two fingers"
cat /proc/bus/input/devices | grep -i syna > ~/.config/touchpadxlibinputrc # detect touchpad name
sed -i 's+N: Name="+[+g' ~/.config/touchpadxlibinputrc
sed -i 's+"+]+g' ~/.config/touchpadxlibinputrc
echo -e "clickMethodAreas=false \nclickMethodClickfinger=true \nnaturalScroll=true \npointerAcceleration=0.6 \ntapToClick=true" | tee -a ~/.config/touchpadxlibinputrc

## KDE right click issue
sudo apt-get update && sudo apt-get install sxhkd -y && cp -rf ./src/sxhkd/ ~/.config/
echo -e "[Desktop Entry] \nName=sxhkd \nComment=Simple X hotkey daemon \nExec=/usr/bin/sxhkd \nTerminal=false \nType=Application" > ~/.config/autostart/sxhkd.desktop

######################################################################################

# Display and Monitor

# Nvidia
echo -e "RcFileLocale = C \nDisplayStatusBar = Yes \nSliderTextEntries = Yes \nIncludeDisplayNameInConfigFile = No \nShowQuitDialog = No \nUpdateRulesOnProfileNameChange = Yes" > ~/.nvidia-settings-rc

######################################################################################

# Power Management

######################################################################################

# Change taskbar settings
# Right click on Taskbar, change height to 88
kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "88"
kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "88"

######################################################################################

# Clipboard > uncheck "Save clipboard contents on exit"
kwriteconfig5 --file ~/.config/klipperrc --group 'General' --key 'KeepClipboardContents' "false"

######################################################################################

## Clean up Application Launcher's favorite
favorites=$(grep 'Favorites-org.kde.plasma.kickoff.favorites.' ~/.config/kactivitymanagerd-statsrc | sed 's/\[//g' | sed 's/\]//g')
for favorite in $favorites
do
    kwriteconfig5 --file ~/.config/kactivitymanagerd-statsrc --group $favorite --key ordering "applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop"
done

######################################################################################

# create desktop shortcuts
echo -e "[Desktop Entry] \nCategories=Qt;KDE;System;FileTools;FileManager; \nComment= \nExec=dolphin %u \nGenericName=File Manager \nIcon=system-file-manager \nInitialPreference=10 \nMimeType=inode/directory; \nName=Dolphin \nPath= \nStartupNotify=true \nStartupWMClass=dolphin \nTerminal=false \nTerminalOptions= \nType=Application" > ~/Desktop/dolphin.desktop
sleep 1
echo -e "[Desktop Action new-private-window] \nExec=/usr/bin/google-chrome-stable --incognito \nName=New Incognito Window \n \n[Desktop Action new-window] \nExec=/usr/bin/google-chrome-stable \nName=New Window \n \n[Desktop Entry] \nActions=new-window;new-private-window; \nCategories=Network;WebBrowser; \nComment=Access the Internet \nExec=/usr/bin/google-chrome-stable %U \nGenericName=Web Browser \nIcon=google-chrome \nMimeType=text/html;image/webp;image/png;image/jpeg;image/gif;application/xml;application/xml;application/xhtml+xml;application/rss+xml;application/rdf+xml;application/pdf; \nName=Chrome \nNoDisplay=false \nPath= \nStartupNotify=true \nTerminal=false \nTerminalOptions= \nType=Application \nVersion=1.0" > ~/Desktop/chrome.desktop
sleep 1
echo -e "[Desktop Entry] \nEmptyIcon=user-trash \nIcon=user-trash-full \nName=Trash \nType=Link \nURL[$e]=trash:/" > ~/Desktop/trash:⁄.desktop
sleep 1
chmod +x ~/Desktop/*.desktop

######################################################################################

# label the /root
sudo e2label $(blkid | cut -f1 -d":") KubuntuHD

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}KDE plasma configured!${TEXT_RESET} \n" && sleep 5





#-------------------------------------------------------------------------------------

# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Configuring applications...${TEXT_RESET} \n" && sleep 1

######################################################################################

# Konsole

## Konsole window height 32
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x864' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x960' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1080' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1200' "625"

## Konsole window height 96
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x864' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x960' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1080' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1200' "803"

## konsole window show "Main Toolbar" and "Session Toolbar"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key State "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"

######################################################################################

## System Monitor
#Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,process.page,history.page,application.page"

######################################################################################

# spectacle
kwriteconfig5 --file ~/.config/spectaclerc --group GuiConfig --key 'quitAfterSaveCopyExport' "true"

######################################################################################

# okular
[ -f ~/.config/okularpartrc ] && rm ~/.config/okularpartrc
[ -f ~/.config/okularrc ] && rm ~/.config/okularrc
touch ~/.config/okularpartrc ~/.config/okularrc

# Settings > Configure Okular > General > check "Open new files in tabs"
kwriteconfig5 --file ~/.config/okularpartrc --group General --key 'ShellOpenFileInTabs' "true"

# Settings > Configure Okular > Performance > Memory usage > select "Greedy"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' "Greedy"

# Settings > Configure Okular > Presentation > uncheck "Show progress indicator"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Dlg Presentation' --key 'SlidesShowProgress' "false"

# Open and close multiple PDF files, uncheck "Warn me when I attempt to close multiple tabs"
kwriteconfig5 --file ~/.config/okularrc --group 'Notification Messages' --key 'ShowTabWarning' "false"

# Customized toolbars
[ -d ~/.local/share/kxmlgui5/okular/ ] && rm -rf ~/.local/share/kxmlgui5/okular/
cp -rf ./src/okular/ ~/.local/share/kxmlgui5/

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}All applications configured!${TEXT_RESET} \n" && sleep 5





#-------------------------------------------------------------------------------------

# mark setup.sh
sed -i 's+bash ./src/settings.sh+#bash ./src/settings.sh+g' ~/.setup_cache/setup.sh
