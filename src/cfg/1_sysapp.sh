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

# Dolphin #to update

## install widgets
mkdir -p ~/.local/share/kio/servicemenus/
# Context Menu > Download New Services... > "Open as root" (by loup)
echo -e '[Desktop Entry]\nType=Service\nIcon=system-file-manager\nActions=OpenAsRoot\nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked\nMimeType=inode/directory;inode/directory-locked\n\n[Desktop Action OpenAsRoot]\nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi;\nIcon=system-file-manager\nName=Open as Root\nName[en_US]=Open as Root\nName[zh_CN]=以管理员身份打开文件夹' > ~/.local/share/kio/servicemenus/open_as_root.desktop
chmod +x ~/.local/share/kio/servicemenus/open_as_root.desktop
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key OpenAsRoot --type bool "true"
# Context Menu > Download New Services... > "Combine *.pdf documents" (by Shaddar)
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=application/pdf;\nIcon=application-pdf\nActions=CombinePDF\nX-KDE-Priority=TopLevel\nX-KDE-RequiredNumberOfUrls=2,3,4,5,6,7,8,9,10\nX-KDE-StartupNotify=false\n\n[Desktop Action CombinePDF]\nIcon=application-pdf\nTryExec=gs\nExec=gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=combined.pdf %U\nName=Combine PDF files\nName[en_US]=Combine PDF files\nName[zh_CN]=合并PDF文件' > ~/.local/share/kio/servicemenus/combine_pdf.desktop
chmod +x ~/.local/share/kio/servicemenus/combine_pdf.desktop
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key CombinePDF --type bool "true"
# Context Menu > Download New Services... > "Rotate or flip images" (by alex-l)
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=RotateLeft\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action RotateLeft]\nIcon=object-rotate-left\nExec=convert -rotate 270 %f %f\nName=Rotate Left\nName[en_US]=Rotate Left\nName[zh_CN]=向左旋转' > ~/.local/share/kio/servicemenus/rotate_left.desktop
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;\nIcon=image-png\nActions=RotateRight\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action RotateRight]\nIcon=object-rotate-right\nExec=convert -rotate 90 %f %f\nName=Rotate Right\nName[en_US]=Rotate Right\nName[zh_CN]=向右旋转' > ~/.local/share/kio/servicemenus/rotate_right.desktop
chmod +x ~/.local/share/kio/servicemenus/rotate_left.desktop
chmod +x ~/.local/share/kio/servicemenus/rotate_right.desktop
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key RotateLeft --type bool "true"
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key RotateRight --type bool "true"
# Context Menu > Download New Services... > "Set as Wallpaper"
echo -e '[Desktop Entry]\nType=Service\nServiceTypes=KonqPopupMenu/Plugin\nMimeType=image/jpeg;image/png;image/svg+xml;image/webp;image/avif;\nIcon=preferences-desktop-wallpaper\nActions=SetAsBackground;\nX-KDE-Priority=TopLevel\nX-KDE-StartupNotify=false\n\n[Desktop Action SetAsBackground]\nIcon=viewimage\nExec=$HOME/.config/background/setasbackground.sh %f\nName=Set as Background\nName[en_US]=Set as Background\nName[zh_CN]=设置为桌面背景' > ~/.local/share/kio/servicemenus/setasbackground.desktop
chmod +x ~/.local/share/kio/servicemenus/setasbackground.desktop
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key SetAsBackground --type bool "true"
kwriteconfig6 --file ~/.config/kservicemenurc --group Show --key wallpaperfileitemaction --type bool "false"
cp -rf ./cfg/background/ ~/.config/

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
kwriteconfig6 --file ~/.config/okularrc --group 'MainWindow' --group 'Toolbar mainToolBar' --key 'ToolButtonStyle' --type string "IconOnly"

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

## git ssh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chenh19/git_ssh/main/gitssh.sh)"

# Refresh shell config
source ~/.bashrc

######################################################################################

# desktop shortcuts
cp -f /usr/share/applications/org.kde.dolphin.desktop ~/Desktop/Dolphin.desktop && chmod +x ~/Desktop/Dolphin.desktop
cp -f /usr/share/applications/google-chrome.desktop ~/Desktop/Chrome.desktop && chmod +x ~/Desktop/Chrome.desktop
echo -e "[Desktop Entry]\nEmptyIcon=user-trash\nIcon=user-trash-full\nName=Trash\nType=Link\nURL[\$e]=trash:/" > ~/Desktop/Trash.desktop

#-------------------------------------------------------------------------------------


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/1_sysapp.sh+#bash ./cfg/1_sysapp.sh+g' ~/.setup_cache/setup.sh
