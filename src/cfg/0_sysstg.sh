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

# Appearance

## System Settings > Appearance > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "M"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"

######################################################################################

# Workspace Behavior

## System Settings > Workspace Behavior > General Behavior > Clicking files or folders > "Selects them"
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick "false"

## System Settings > Workspace Behavior > Desktop Effects > uncheck "screen edge"
kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key screenedgeEnabled "false"

## System Settings > Workspace Behavior > Screen Edges > "no actiion" for all corners
kwriteconfig5 --file ~/.config/kwinrc --group Effect-windowview --key BorderActivateAll "9"

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
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Window Close' "Meta+Q\tAlt+F4,Alt+F4,Close Window" && sed -i '/Window Close/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc

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

## System Settings > Search > Plasma Search > Config KRunner... > Position on screen > select "Center"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key FreeFloating "true"

## System Settings > Search > Plasma Search > Config KRunner... > Activation > uncheck "Activate when pressing any key on desktop"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key ActivateWhenTypingOnDesktop "false"

## System Settings > Search > Plasma Search > Config KRunner... > History > uncheck "Retain previous search"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key RetainPriorSearch "false"

######################################################################################

# Notification

## System Settings > Notification > Configure > Other Applications > uncheck "Show popups"
kwriteconfig5 --file ~/.config/plasmanotifyrc --group 'Applications' --group '@other' --key 'ShowPopups' "false"

## Notification > Configure > Network Management > Confirgure Events > uncheck "Show a message in a popup" for "Connection Activated"
echo -e '[Event/ConnectionActivated]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/NoLongerConnected]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/networkmanagement.notifyrc

## Notification > Configure > Discover > Confirgure Events > uncheck "Show a message in a popup" for "Updates Are Available"
echo -e '[Event/Update]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/UpdateResart]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/discoverabstractnotifier.notifyrc

######################################################################################

# Applications

## System Settings > Applications > File Associations
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key '' ""
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/application.vnd.snapgene.dna' "snapgene-viewer.desktop;snapgene.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/biosequence.embl' "org.kde.kwrite.desktop;snapgene-viewer.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/javascript' "org.kde.kwrite.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/pdf' "okularApplication_pdf.desktop;google-chrome.desktop;zotero.desktop;krita_pdf.desktop;org.inkscape.Inkscape.desktop;libreoffice-draw.desktop;display-im6.q16.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.apple.keynote' "org.kde.kwrite.desktop;libreoffice-impress.desktop;org.kde.ark.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.debian.binary-package' "org.kde.discover.desktop;qapt-deb-installer.desktop;org.kde.ark.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.palm' "pymol.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-gameboy-rom' "snapgene-viewer.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-ipynb+json' "jupyterlab-desktop.desktop;org.kde.kwrite.desktop;rstudio.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-mimearchive' "google-chrome.desktop;org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/xhtml+xml' "google-chrome.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'chemical/x-fasta' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/gif' "com.interversehq.qView.desktop;krita_gif.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/jpeg' "com.interversehq.qView.desktop;krita_jpeg.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/png' "com.interversehq.qView.desktop;krita_png.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/tiff' "com.interversehq.qView.desktop;krita_tiff.desktop;org.kde.gwenview.desktop;okularApplication_kimgio.desktop;okularApplication_tiff.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/webp' "com.interversehq.qView.desktop;org.kde.gwenview.desktop;krita_qimageio.desktop;okularApplication_kimgio.desktop;google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'inode/directory' "org.kde.dolphin.desktop;rstudio.desktop;jupyterlab-desktop.desktop;org.kde.kate.desktop;org.kde.gwenview.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/css' "org.kde.kwrite.desktop;org.kde.kate.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/markdown' "org.kde.kwrite.desktop;okularApplication_md.desktop;rstudio.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/plain' "org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/vcard' "org.kde.kwrite.desktop;org.gnome.Evolution.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-c++src' "org.kde.kdevelop.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;rstudio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-csrc' "org.kde.kdevelop.desktop;rstudio.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-quarto-markdown' "rstudio.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-r-markdown' "rstudio.desktop;org.kde.kwrite.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;org.kde.kate.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-r-source' "org.kde.kwrite.desktop;org.kde.rkward.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;org.kde.kate.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/geo' "qwant-maps-geo-handler.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/http' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/https' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/mailto' "org.gnome.Evolution.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/tel' "org.kde.kdeconnect.handler.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/application.vnd.snapgene.dna' "snapgene-viewer.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/biosequence.embl' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/javascript' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/pdf' "okularApplication_pdf.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.apple.keynote' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.debian.binary-package' "org.kde.discover.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.palm' "pymol.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-bittorrent' "freedownloadmanager_torrent.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-gameboy-rom' "snapgene-viewer.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-ipynb+json' "jupyterlab-desktop.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-mimearchive' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/xhtml+xml' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'chemical/x-fasta' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/gif' "com.interversehq.qView.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/jpeg' "com.interversehq.qView.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/png' "com.interversehq.qView.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/tiff' "com.interversehq.qView.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/webp' "com.interversehq.qView.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'inode/directory' "org.kde.dolphin.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/css' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/html' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/markdown' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/plain' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/vcard' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-c++src' "org.kde.kdevelop.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-csrc' "org.kde.kdevelop.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-quarto-markdown' "rstudio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-r-markdown' "rstudio.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-r-source' "org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/about' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/etcher' "balena-etcher-electron.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/fdm' "freedownloadmanager_fdm_up.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/geo' "qwant-maps-geo-handler.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/http' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/https' "google-chrome.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/magnet' "freedownloadmanager_magnet_up.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/mailto' "org.gnome.Evolution.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/simplenote' "simplenote.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/slack' "slack.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/tel' "org.kde.kdeconnect.handler.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/tropy' "Tropy.desktop;"

## System Settings > Applications > Default Applications > Web browser > select "Google Chrome"
kwriteconfig5 --file ~/.config/kdeglobals --group General --key BrowserApplication "google-chrome.desktop"

######################################################################################

# Touchpad (take effect after rebooting)
cat /proc/bus/input/devices | grep "Touchpad" > ~/.config/touchpadxlibinputrc
sed -i 's+N: Name="+[+g' ~/.config/touchpadxlibinputrc
sed -i 's+"+]+g' ~/.config/touchpadxlibinputrc
sed -i '2,200d' ~/.config/touchpadxlibinputrc
echo -e "clickMethodAreas=false\nclickMethodClickfinger=true\nnaturalScroll=true\npointerAcceleration=0.4\ntapToClick=true" >> ~/.config/touchpadxlibinputrc

# Mouse
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key DoubleClickInterval "500"

######################################################################################

# Display and Monitor

## Nvidia

######################################################################################

# Power Management
## Power Management > Energy Saving > On AC Power: 10min, 15min (disable screen energy saving)
## Power Management > Energy Saving > On Battery: 5min, 10min (disable screen energy saving)
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DPMSControl --key idleTime "300"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key suspendType --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group SuspendSession --key suspendThenHibernate "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group BrightnessControl --key value --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group SuspendSession --key suspendThenHibernate "false"

## Remove Hibernate
if grep -q "#AllowHibernation=yes" /etc/systemd/sleep.conf ; then sudo sed -i 's+#AllowHibernation=yes+AllowHibernation=no+g' /etc/systemd/sleep.conf ; fi

## Sleep deep
#if ! grep -q "quiet splash mem_sleep_default=deep" /etc/default/grub ; then sudo sed -i 's+quiet splash +quiet splash mem_sleep_default=deep +g' /etc/default/grub && sudo update-grub && echo "" ; fi

######################################################################################

# Software Update

## System Update > Update software > select "Manually" and uncheck "Use offline updates"
kwriteconfig5 --file ~/.config/discoverrc --group Software --key UseOfflineUpdates "false"

## ## System Update > Update software > Notification frequency > select "Monthly"
kwriteconfig5 --file ~/.config/PlasmaDiscoverUpdates --group Global --key RequiredNotificationInterval '2592000' #_to_be_updated

#-------------------------------------------------------------------------------------

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/0_sysstg.sh+#bash ./cfg/0_sysstg.sh+g' ~/.setup_cache/setup.sh
