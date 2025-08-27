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

## install widgets (take effect after rebooting)
/usr/lib/x86_64-linux-gnu/libexec/kf6/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/2132554 #Toggle Overview
line="$(grep -wn "wallpaperplugin=org.kde.image" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | cut -d: -f1)"
line=$((line+2))
sed -i "$line,500d" ~/.config/plasma-org.kde.plasma.desktop-appletsrc
cat ~/.setup_cache/cfg/taskbar/plasma-org.kde.plasma.desktop-appletsrc >> ~/.config/plasma-org.kde.plasma.desktop-appletsrc
unset line

# Clipboard > uncheck "Save clipboard contents on exit"
kwriteconfig5 --file ~/.config/klipperrc --group 'General' --key 'KeepClipboardContents' "false"

# kde browser integration reminder hide
kwriteconfig5 --file ~/.config/kded5rc --group 'Module-browserintegrationreminder' --key 'autoload' "false"

# Opacity > Translucent; no Floating
kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key panelOpacity "1"
kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key floating "0"

######################################################################################

# Dolphin

## install widgets
# Context Menu > Download New Services... > "Open as root" (by loup), "Mount ISO" (by loup), "Rotate or flip images" (by alex-l), and "Combine *.pdf documents" (by Shaddar)
[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/
echo -e '[Desktop Entry]\nType=Service\n#ServiceTypes=application/x-cd-image;model/x.stl-binary\n#MimeType=all/all;\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/x-cd-image;model/x.stl-binary\nX-KDE-StartupNotify=false\nX-KDE-Priority=TopLevel\nActions=mountiso;\nInitialPreference=99\nVersion=1.0\n\n[Desktop Action mountiso]\nName=Mount the image\nName[ru]=Смонтировать образ\nExec=udisksctl loop-setup -r -f %u\nIcon=media-optical' > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop
echo -e '[Desktop Entry]\nType=Service\nIcon=system-file-manager\nActions=OpenAsRootKDE5\nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked\n\n[Desktop Action OpenAsRootKDE5]\nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi;\nIcon=system-file-manager\nName=Open as Root\nName[ru]=Открыть папку с правами рут\nName[ua]=Відкрити папку з правами рут\nName[zh_CN]=打开具有根权限的文件夹\nName[zh_TW]=打開具有根許可權的資料夾\nName[de]=Öffnen des Ordners mit Root-Berechtigungen\nName[ja]=ルート権限を持つフォルダを開く\nName[ko]=루트 권한이 있는 폴더 열기\nName[fr]=Ouvrez le dossier avec les privilèges root\nName[el]=Ανοίξτε ως Root\nName[es]=Abrir la carpeta con privilegios de root\nName[tr]=Kök ayrıcalıkları olan klasörü açma\nName[he]=פתח תיקיה עם הרשאות שורש\nName[it]=Aprire la cartella con privilegi radice\nName[ar]=فتح المجلد بامتيازات الجذر\nName[pt_BR]=Abrir pasta com privilégios de root\nName[pt_PT]=Abrir pasta com privilégios de root\nName[sv]=Öppna mapp med root-behörigheter\nName[nb]=Åpne mappen med rotprivilegier' > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=left\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action left]\nName=Rotate left\nIcon=object-rotate-left\nExec=convert -rotate 270 %f %f' > ~/.local/share/kservices5/ServiceMenus/rotate_left.desktop
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=right\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action right]\nName=Rotate right\nIcon=object-rotate-right\nExec=convert -rotate 90 %f %f' > ~/.local/share/kservices5/ServiceMenus/rotate_right.desktop
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/pdf;\nIcon=application-pdf\nActions=combine\nX-KDE-Priority=TopLevel\nX-KDE-RequiredNumberOfUrls=2,3,4,5,6,7,8,9,10\nX-KDE-StartupNotify=false\n\n[Desktop Action combine]\nName=Combine PDF files\nIcon=application-pdf\nTryExec=gs\nExec=gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=combined.pdf %U' > ~/.local/share/kservices5/ServiceMenus/combine_pdf.desktop

## config Dolphin widgets
kbuildsycoca5
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 "root"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key mountiso "true"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key left "true"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key right "true"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key combine "true"

## Configure Dolphin
# General > uncheck "show selection marker"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key OpenExternallyCalledFolderInNewTab "false"
# Startup > Show on startup > check "/home/user" and uncheck "Open new folders in tabs"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key RememberOpenedTabs "false"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key ShowSelectionToggle "false"
# Details view mode > Zoom > set preview size to "22"
kwriteconfig5 --file ~/.config/dolphinrc --group DetailsMode --key PreviewSize "22"#
# Config > Config Toolbars... > remove "Split", add "Create Folder" and rename to "New"
[ ! -d ~/.local/share/kxmlgui5/ ] && mkdir ~/.local/share/kxmlgui5/
[ ! -d ~/.local/share/kxmlgui5/dolphin/ ] && mkdir ~/.local/share/kxmlgui5/dolphin/
cp -f ./cfg/dolphin/dolphinui.rc ~/.local/share/kxmlgui5/dolphin/

# Config > Interface > Status & Location bars > Status Bar > check "Full width" and "Show zoom slider"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key ShowStatusBar "FullWidth"
kwriteconfig5 --file ~/.config/dolphinrc --group General --key ShowZoomSlider "true"

# Dolphin window size
[ ! -d ~/.local/share/dolphin/ ] && mkdir ~/.local/share/dolphin/
## layout
kwriteconfig5 --file ~/.local/share/dolphin/dolphinstaterc --group State --key 'State' "AAAA/wAAAAD9AAAAAwAAAAAAAAC3AAACKvwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAA/////wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAuAAACKgAAAF0BAAADAAAAAQAAAAAAAAAA/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAAD/////AAAACgEAAAMAAAADAAAAAAAAAAD8AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAA/////wAAAAoBAAADAAACzAAAAioAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA="
## restore
kwriteconfig5 --file ~/.local/share/dolphin/dolphinstaterc --group State --key 'RestorePositionForNextInstance' "false"
## Dolphin window Width 900
### 3840x2400
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3840x2400 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2560x1600 screen: Width' "900" #1.5
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1920x1200 screen: Width' "900" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1536x960 screen: Width' "900" #2.5
### 3840x2160
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3840x2160 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2560x1440 screen: Width' "900" #1.5
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1920x1080 screen: Width' "900" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1536x864 screen: Width' "900" #2.5
### 3000x2000
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3000x2000 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1500x1000 screen: Width' "900" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1200x800 screen: Width' "900" #2.5
### 3200x1800
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3200x1800 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1600x900 screen: Width' "900" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1280x720 screen: Width' "900" #2.5
### 2880x1800
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2880x1800 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1440x900 screen: Width' "900" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1152x720 screen: Width' "900" #2.5
### 2160x1350
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2160x1350 screen: Width' "900" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1440x900 screen: Width' "900" #1.5
### 2 screens
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2 screens: Width' "900"

## Dolphin window Height 600
### 3840x2400
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3840x2400 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2560x1600 screen: Height' "600" #1.5
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1920x1200 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1536x960 screen: Height' "600" #2.5
### 3840x2160
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3840x2160 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2560x1440 screen: Height' "600" #1.5
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1920x1080 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1536x864 screen: Height' "600" #2.5
### 3000x2000
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3000x2000 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1500x1000 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1200x800 screen: Height' "600" #2.5
### 3200x1800
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '3200x1800 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1600x900 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1280x720 screen: Height' "600" #2.5
### 2880x1800
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2880x1800 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1440x900 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1152x720 screen: Height' "600" #2.5
### 2160x1350
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2160x1350 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '1440x900 screen: Height' "600" #1.5
### 2 screens
kwriteconfig5 --file ~/.local/state/dolphinstaterc --group State --key '2 screens: Height' "600"

######################################################################################

# Konsole

## Konsole window Width 96 charc
### 3840x2400
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3840x2400 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2560x1600 screen: Width' "803" #1.5
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1920x1200 screen: Width' "803" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1536x960 screen: Width' "803" #2.5
### 3840x2160
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3840x2160 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2560x1440 screen: Width' "803" #1.5
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1920x1080 screen: Width' "803" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1536x864 screen: Width' "803" #2.5
### 3000x2000
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3000x2000 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1500x1000 screen: Width' "803" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1200x800 screen: Width' "803" #2.5
### 3200x1800
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3200x1800 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1600x900 screen: Width' "803" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1280x720 screen: Width' "803" #2.5
### 2880x1800
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2880x1800 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1440x900 screen: Width' "803" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1152x720 screen: Width' "803" #2.5
### 2160x1350
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2160x1350 screen: Width' "803" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1440x900 screen: Width' "803" #1.5
### 2 screens
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2 screens: Width' "803"

## Konsole window height 32 charc (previously height=625)
### 3840x2400
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3840x2400 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2560x1600 screen: Height' "536" #1.5
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1920x1200 screen: Height' "536" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1536x960 screen: Height' "536" #2.5
### 3840x2160
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3840x2160 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2560x1440 screen: Height' "536" #1.5
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1920x1080 screen: Height' "536" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1536x864 screen: Height' "536" #2.5
### 3000x2000
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3000x2000 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1500x1000 screen: Height' "536" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1200x800 screen: Height' "536" #2.5
### 3200x1800
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '3200x1800 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1600x900 screen: Height' "536" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1280x720 screen: Height' "536" #2.5
### 2880x1800
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2880x1800 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1440x900 screen: Height' "536" #2.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1152x720 screen: Height' "536" #2.5
### 2160x1350
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2160x1350 screen: Height' "536" #1.0
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '1440x900 screen: Height' "536" #1.5
### 2 screens
kwriteconfig5 --file ~/.local/state/konsolestaterc --group MainWindow --key '2 screens: Height' "536"

######################################################################################

# kwrite

## hide minimap
# Setting > Configure KWrite > Appearance > Borders > uncheck "Show minimap"
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor View' --key 'Scroll Bar MiniMap' "false"
# Setting > Configure KWrite > Open/Save > Fallback encoding > select "Chinese Simplified (GB18030)"
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor Editor' --key 'Fallback Encoding' "GB18030"
# Setting > Configure KWrite > Session > uncheck "Show welcome view for new windows"
kwriteconfig5 --file ~/.config/kwriterc --group 'General' --key 'Show welcome view for new window' "false"

######################################################################################

## System Monitor
# Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,processes.page,history.page,applications.page"

# System monitor: Overview: move CPU to the left
#echo -e "\n${TEXT_YELLOW}Please ${TEXT_GREEN}rearrange [CPU/Memory/Disk] order${TEXT_YELLOW} and then close System Monitor to continue.${TEXT_RESET}\n" && sleep 1 && plasma-systemmonitor
[ ! -d ~/.local/share/plasma-systemmonitor/ ] && mkdir ~/.local/share/plasma-systemmonitor/
kwriteconfig5 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --key actionsFace ""
kwriteconfig5 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --key loadType ""
kwriteconfig5 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-0 --group section-0 --key face "Face-94410266684256"
kwriteconfig5 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-1 --group section-0 --key face "Face-94410222150464"
kwriteconfig5 --file ~/.local/share/plasma-systemmonitor/overview.page --group page --group row-0 --group column-2 --group section-0 --key face "Face-94410261307168"

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

# Ark

## Ark window Width 817
### 3840x2400
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3840x2400 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2560x1600 screen: Width' "817" #1.5
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1920x1200 screen: Width' "817" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1536x960 screen: Width' "817" #2.5
### 3840x2160
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3840x2160 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2560x1440 screen: Width' "817" #1.5
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1920x1080 screen: Width' "817" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1536x864 screen: Width' "817" #2.5
### 3000x2000
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3000x2000 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1500x1000 screen: Width' "817" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1200x800 screen: Width' "817" #2.5
### 3200x1800
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3200x1800 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1600x900 screen: Width' "817" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1280x720 screen: Width' "817" #2.5
### 2880x1800
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2880x1800 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1440x900 screen: Width' "817" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1152x720 screen: Width' "817" #2.5
### 2160x1350
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2160x1350 screen: Width' "817" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1440x900 screen: Width' "817" #1.5

## Ark window Height 600
### 3840x2400
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3840x2400 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2560x1600 screen: Height' "600" #1.5
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1920x1200 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1536x960 screen: Height' "600" #2.5
### 3840x2160
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3840x2160 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2560x1440 screen: Height' "600" #1.5
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1920x1080 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1536x864 screen: Height' "600" #2.5
### 3000x2000
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3000x2000 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1500x1000 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1200x800 screen: Height' "600" #2.5
### 3200x1800
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '3200x1800 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1600x900 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1280x720 screen: Height' "600" #2.5
### 2880x1800
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2880x1800 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1440x900 screen: Height' "600" #2.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1152x720 screen: Height' "600" #2.5
### 2160x1350
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '2160x1350 screen: Height' "600" #1.0
kwriteconfig5 --file ~/.config/arkrc --group 'MainWindow' --key '1440x900 screen: Height' "600" #1.5

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

# Refresh shell config
source ~/.bashrc

######################################################################################

# git ssh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/git_ssh/main/gitssh.sh)"

#-------------------------------------------------------------------------------------


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/1_sysapp.sh+#bash ./cfg/1_sysapp.sh+g' ~/.setup_cache/setup.sh
