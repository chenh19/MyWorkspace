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
kwriteconfig5 --file ~/.config/kwinrc --group Effect-overview --key BorderActivate "9"

### Touchpad gestures
#### Global
sudo apt update -qq && sudo apt install git cmake g++ extra-cmake-modules qt6-tools-dev kwin-wayland kwin-dev libkf6configwidgets-dev gettext libkf6kcmutils-dev libyaml-cpp-dev libxkbcommon-dev pkg-config libevdev-dev -y
[ ! -f InputActions.zip ] && wget -q "https://www.dropbox.com/scl/fi/q5totw0zok4cwvj0mjr0g/InputActions.zip?rlkey=2n5x30p3n2ghuirse7evjyavx" -O InputActions.zip && sleep 1
unzip -o -q InputActions.zip -d ./cfg/ && sleep 1 && rm -f InputActions.zip && sleep 1
## unzip to a fixed folder name, or just copy ##

#        [ ! -d ./cfg/InputActions/ ] && sudo mkdir ./cfg/InputActions/
#        sudo cp -rf ./IGV_Linux_*/* /opt/igv/ && sleep 1
#        rm -rf ./IGV_Linux_*/

#mkdir ./cfg/InputActions/build
#cmake ./cfg/InputActions -DCMAKE_INSTALL_PREFIX=/usr -DINPUTACTIONS_BUILD_KWIN=ON
#make -C ./cfg/InputActions/build -j$(nproc)
#sudo make -C ./cfg/InputActions/build install

cp -rf ./cfg/inputactions/ ~/.config/
#### Google Chrome
[ -f /usr/share/applications/google-chrome.desktop ] && sudo desktop-file-edit \
    --set-key 'Exec' --set-value '/usr/bin/google-chrome-stable --ozone-platform=wayland --enable-features=TouchpadOverscrollHistoryNavigation,PreferredOzonePlatform %U' \
/usr/share/applications/google-chrome.desktop

## Virtual Keyboard (take effect after rebooting)
### Select Fcitx5
kwriteconfig5 --file ~/.config/kwinrc --group Wayland --key InputMethod "/usr/share/applications/org.fcitx.Fcitx5.desktop"

## Keyboard (take effect after rebooting)
### spectacle region: Alt+P
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.spectacle.desktop --key RectangularRegionScreenShot "Alt+P"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.spectacle.desktop --key RecordRegion "Meta+Shift+R"
### Konsole: Meta+R
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.konsole.desktop --key NewWindow "Meta+R"
### System Monitor: Ctrl+Shift+Esc
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group services --group org.kde.plasma-systemmonitor.desktop --key _launch "Ctrl+Shift+Esc"
### System Settings > Shortcuts > Shortcuts > KWin:
### Close Window > Meta+Q
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Window Close' "Meta+Q\tAlt+F4,Alt+F4,Close Window" && sed -i '/Window Close/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc
### Switch One Desktop to the Left: Meta+Ctrl+Left
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Left' "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
### Switch One Desktop to the Right: Meta+Ctrl+Right
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Switch One Desktop to the Right' "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"
### Toggle Overview: Meta+Tab
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group kwin --key 'Overview' "Meta+Tab\tMeta+W,Meta+W,Toggle Overview" && sed -i '/Overview/s/\\\\t/\\t/g' ~/.config/kglobalshortcutsrc
### Workspace Behavior > Activities > Switching > Customize two Global shortcuts as "None"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'manage activities' "none,none,Show Activity Switcher"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'next activity' "none,none,Walk through activities"
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group plasmashell --key 'previous activity' "none,none,Walk through activities (Reverse)"

######################################################################################

# Appearance & Style

## Colors & Themes > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "M"
kwriteconfig5 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"

######################################################################################

# Apps & Windows

## Default Applications
kwriteconfig5 --file ~/.config/kdeglobals --group General --key BrowserApplication "google-chrome.desktop"

## File ASsociations
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
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Added Associations' --key 'application/x-wine-extension-fa' "org.kde.kwrite.desktop;wine-extension-fa.desktop;"
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
kwriteconfig5 --file ~/.config/mimeapps.list --group 'Default Applications' --key 'application/x-wine-extension-fa' "org.kde.kwrite.desktop;"
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

## Notification
### System Settings > Notification > Configure > Other Applications > uncheck "Show popups"
kwriteconfig5 --file ~/.config/plasmanotifyrc --group 'Applications' --group '@other' --key 'ShowPopups' "false"
### Notification > Configure > Network Management > Confirgure Events > uncheck "Show a message in a popup" for "Connection Activated"
echo -e '[Event/ConnectionActivated]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/NoLongerConnected]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/networkmanagement.notifyrc
### Notification > Configure > Discover > Confirgure Events > uncheck "Show a message in a popup" for "Updates Are Available"
echo -e '[Event/Update]\nAction=\nExecute=\nLogfile=\nSound=\nTTS=\n\n[Event/UpdateResart]\nExecute=\nLogfile=\nSound=\nTTS=' > ~/.config/discoverabstractnotifier.notifyrc

## Window Management
### Desktop Effects > Appearance > uncheck "screen edge"
kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key screenedgeEnabled "false"
### Virtual Desktop > uncheck "Navigation wraps around"
kwriteconfig5 --file ~/.config/kwinrc --group Windows --key RollOverDesktops "false"

######################################################################################

# Workspace

## General Behavior
### Clicking files or folders > "Selects them"
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick "false"
### Double-click Interval: 500ms
kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key DoubleClickInterval "500"

## Search
### File Search > check "Enable File Search"
kwriteconfig5 --file ~/.config/baloofilerc --group Basic --key Indexing-Enabled "Settings"
kwriteconfig5 --file ~/.config/baloofilerc --group 'Basic Settings' --key Indexing-Enabled "true"
kwriteconfig5 --file ~/.config/krunnerrc --group PlasmaRunnerManager --key migrated "true"
kwriteconfig5 --file ~/.config/krunnerrc --group Plugins --key baloosearchEnabled "true"
### Plasma Search > Config KRunner... > Position on screen > select "Center"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key FreeFloating "true"
### System Settings > Search > Plasma Search > Config KRunner... > Activation > uncheck "Activate when pressing any key on desktop"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key ActivateWhenTypingOnDesktop "false"
### System Settings > Search > Plasma Search > Config KRunner... > History > uncheck "Retain previous search"
kwriteconfig5 --file ~/.config/krunnerrc --group General --key RetainPriorSearch "false"

######################################################################################

# Security & Privacy

## Screen Locking > Lock screen automatically: 30minutes
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Timeout "30"

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
kwriteconfig5 --file ~/.config/discoverrc --group Software --key UseOfflineUpdates "false"
### Notification frequency > select "Monthly"
kwriteconfig5 --file ~/.config/PlasmaDiscoverUpdates --group Global --key RequiredNotificationInterval '2592000'

## Session
### Desktop Session > On login, launch apps that were open > select "Start with an empty session"
kwriteconfig5 --file ~/.config/ksmserverrc --group General --key loginMode "emptySession"

######################################################################################


#-------------------------------------------------------------------------------------

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/0_sysstg.sh+#bash ./cfg/0_sysstg.sh+g' ~/.setup_cache/setup.sh
