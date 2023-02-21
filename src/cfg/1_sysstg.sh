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
echo -e "${TEXT_YELLOW}Configuring KDE plasma system settings...${TEXT_RESET} \n" && sleep 1

######################################################################################

# git ssh
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/git_ssh/main/gitssh.sh)

######################################################################################

# wifi
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure WiFi connections? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
    y|Y ) nmtui
          echo -e " \n${TEXT_GREEN}WiFi configuration finished!${TEXT_RESET} \n" && sleep 1;;
    * )   echo -e " \n${TEXT_YELLOW}WiFi configuration skipped.${TEXT_RESET} \n" && sleep 1;;
esac

######################################################################################

# Appearance

## System Settings > Appearance > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "M"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"

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

### spectacle region: Alt+P
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.spectacle.desktop --key 'RectangularRegionScreenShot' "Alt+P,Meta+Shift+Print,Capture Rectangular Region"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group org.kde.spectacle.desktop --key '_launch' "Print,Print,Spectacle"

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

# Default applications
cp -f ./cfg/default/mimeapps.list ~/.config/

######################################################################################

# Firewall

## System Settings > Firewall > check "Enabled"
sudo ufw enable

######################################################################################

# Input Devices (take effect after rebooting)

## KDE right click issue
sudo apt-get update && sudo apt-get install sxhkd -y && cp -rf ./cfg/sxhkd/ ~/.config/
[ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
echo -e "[Desktop Entry] \nName=sxhkd \nComment=Simple X hotkey daemon \nExec=/usr/bin/sxhkd \nTerminal=false \nType=Application" > ~/.config/autostart/sxhkd.desktop

######################################################################################

# Display and Monitor

## Nvidia
#sudo ubuntu-drivers autoinstall # Nvidia driver should has been automatically installed by Kubuntu
sudo lshw -C display > ./gpu.txt
if grep -q NVIDIA ./gpu.txt; then
    echo -e "RcFileLocale = C \nDisplayStatusBar = Yes \nSliderTextEntries = Yes \nIncludeDisplayNameInConfigFile = No \nShowQuitDialog = No \nUpdateRulesOnProfileNameChange = Yes" > ~/.nvidia-settings-rc
fi
rm -f ./gpu.txt

######################################################################################

# Power Management
#Power Management > Energy Saving > On AC Power: 10min, 15min (disable screen energy saving)
#Power Management > Energy Saving > On Battery: 5min, 10min (disable screen energy saving)
cp -rf ./cfg/power/powermanagementprofilesrc ~/.config/

######################################################################################

# config grub if the timeout is 10s #_this_is_neither_required_or_effective_for_Dell_XPS15
if grep -q "GRUB_TIMEOUT=10" /etc/default/grub ; then sudo sed -i 's+GRUB_TIMEOUT=10+GRUB_TIMEOUT=2+g' /etc/default/grub && sudo update-grub ; fi
# If grub timeout is 0, press Shift+Esc only once at startup to enter grub menu

######################################################################################

# System Update: Manually, and make sure "Use offline updates" is uncheck
kwriteconfig5 --file ~/.config/discoverrc --group Software --key UseOfflineUpdates "false"

######################################################################################

# apt warning
echo -e " \n${TEXT_YELLOW}Please quit Slack from system tray to continue.${TEXT_RESET} \n" && sleep 10 && slack
echo -e " \n${TEXT_YELLOW}Transferring legacy gpg.${TEXT_RESET} \n" && sleep 1
echo -e "${TEXT_YELLOW}Please manually assign the IDs (last 8 characters, no space) , then save and close the script file to continue.${TEXT_RESET} \n"
sudo apt-key list >> ./cfg/apt/apt_warning.sh && kwrite ./cfg/apt/apt_warning.sh
sleep 1 && sed -i "30,500d" ./cfg/apt/apt_warning.sh
sleep 1 && bash ./cfg/apt/apt_warning.sh && sleep 1
sudo apt-get update
echo -e " \n${TEXT_GREEN}All legacy gpg transferred!${TEXT_RESET} \n" && sleep 1

######################################################################################

# ESM warning
if grep -q "deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-security main" /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list ; then sudo sed -i 's+deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-security main+#deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-security main+g' /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list  && sudo update-grub ; fi
if grep -q "deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-updates main" /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list ; then sudo sed -i 's+deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-updates main+#deb https://esm.ubuntu.com/apps/ubuntu jammy-apps-updates main+g' /var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list  && sudo update-grub ; fi
sudo update-grub

######################################################################################

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}KDE plasma system settings configured!${TEXT_RESET} \n" && sleep 5

#-------------------------------------------------------------------------------------


# mark setup.sh
sed -i 's+bash ./cfg/2_sysstg.sh+#bash ./cfg/2_sysstg.sh+g' ~/.setup_cache/setup.sh
