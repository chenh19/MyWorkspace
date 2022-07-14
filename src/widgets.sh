#!/bin/bash

# install plasma widgets
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1704465 # text command
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1245902 # better inline clock
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1274218 # Window Title Applet
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1274975 # Window AppMenu Applet (unity like)

# install dolphin widgets
[ ! -d ~/.local/share/kservices5/ ] && mkdir ~/.local/share/kservices5/
[ ! -d ~/.local/share/kservices5/ServiceMenus/ ] && mkdir ~/.local/share/kservices5/ServiceMenus/

echo -e "[Desktop Entry] \nType=Service \n#ServiceTypes=application/x-cd-image;model/x.stl-binary \n#MimeType=all/all; \nServiceTypes=KonqPopupMenu/Plugin \nMimeType=application/x-cd-image;model/x.stl-binary \nX-KDE-StartupNotify=false \nX-KDE-Priority=TopLevel \nActions=mountiso; \nInitialPreference=99 \nVersion=1.0 \n \n[Desktop Action mountiso] \nName=Mount the image
Name[ru]=Смонтировать образ \nExec=udisksctl loop-setup -r -f %u \nIcon=media-optical" > ~/.local/share/kservices5/ServiceMenus/mountiso.desktop

echo -e "[Desktop Entry] \nType=Service \nIcon=system-file-manager \nActions=OpenAsRootKDE5 \nServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory-locked \n \n[Desktop Action OpenAsRootKDE5] \nExec=if [ "$XDG_SESSION_TYPE" = "wayland" ]; then xhost +si:localuser:root && pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin %U && xhost -si:localuser:root ; else pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dolphin %U; fi; \nIcon=system-file-manager \nName=Open as Root \nName[ru]=Открыть папку с правами рут \nName[ua]=Відкрити папку з правами рут \nName[zh_CN]=打开具有根权限的文件夹 \nName[zh_TW]=打開具有根許可權的資料夾 \nName[de]=Öffnen des Ordners mit Root-Berechtigungen \nName[ja]=ルート権限を持つフォルダを開く
Name[ko]=루트 권한이 있는 폴더 열기 \nName[fr]=Ouvrez le dossier avec les privilèges root \nName[el]=Ανοίξτε ως Root \nName[es]=Abrir la carpeta con privilegios de root \nName[tr]=Kök ayrıcalıkları olan klasörü açma \nName[he]=פתח תיקיה עם הרשאות שורש \nName[it]=Aprire la cartella con privilegi radice \nName[ar]=فتح المجلد بامتيازات الجذر \nName[pt_BR]=Abrir pasta com privilégios de root \nName[pt_PT]=Abrir pasta com privilégios de root \nName[sv]=Öppna mapp med root-behörigheter \nName[nb]=Åpne mappen med rotprivilegier" > ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

kbuildsycoca5

kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key OpenAsRootKDE5 "root"
kwriteconfig5 --file ~/.config/kservicemenurc --group Show --key mountiso "true"
