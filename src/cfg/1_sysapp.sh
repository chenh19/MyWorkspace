#!/usr/bin/env bash
# This script configures KDE plasma system apps and widgets

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


#-------------------------------------------------------------------------------------

# notify start
if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt update -qq && sudo apt install wget -y && sleep 1 ; fi

######################################################################################

# Firewall

## System Settings > Firewall > check "Enabled"
sudo ufw enable

######################################################################################

# Widgets

## Clipboard > uncheck "Save clipboard contents on exit"
kwriteconfig6 --file ~/.config/klipperrc --group 'General' --key 'KeepClipboardContents' --type bool "false"

## kde browser integration reminder hide
kwriteconfig6 --file ~/.config/kded5rc --group 'Module-browserintegrationreminder' --key 'autoload' --type bool "false"

######################################################################################

# Dolphin

## install widgets  # to update
# Context Menu > Download New Services... > "Open as root" (by loup), "Mount ISO" (by loup), "Rotate or flip images" (by alex-l), and "Combine *.pdf documents" (by Shaddar)
#[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
#[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/
#echo -e '[Desktop Entry]\nType=Service\n#ServiceTypes=application/x-cd-image;model/x.stl-binary\n#MimeType=all/all;\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/x-cd-image;model/x.stl-binary\nX-KDE-StartupNotify=false\nX-KDE-Priority=TopLevel\nActions=mountiso;\nInitialPreference=99\nVersion=1.0\n\n[Desktop Action mountiso]\nName=Mount the image\nName[ru]=Смонтировать образ\nExec=udisksctl loop-setup -r -f %u\nIcon=media-optical' > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop
#echo -e '[Desktop Entry]\nType=Service\nIcon=system-file-manager\nActions=OpenAsRootKDE5\nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked\n\n[Desktop Action OpenAsRootKDE5]\nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi;\nIcon=system-file-manager\nName=Open as Root\nName[ru]=Открыть папку с правами рут\nName[ua]=Відкрити папку з правами рут\nName[zh_CN]=打开具有根权限的文件夹\nName[zh_TW]=打開具有根許可權的資料夾\nName[de]=Öffnen des Ordners mit Root-Berechtigungen\nName[ja]=ルート権限を持つフォルダを開く\nName[ko]=루트 권한이 있는 폴더 열기\nName[fr]=Ouvrez le dossier avec les privilèges root\nName[el]=Ανοίξτε ως Root\nName[es]=Abrir la carpeta con privilegios de root\nName[tr]=Kök ayrıcalıkları olan klasörü açma\nName[he]=פתח תיקיה עם הרשאות שורש\nName[it]=Aprire la cartella con privilegi radice\nName[ar]=فتح المجلد بامتيازات الجذر\nName[pt_BR]=Abrir pasta com privilégios de root\nName[pt_PT]=Abrir pasta com privilégios de root\nName[sv]=Öppna mapp med root-behörigheter\nName[nb]=Åpne mappen med rotprivilegier' > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop
#echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=left\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action left]\nName=Rotate left\nIcon=object-rotate-left\nExec=convert -rotate 270 %f %f' > ~/.local/share/kservices5/ServiceMenus/rotate_left.desktop
#echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=right\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action right]\nName=Rotate right\nIcon=object-rotate-right\nExec=convert -rotate 90 %f %f' > ~/.local/share/kservices5/ServiceMenus/rotate_right.desktop
#echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/pdf;\nIcon=application-pdf\nActions=combine\nX-KDE-Priority=TopLevel\nX-KDE-RequiredNumberOfUrls=2,3,4,5,6,7,8,9,10\nX-KDE-StartupNotify=false\n\n[Desktop Action combine]\nName=Combine PDF files\nIcon=application-pdf\nTryExec=gs\nExec=gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=combined.pdf %U' > ~/.local/share/kservices5/ServiceMenus/combine_pdf.desktop

## config Dolphin widgets  # to update
#kbuildsycoca5
#kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 --type string "root"
#kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key mountiso --type bool "true"
#kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key left --type bool "true"
#kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key right --type bool "true"
#kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key combine --type bool "true"

## Configure Dolphin
# General > uncheck "show selection marker"
kwriteconfig6 --file ~/.config/dolphinrc --group General --key OpenExternallyCalledFolderInNewTab --type bool "false"
# Startup > Show on startup > check "/home/user" and uncheck "Open new folders in tabs"
kwriteconfig6 --file ~/.config/dolphinrc --group General --key RememberOpenedTabs --type bool "false"
kwriteconfig6 --file ~/.config/dolphinrc --group General --key ShowSelectionToggle --type bool "false"
# Config > Interface > Status & Location bars > Status Bar > check "Full width" and "Show zoom slider"
kwriteconfig6 --file ~/.config/dolphinrc --group General --key ShowStatusBar --type string "FullWidth"
kwriteconfig6 --file ~/.config/dolphinrc --group General --key ShowZoomSlider --type bool "true"
# Details view mode > Zoom > set preview size to "22"
kwriteconfig6 --file ~/.config/dolphinrc --group DetailsMode --key PreviewSize --type string "22"
# Config > Config Toolbars... > remove "Split", add "Create Folder" and rename to "New"
[ ! -d ~/.local/share/kxmlgui5/ ] && mkdir ~/.local/share/kxmlgui5/
[ ! -d ~/.local/share/kxmlgui5/dolphin/ ] && mkdir ~/.local/share/kxmlgui5/dolphin/
cp -f ./cfg/dolphin/dolphinui.rc ~/.local/share/kxmlgui5/dolphin/

######################################################################################

# Kwrite
## hide minimap
# Setting > Configure KWrite > Appearance > Borders > uncheck "Show minimap"
kwriteconfig6 --file ~/.config/kwriterc --group 'KTextEditor View' --key 'Scroll Bar MiniMap' --type bool "false"
# Setting > Configure KWrite > Open/Save > Fallback encoding > select "Chinese Simplified (GB18030)"
kwriteconfig6 --file ~/.config/kwriterc --group 'KTextEditor Editor' --key 'Fallback Encoding' --type string "GB18030"
# Setting > Configure KWrite > Session > uncheck "Show welcome view for new windows"
kwriteconfig6 --file ~/.config/kwriterc --group 'General' --key 'Show welcome view for new window' --type bool "false"

######################################################################################

# System Monitor
# Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig6 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' --type string "applications.page"
kwriteconfig6 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' --type string "overview.page,processes.page,history.page,applications.page"

# System monitor: Overview: move CPU to the left
[ ! -d ~/.local/share/plasma-systemmonitor/ ] && mkdir ~/.local/share/plasma-systemmonitor/
kwriteconfig6 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --key actionsFace --type string ""
kwriteconfig6 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --key loadType --type string ""
kwriteconfig6 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-0 --group section-0 --key face --type string "Face-94410266684256"
kwriteconfig6 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-1 --group section-0 --key face --type string "Face-94410222150464"
kwriteconfig6 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-2 --group section-0 --key face --type string "Face-94410261307168"

######################################################################################

# spectacle
## Quit after manual Save or Copy
kwriteconfig6 --file ~/.config/spectaclerc --group GuiConfig --key 'quitAfterSaveCopyExport' --type bool "true"
## Default Save Location
#[ ! -d ~/Pictures/Screenshots/ ] && mkdir ~/Pictures/Screenshots/
#kwriteconfig6 --file ~/.config/spectaclerc --group Save --key defaultSaveLocation --type string file:///home/$USER/Pictures/Screenshots/

######################################################################################

# okular
[ -f ~/.config/okularpartrc ] && rm -f ~/.config/okularpartrc
[ -f ~/.config/okularrc ] && rm -f ~/.config/okularrc
touch ~/.config/okularpartrc ~/.config/okularrc

# Settings > Configure Okular > General > check "Open new files in tabs"
kwriteconfig6 --file ~/.config/okularpartrc --group General --key 'ShellOpenFileInTabs' --type bool "true"

# Settings > Configure Okular > Performance > Memory usage > select "Greedy"
kwriteconfig6 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' --type string "Greedy"

# Settings > Configure Okular > Presentation > uncheck "Show progress indicator"
kwriteconfig6 --file ~/.config/okularpartrc --group 'Dlg Presentation' --key 'SlidesShowProgress' --type bool "false"

# Text Select
kwriteconfig6 --file ~/.config/okularpartrc --group 'PageView' --key 'MouseMode' --type string "TextSelect"

# Open and close multiple PDF files, uncheck "Warn me when I attempt to close multiple tabs"
kwriteconfig6 --file ~/.config/okularrc --group 'Notification Messages' --key 'ShowTabWarning' --type bool "false"
kwriteconfig6 --file ~/.config/okularrc --group 'Notification Messages' --key 'presentationInfo' --type bool "false"

# Configure Toolbars
[ ! -d ~/.local/share/kxmlgui5/ ] && mkdir ~/.local/share/kxmlgui5/
[ -d ~/.local/share/kxmlgui5/okular/ ] && rm -rf ~/.local/share/kxmlgui5/okular/
cp -rf ./cfg/okular/ ~/.local/share/kxmlgui5/

######################################################################################

# vlc
cp -rf ./cfg/vlc/ ~/.config/

######################################################################################

# windows fonts
[ ! -f windows-fonts.zip ] && wget -q "https://www.dropbox.com/scl/fi/4zqeirfr8rwjnocnm55yt/windows-fonts.zip?rlkey=bowygskln7z8fx483dy1izer9" -O windows-fonts.zip && echo 'Windows Fonts are downloaded.' && sleep 1
unzip -o -q windows-fonts.zip && sleep 1 && rm -f windows-fonts.zip && sleep 1
sudo cp -rf ./fonts/windows/ /usr/share/fonts/ && sleep 1
rm -rf ./fonts/

######################################################################################

# command alias
echo ""
## poweroff
if ! grep -q "alias reboot='systemctl reboot'" ~/.bashrc ; then echo -e "alias reboot='systemctl reboot'" >> ~/.bashrc ; fi
if ! grep -q "alias poweroff='systemctl poweroff'" ~/.bashrc ; then echo -e "alias poweroff='systemctl poweroff'" >> ~/.bashrc ; fi
if ! grep -q "alias shutdown='systemctl poweroff'" ~/.bashrc ; then echo -e "alias shutdown='systemctl poweroff'" >> ~/.bashrc ; fi

## alt_rm
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/alt_rm/main/install.sh)"

## sysupdate
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/sysupdate/main/install.sh)"

## run update scripts once
bash ~/.update.sh

# Refresh shell config
source ~/.bashrc

######################################################################################

# git ssh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/git_ssh/main/gitssh.sh)"

#-------------------------------------------------------------------------------------


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/1_sysapp.sh+#bash ./cfg/1_sysapp.sh+g' ~/.setup_cache/setup.sh
