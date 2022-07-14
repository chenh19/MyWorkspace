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
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 1" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
        echo -e " \n${TEXT_YELLOW}Set global theme: Breeze Light${TEXT_RESET} \n" && sleep 1;;
  d|D ) plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 2" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "editor_theme": "Tomorrow Night", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
        echo -e " \n${TEXT_YELLOW}Set global theme: Breeze Dark${TEXT_RESET} \n" && sleep 1;;
  * ) 	plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 1" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
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

## Notification > Configure > Network Management > Confirgure Events > uncheck "Show a message in a popup" for "Connection Activated"
echo -e '[Event/ConnectionActivated] \nAction= \nExecute= \nLogfile= \nSound= \nTTS= \n \n[Event/NoLongerConnected] \nExecute= \nLogfile= \nSound= \nTTS=' > ~/.config/networkmanagement.notifyrc

## Notification > Configure > Discover > Confirgure Events > uncheck "Show a message in a popup" for "Updates Are Available"
echo -e '[Event/Update] \nAction= \nExecute= \Logfile= \nSound= \nTTS= \n \n[Event/UpdateResart] \nExecute= \nLogfile= \nSound= \nTTS=' > ~/.config/discoverabstractnotifier.notifyrc

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
sed -i '2,200d' ~/.config/touchpadxlibinputrc
echo -e "clickMethodAreas=false \nclickMethodClickfinger=true \nnaturalScroll=true \npointerAcceleration=0.6 \ntapToClick=true" | tee -a ~/.config/touchpadxlibinputrc

## KDE right click issue
sudo apt-get update && sudo apt-get install sxhkd -y && cp -rf ./cfg/sxhkd/ ~/.config/
echo -e "[Desktop Entry] \nName=sxhkd \nComment=Simple X hotkey daemon \nExec=/usr/bin/sxhkd \nTerminal=false \nType=Application" > ~/.config/autostart/sxhkd.desktop

######################################################################################

# Display and Monitor

## Scaling
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'How would you like to set to the scaling factor, 2.5 (a), 2.0 (b), 1.5 (c) or default 1.0 (d)? [a/b/c/d]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  a|A ) # Diskplay and Monitor > Display Configuration > Global scale: 250%
        # Right click on Taskbar, change height to 104
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "2.5"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=2.5;HDMI-1=2.5;DP-1=2.5;DP-2=2.5;DP3=2.5;DP4=2.5;"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "104"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "104"
        ;;
  b|B ) # Diskplay and Monitor > Display Configuration > Global scale: 200%
        # Right click on Taskbar, change height to 88
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "2"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=2;HDMI-1=2;DP-1=2;DP-2=2;DP3=2;DP4=2;"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "88"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "88"
        ;;
  c|C ) # Diskplay and Monitor > Display Configuration > Global scale: 150%
        # Right click on Taskbar, change height to 70
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "1.5"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=1.5;HDMI-1=1.5;DP-1=1.5;DP-2=1.5;DP3=1.5;DP4=1.5;"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "70"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "70"
        ;;
  * )   # Diskplay and Monitor > Display Configuration > Global scale: 100%
        # Right click on Taskbar, change height to 44
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "1"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=1;HDMI-1=1;DP-1=1;DP-2=1;DP3=1;DP4=1;"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "44"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "44"
        ;;
esac

## Nvidia
#sudo ubuntu-drivers autoinstall # Nvidia driver should has been automatically installed by Kubuntu
sudo lshw -C display > ./gpu.txt
if grep -q NVIDIA ./gpu.txt; then
    echo -e "RcFileLocale = C \nDisplayStatusBar = Yes \nSliderTextEntries = Yes \nIncludeDisplayNameInConfigFile = No \nShowQuitDialog = No \nUpdateRulesOnProfileNameChange = Yes" > ~/.nvidia-settings-rc
fi
rm ./gpu.txt

######################################################################################

# Power Management

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

# config grub if the timeout is 10s
sudo sed -i 's+GRUB_TIMEOUT=10+GRUB_TIMEOUT=2+g' /etc/default/grub #_this_is_neither_required_or_effective_for_Dell_XPS15
sudo update-grub

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}KDE plasma configured!${TEXT_RESET} \n" && sleep 5


#-------------------------------------------------------------------------------------

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./fonts/

# mark setup.sh
sed -i 's+bash ./src/cfgsys.sh+#bash ./src/cfgsys.sh+g' ~/.setup_cache/setup.sh
