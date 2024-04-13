#!/bin/bash
# This script configures KDE plasma system apps and widgets

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
echo -e "${TEXT_YELLOW}Configuring apps and widgets...${TEXT_RESET} \n" && sleep 1

######################################################################################

## install widgets
# taskbar: remove "Pager"; add "Text Command" (for windows, ❐, ⛶); "Better inline clock" by marianarlt and "Window Title Applet" by Psifidotos (for Mac)
# manual install
#wget -q https://www.dropbox.com/s/6n5g9a8q5etvtx5/adhe.textcommand.zip?dl=0 && echo '"Overview button" installing package is downloaded.' && sleep 1 #_to_be_updated
#unzip -o -q adhe.textcommand.zip?dl=0 && sleep 1 && rm -f adhe.textcommand.zip?dl=0
#[ ! -d ~/.local/share/plasma/ ] && mkdir ~/.local/share/plasma/
#[ ! -d ~/.local/share/plasma/plasmoids/ ] && mkdir ~/.local/share/plasma/plasmoids/
#cp -rf ./adhe.textcommand/ ~/.local/share/plasma/plasmoids/ && sleep 1 && rm -rf ./adhe.textcommand/
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1704465 #Text Command

## config taskbar widgets (take effect after rebooting)
# start menu only show file manager and web browser
# pinned apps only show file manager and web browser
# Change desktop icon settings
# Right click on Desktop > Icon Size > Small; Arrange In > Columns
# Right click on Taskbar, Configure Icon-only Task Manager > Behavior > uncheck "Cycles through tasks"
# Right click on Taskbar > Add Widgets... > add "Text Command" and config with a symbol
# Configure System Tray > Entries > set always hidden and shown apps
# System Tray
# Always shown: "Audio Volume", "Battery and Brightness", "Networks"
# Shown when relevant: "Disk & Devices", "KDE Connect", "Printers"
line="$(grep -wn "wallpaperplugin=org.kde.image" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | cut -d: -f1)"
line=$((line+2))
sed -i "$line,500d" ~/.config/plasma-org.kde.plasma.desktop-appletsrc
cat ~/.setup_cache/cfg/taskbar/plasma-org.kde.plasma.desktop-appletsrc >> ~/.config/plasma-org.kde.plasma.desktop-appletsrc
unset line

# Clipboard > uncheck "Save clipboard contents on exit"
kwriteconfig5 --file ~/.config/klipperrc --group 'General' --key 'KeepClipboardContents' "false"

# kde browser integration reminder hide
kwriteconfig5 --file ~/.config/kded5rc --group 'Module-browserintegrationreminder' --key 'autoload' "false"

######################################################################################

# Dolphin

## install widgets
# Context Menu > Download New Services... > Open as root (by loup) and Mount ISO (by loup)
[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/
echo -e '[Desktop Entry]\nType=Service\n#ServiceTypes=application/x-cd-image;model/x.stl-binary\n#MimeType=all/all;\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/x-cd-image;model/x.stl-binary\nX-KDE-StartupNotify=false\nX-KDE-Priority=TopLevel\nActions=mountiso;\nInitialPreference=99\nVersion=1.0\n\n[Desktop Action mountiso]\nName=Mount the image\nName[ru]=Смонтировать образ\nExec=udisksctl loop-setup -r -f %u\nIcon=media-optical' > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop
echo -e '[Desktop Entry]\nType=Service\nIcon=system-file-manager\nActions=OpenAsRootKDE5\nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked\n\n[Desktop Action OpenAsRootKDE5]\nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi;\nIcon=system-file-manager\nName=Open as Root\nName[ru]=Открыть папку с правами рут\nName[ua]=Відкрити папку з правами рут\nName[zh_CN]=打开具有根权限的文件夹\nName[zh_TW]=打開具有根許可權的資料夾\nName[de]=Öffnen des Ordners mit Root-Berechtigungen\nName[ja]=ルート権限を持つフォルダを開く\nName[ko]=루트 권한이 있는 폴더 열기\nName[fr]=Ouvrez le dossier avec les privilèges root\nName[el]=Ανοίξτε ως Root\nName[es]=Abrir la carpeta con privilegios de root\nName[tr]=Kök ayrıcalıkları olan klasörü açma\nName[he]=פתח תיקיה עם הרשאות שורש\nName[it]=Aprire la cartella con privilegi radice\nName[ar]=فتح المجلد بامتيازات الجذر\nName[pt_BR]=Abrir pasta com privilégios de root\nName[pt_PT]=Abrir pasta com privilégios de root\nName[sv]=Öppna mapp med root-behörigheter\nName[nb]=Åpne mappen med rotprivilegier' > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

## config Dolphin widgets
kbuildsycoca5
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 "root"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key mountiso "true"

## Configure Dolphin
# General > uncheck "show selection marker"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key OpenExternallyCalledFolderInNewTab "false"
# Startup > Show on startup > check "/home/user" and uncheck "Open new folders in tabs"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key RememberOpenedTabs "false"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key ShowSelectionToggle "false"

# Dolphin window size
[ ! -d ~/.local/share/dolphin/ ] && mkdir ~/.local/share/dolphin/
echo -e '[State]\n1500x1000 screen: Height=600\n1500x1000 screen: Width=900\nRestorePositionForNextInstance=false\nState=AAAA/wAAAAD9AAAAAwAAAAAAAAC3AAACKvwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAA/////wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAuAAACKgAAAF0BAAADAAAAAQAAAAAAAAAA/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAAD/////AAAACgEAAAMAAAADAAAAAAAAAAD8AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAA/////wAAAAoBAAADAAACzAAAAioAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA=' > ~/.local/share/dolphin/dolphinstaterc


######################################################################################

# Konsole

## Konsole window height 32
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key '1500x1000 screen: Height' "625"
## Konsole window height 96
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key '1500x1000 screen: Width' "803"

######################################################################################

# kwrite

## hide minimap
# Setting > Configure KWrite > Appearance > Borders > uncheck "Show minimap"
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor View' --key 'Scroll Bar MiniMap' "false"
# Setting > Configure KWrite > Open/Save > Fallback encoding > select "Chinese Simplified (GB18030)"
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor Editor' --key 'Fallback Encoding' "GB18030"
# Setting > Configure KWrite > Session > uncheck "Show welcome view for new windows"
kwriteconfig5 --file ~/.config/kwriterc --group 'General' --key 'Show welcome view for new window' "false"

# kwrite window size
kwriteconfig5 --file ~/.config/kwriterc --group MainWindow --key '1500x1000 screen: Height' "680"
kwriteconfig5 --file ~/.config/kwriterc --group MainWindow --key '1500x1000 screen: Width' "868"

######################################################################################

## System Monitor
# Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,processes.page,history.page,applications.page"

# System monitor: Overview: move CPU to the left
echo -e " \n${TEXT_YELLOW}Please ${TEXT_GREEN}rearrange [CPU/Memory/Disk] order${TEXT_YELLOW} and then close System Monitor to continue.${TEXT_RESET} \n" && sleep 1
plasma-systemmonitor

######################################################################################

# spectacle
## Quit after manual Save or Copy
kwriteconfig5 --file ~/.config/spectaclerc --group GuiConfig --key 'quitAfterSaveCopyExport' "true"
## Default Save Location
[ ! -d ~/Pictures/Screenshots/ ] && mkdir ~/Pictures/Screenshots/
kwriteconfig5 --file ~/.config/spectaclerc --group Save --key defaultSaveLocation file:///home/$USER/Pictures/Screenshots/

######################################################################################

# okular
[ -f ~/.config/okularpartrc ] && rm -f ~/.config/okularpartrc
[ -f ~/.config/okularrc ] && rm -f ~/.config/okularrc
touch ~/.config/okularpartrc ~/.config/okularrc

# Settings > Configure Okular > General > check "Open new files in tabs"
kwriteconfig5 --file ~/.config/okularpartrc --group General --key 'ShellOpenFileInTabs' "true"

# Settings > Configure Okular > Performance > Memory usage > select "Greedy"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' "Greedy"

# Settings > Configure Okular > Presentation > uncheck "Show progress indicator"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Dlg Presentation' --key 'SlidesShowProgress' "false"

# Open and close multiple PDF files, uncheck "Warn me when I attempt to close multiple tabs"
kwriteconfig5 --file ~/.config/okularrc --group 'Notification Messages' --key 'ShowTabWarning' "false"
kwriteconfig5 --file ~/.config/okularrc --group 'Notification Messages' --key 'presentationInfo' "false"

# Configure Toolbars
[ ! -d ~/.local/share/kxmlgui5/ ] && mkdir ~/.local/share/kxmlgui5/
[ -d ~/.local/share/kxmlgui5/okular/ ] && rm -rf ~/.local/share/kxmlgui5/okular/
cp -rf ./cfg/okular/ ~/.local/share/kxmlgui5/

######################################################################################

# vlc
cp -rf ./cfg/vlc/ ~/.config/

######################################################################################

# windows fonts
sudo echo ""
echo -e "${TEXT_YELLOW}Downloading Windows Fonts...${TEXT_RESET} \n" && sleep 1
[ ! -f windows-fonts.zip ] && wget -q https://www.dropbox.com/s/nsfxnl3tt1md56u/windows-fonts.zip?dl=0 -O windows-fonts.zip && echo 'Windows Fonts are downloaded.' && sleep 1
unzip -o -q windows-fonts.zip && sleep 1 && rm -f windows-fonts.zip && sleep 1
sudo cp -rf ./fonts/windows/ /usr/share/fonts/ && sleep 1
rm -rf ./fonts/

######################################################################################

# command alias

## poweroff
if ! grep -q "alias reboot='systemctl reboot'" ~/.bashrc ; then echo -e "alias reboot='systemctl reboot'" >> ~/.bashrc ; fi
if ! grep -q "alias poweroff='systemctl poweroff'" ~/.bashrc ; then echo -e "alias poweroff='systemctl poweroff'" >> ~/.bashrc ; fi
if ! grep -q "alias shutdown='systemctl poweroff'" ~/.bashrc ; then echo -e "alias shutdown='systemctl poweroff'" >> ~/.bashrc ; fi

## alt_rm
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/alt_rm/main/install.sh)

## sysupdate
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/sysupdate/main/install.sh)

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}All apps and widgets configured!${TEXT_RESET} \n" && sleep 5

#-------------------------------------------------------------------------------------


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/1_sysapp.sh+#bash ./cfg/1_sysapp.sh+g' ~/.setup_cache/setup.sh
