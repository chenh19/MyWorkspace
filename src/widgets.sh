#!/bin/bash
# This script installs KDE widgets

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing widgets...${TEXT_RESET} \n" && sleep 1

# install plasma widgets
#/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1704465 # doesn't work for now
wget -q https://www.dropbox.com/s/6n5g9a8q5etvtx5/adhe.textcommand.zip?dl=0 && sleep 1
unzip -o -q *.zip?dl=0 && sleep 1 && rm *.zip?dl=0
[ ! -d ~/.local/share/plasma/ ] && mkdir ~/.local/share/plasma/
[ ! -d ~/.local/share/plasma/plasmoids/ ] && mkdir ~/.local/share/plasma/plasmoids/
cp -rf ./adhe.textcommand/ ~/.local/share/plasma/plasmoids/
rm -rf ./adhe.textcommand/

# install dolphin widgets
[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/
echo -e "[Desktop Entry] \nType=Service \n#ServiceTypes=application/x-cd-image;model/x.stl-binary \n#MimeType=all/all; \nServiceTypes=KonqPopupMenu/Plugin \nMimeType=application/x-cd-image;model/x.stl-binary \nX-KDE-StartupNotify=false \nX-KDE-Priority=TopLevel \nActions=mountiso; \nInitialPreference=99 \nVersion=1.0 \n \n[Desktop Action mountiso] \nName=Mount the image \nName[ru]=Смонтировать образ \nExec=udisksctl loop-setup -r -f %u \nIcon=media-optical" > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop
echo -e "[Desktop Entry] \nType=Service \nIcon=system-file-manager \nActions=OpenAsRootKDE5 \nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked \n \n[Desktop Action OpenAsRootKDE5] \nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi; \nIcon=system-file-manager \nName=Open as Root \nName[ru]=Открыть папку с правами рут \nName[ua]=Відкрити папку з правами рут \nName[zh_CN]=打开具有根权限的文件夹 \nName[zh_TW]=打開具有根許可權的資料夾 \nName[de]=Öffnen des Ordners mit Root-Berechtigungen \nName[ja]=ルート権限を持つフォルダを開く \nName[ko]=루트 권한이 있는 폴더 열기 \nName[fr]=Ouvrez le dossier avec les privilèges root \nName[el]=Ανοίξτε ως Root \nName[es]=Abrir la carpeta con privilegios de root \nName[tr]=Kök ayrıcalıkları olan klasörü açma \nName[he]=פתח תיקיה עם הרשאות שורש \nName[it]=Aprire la cartella con privilegi radice \nName[ar]=فتح المجلد بامتيازات الجذر \nName[pt_BR]=Abrir pasta com privilégios de root \nName[pt_PT]=Abrir pasta com privilégios de root \nName[sv]=Öppna mapp med root-behörigheter \nName[nb]=Åpne mappen med rotprivilegier" > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop


# config
kbuildsycoca5
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 "root"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key mountiso "true"

# notify end
echo -e " \n${TEXT_GREEN}Widgets installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/widgets.sh+#bash ./src/widgets.sh+g' ~/.setup_cache/setup.sh
