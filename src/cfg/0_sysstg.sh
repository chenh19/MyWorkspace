#!/usr/bin/env bash
# This script configures KDE plasma settings

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


#-------------------------------------------------------------------------------------

# notify start
echo -e "${TEXT_YELLOW}Configuring KDE plasma system settings...${TEXT_RESET}\n" && sleep 1

######################################################################################

# Input & Output

## Mouse & Touchpad
### Touchpad (take effect after rebooting)
#### Extract the hex ID of the touchpad
hex_id=$(grep -i "Touchpad" /proc/bus/input/devices | sed 's/N: Name=".* \(.*\) Touchpad"/\1/')
#### Split hex_id into two parts
bus_hex=${hex_id%%:*}
dev_hex=${hex_id##*:}
#### Convert hex to decimal
bus_dec=$((16#$bus_hex))
dev_dec=$((16#$dev_hex))
####Get full touchpad name
touchpad_name=$(grep -i "Touchpad" /proc/bus/input/devices | sed -n 's/^N: Name="//p' | sed 's/"$//')
####Format the first line
libinput_line="[Libinput][$bus_dec][$dev_dec][$touchpad_name]"
####Write touchpad config
echo -e "$libinput_line" > ~/.config/kcminputrc
echo -e "ClickMethod=2\nNaturalScroll=true\nPointerAcceleration=0.200\nScrollFactor=0.3" >> ~/.config/kcminputrc
### Screen Edges > "no actiion" for all corners
kwriteconfig6 --file ~/.config/kwinrc --group Effect-overview --key BorderActivate --type string "9"

## Virtual Keyboard (take effect after rebooting)
### Select Fcitx5
kwriteconfig6 --file ~/.config/kwinrc --group Wayland --key InputMethod --type string "/usr/share/applications/org.fcitx.Fcitx5.desktop"

## Keyboard (take effect after rebooting)
### spectacle region: Alt+P
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.spectacle.desktop --key RectangularRegionScreenShot --type string "Alt+P"
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.spectacle.desktop --key RecordRegion --type string "Meta+Shift+R"
### Konsole: Meta+R
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.konsole.desktop --key NewWindow --type string "Meta+R"
### System Monitor: Ctrl+Shift+Esc
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.plasma-systemmonitor.desktop --key _launch --type string "Ctrl+Shift+Esc"
### System Settings > Shortcuts > Shortcuts > KWin:
### Close Window > Meta+Q
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Window Close' --type string "Meta+Q\tAlt+F4,Alt+F4,Close Window" && sed -i '/Window Close/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc
### Switch One Desktop to the Left: Meta+Ctrl+Left
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Left' --type string "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
### Switch One Desktop to the Right: Meta+Ctrl+Right
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Right' --type string "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"
### Toggle Overview: Meta+Tab
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Overview' --type string "Meta+Tab\tMeta+W,Meta+W,Toggle Overview" && sed -i '/Overview/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc
### Workspace Behavior > Activities > Switching > Customize two Global shortcuts as "None"
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'manage activities' --type string "none,none,Show Activity Switcher"
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'next activity' --type string "none,none,Walk through activities"
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'previous activity' --type string "none,none,Walk through activities (Reverse)"

## Accessibility > Shake Cursor > set "Magnification" to samllest
kwriteconfig6 --file ~/.config/kwinrc --group Effect-shakecursor --key Magnification --type string "2"

######################################################################################

# Apps & Windows

## Default Applications
kwriteconfig6 --file ~/.config/kdeglobals --group General --key BrowserApplication --type string "google-chrome.desktop"

## File ASsociations
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key ''  --type string ""
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/application.vnd.snapgene.dna'  --type string "snapgene-viewer.desktop;snapgene.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/biosequence.embl'  --type string "org.kde.kwrite.desktop;snapgene-viewer.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/javascript'  --type string "org.kde.kwrite.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/pdf'  --type string "okularApplication_pdf.desktop;google-chrome.desktop;zotero.desktop;krita_pdf.desktop;org.inkscape.Inkscape.desktop;libreoffice-draw.desktop;display-im6.q16.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.apple.keynote'  --type string "org.kde.kwrite.desktop;libreoffice-impress.desktop;org.kde.ark.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.debian.binary-package'  --type string "org.kde.discover.desktop;qapt-deb-installer.desktop;org.kde.ark.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.kde.kxmlguirc'  --type string "org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/vnd.palm'  --type string "pymol.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-gameboy-rom'  --type string "snapgene-viewer.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-ipynb+json'  --type string "jupyterlab-desktop.desktop;org.kde.kwrite.desktop;rstudio.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-mimearchive'  --type string "google-chrome.desktop;org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/xhtml+xml'  --type string "google-chrome.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-wine-extension-fa'  --type string "org.kde.kwrite.desktop;wine-extension-fa.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'chemical/x-fasta'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/gif'  --type string "com.interversehq.qView.desktop;krita_gif.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/jpeg'  --type string "com.interversehq.qView.desktop;krita_jpeg.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/png'  --type string "com.interversehq.qView.desktop;krita_png.desktop;org.kde.gwenview.desktop;google-chrome.desktop;okularApplication_kimgio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/tiff'  --type string "com.interversehq.qView.desktop;krita_tiff.desktop;org.kde.gwenview.desktop;okularApplication_kimgio.desktop;okularApplication_tiff.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'image/webp'  --type string "com.interversehq.qView.desktop;org.kde.gwenview.desktop;krita_qimageio.desktop;okularApplication_kimgio.desktop;google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'inode/directory'  --type string "org.kde.dolphin.desktop;rstudio.desktop;jupyterlab-desktop.desktop;org.kde.kate.desktop;org.kde.gwenview.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/css'  --type string "org.kde.kwrite.desktop;org.kde.kate.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/markdown'  --type string "org.kde.kwrite.desktop;okularApplication_md.desktop;rstudio.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/plain'  --type string "org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/vcard'  --type string "org.kde.kwrite.desktop;org.gnome.Evolution.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-c++src'  --type string "org.kde.kdevelop.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;rstudio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-csrc'  --type string "org.kde.kdevelop.desktop;rstudio.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-quarto-markdown'  --type string "rstudio.desktop;org.kde.kwrite.desktop;org.kde.kate.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-r-markdown'  --type string "rstudio.desktop;org.kde.kwrite.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;org.kde.kate.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'text/x-r-source'  --type string "org.kde.kwrite.desktop;org.kde.rkward.desktop;rstudio.desktop;libreoffice-writer.desktop;okularApplication_txt.desktop;org.kde.kate.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/geo'  --type string "qwant-maps-geo-handler.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/http'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/https'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/mailto'  --type string "org.gnome.Evolution.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'x-scheme-handler/tel'  --type string "org.kde.kdeconnect.handler.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/application.vnd.snapgene.dna'  --type string "snapgene-viewer.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/biosequence.embl'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/javascript'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/pdf'  --type string "okularApplication_pdf.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.apple.keynote'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.debian.binary-package'  --type string "org.kde.discover.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.kde.kxmlguirc'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/vnd.palm'  --type string "pymol.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-bittorrent'  --type string "freedownloadmanager_torrent.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-gameboy-rom'  --type string "snapgene-viewer.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-ipynb+json'  --type string "jupyterlab-desktop.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-mimearchive'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/xhtml+xml'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-wine-extension-fa'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'chemical/x-fasta'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/gif'  --type string "com.interversehq.qView.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/jpeg'  --type string "com.interversehq.qView.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/png'  --type string "com.interversehq.qView.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/tiff'  --type string "com.interversehq.qView.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'image/webp'  --type string "com.interversehq.qView.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'inode/directory'  --type string "org.kde.dolphin.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/css'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/html'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/markdown'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/plain'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/vcard'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-c++src'  --type string "org.kde.kdevelop.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-csrc'  --type string "org.kde.kdevelop.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-quarto-markdown'  --type string "rstudio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-r-markdown'  --type string "rstudio.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'text/x-r-source'  --type string "org.kde.kwrite.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/about'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/etcher'  --type string "balena-etcher-electron.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/fdm'  --type string "freedownloadmanager_fdm_up.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/geo'  --type string "qwant-maps-geo-handler.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/http'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/https'  --type string "google-chrome.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/magnet'  --type string "freedownloadmanager_magnet_up.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/mailto'  --type string "org.gnome.Evolution.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/simplenote'  --type string "simplenote.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/slack'  --type string "slack.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/tel'  --type string "org.kde.kdeconnect.handler.desktop;"
kwriteconfig6 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'x-scheme-handler/tropy'  --type string "Tropy.desktop;"

## Notification
### System Settings > Notification > Configure > Other Applications > uncheck "Show popups"
kwriteconfig6 --file ~/.config/plasmanotifyrc --group 'Applications' --group '@other' --key 'ShowPopups' --type bool "false"
### Notification > Configure > Network Management > Confirgure Events > uncheck "Show a message in a popup" for "Connection Activated"
echo -e '[Event/ConnectionActivated]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/NoLongerConnected]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/networkmanagement.notifyrc
### Notification > Configure > Discover > Confirgure Events > uncheck "Show a message in a popup" for "Updates Are Available"
echo -e '[Event/Update]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/UpdateResart]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/discoverabstractnotifier.notifyrc

## Window Management
### Desktop Effects > Appearance > uncheck "screen edge"
kwriteconfig6 --file ~/.config/kwinrc --group Plugins --key screenedgeEnabled --type bool "false"
### Virtual Desktop > uncheck "Navigation wraps around"
kwriteconfig6 --file ~/.config/kwinrc --group Windows --key RollOverDesktops --type bool "false"

######################################################################################

# Workspace

## General Behavior
### Clicking files or folders > "Selects them"
kwriteconfig6 --file ~/.config/kdeglobals --group KDE --key SingleClick --type bool "false"
### Double-click Interval: 500ms
kwriteconfig6 --file ~/.config/kdeglobals --group KDE --key DoubleClickInterval --type string "500"

## Search
### File Search > check "Enable File Search"
kwriteconfig6 --file ~/.config/baloofilerc --group Basic --key Indexing-Enabled --type string "Settings"
kwriteconfig6 --file ~/.config/baloofilerc --group 'Basic Settings' --key Indexing-Enabled --type bool "true"
kwriteconfig6 --file ~/.config/krunnerrc --group PlasmaRunnerManager --key migrated --type bool "true"
kwriteconfig6 --file ~/.config/krunnerrc --group Plugins --key baloosearchEnabled --type bool "true"
### Plasma Search > Config KRunner... > Position on screen > select "Center"
kwriteconfig6 --file ~/.config/krunnerrc --group General --key FreeFloating --type bool "true"
### System Settings > Search > Plasma Search > Config KRunner... > Activation > uncheck "Activate when pressing any key on desktop"
kwriteconfig6 --file ~/.config/krunnerrc --group General --key ActivateWhenTypingOnDesktop --type bool "false"
### System Settings > Search > Plasma Search > Config KRunner... > History > uncheck "Retain previous search"
kwriteconfig6 --file ~/.config/krunnerrc --group General --key RetainPriorSearch --type bool "false"

######################################################################################

# Security & Privacy

## Screen Locking > Lock screen automatically: 30minutes
kwriteconfig6 --file ~/.config/kscreenlockerrc --group Daemon --key Timeout --type string "30"

######################################################################################

# System

## Power Management
### Power Management > Energy Saving > On AC Power: 15min, 30min
### Power Management > Energy Saving > On Battery: 10min, 15min
### Power Management > Energy Saving > Low Battery: 5min, 10min
cp -f ./cfg/power/powerdevilrc ~/.config/
### Remove Hibernate
if grep -q "#AllowHibernation=yes" /etc/systemd/sleep.conf ; then sudo sed -i 's+#AllowHibernation=yes+AllowHibernation=no+g' /etc/systemd/sleep.conf ; fi

## Software Update
### Update software > select "Manually"
### Apply system updates > select "Immediately"
kwriteconfig6 --file ~/.config/discoverrc --group Software --key UseOfflineUpdates --type bool "false"
### Notification frequency > select "Monthly"
kwriteconfig6 --file ~/.config/PlasmaDiscoverUpdates --group Global --key RequiredNotificationInterval --type string '2592000'

## Session
### Desktop Session > On login, launch apps that were open > select "Start with an empty session"
kwriteconfig6 --file ~/.config/ksmserverrc --group General --key loginMode --type string "emptySession"

######################################################################################


#-------------------------------------------------------------------------------------

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/0_sysstg.sh+#bash ./cfg/0_sysstg.sh+g' ~/.setup_cache/setup.sh
