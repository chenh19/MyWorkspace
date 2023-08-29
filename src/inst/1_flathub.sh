#!/bin/bash
# This script installs Flathub, Discover backend for Flathub, and Flatpak applications

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing Flatpak applications...${TEXT_RESET} \n" && sleep 1
[ ! -d ~/.local/share/applications ] && mkdir ~/.local/share/applications
sudo apt-get update && sudo apt-get upgrade -y

# add flathub to discover (KDE app store)
sudo apt-get install flatpak plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## clock
sudo flatpak install -y --noninteractive flathub org.kde.kclock
[ ! -f ~/.local/share/applications/org.kde.kclock.desktop ] && touch ~/.local/share/applications/org.kde.kclock.desktop
desktop-file-edit \
    --set-name 'Clock' --set-key 'Name[en_US]' --set-value 'Clock' --set-key 'Name[zh_CN]' --set-value '时钟' \
    --set-generic-name 'Clock Application' --set-key 'GenericName[en_US]' --set-value 'Clock Application' --set-key 'GenericName[zh_CN]' --set-value '时钟应用' \
    --set-comment 'Set alarms and timers, use a stopwatch, and manage world clocks' --set-key 'Comment[en_US]' --set-value 'Set alarms and timers, use a stopwatch, and manage world clocks' --set-key 'Comment[zh_CN]' --set-value '设置闹钟，计时器，和世界时钟' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=kclock org.kde.kclock' \
    --set-icon 'org.kde.kclock' \
    --set-key 'NoDisplay' --set-value 'false' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'org.kde.kclock' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Utility;' \
~/.local/share/applications/org.kde.kclock.desktop

## weather
sudo flatpak install -y --noninteractive flathub org.kde.kweather
[ ! -f ~/.local/share/applications/org.kde.kweather.desktop ] && touch ~/.local/share/applications/org.kde.kweather.desktop
desktop-file-edit \
    --set-name 'Weather' --set-key 'Name[en_US]' --set-value 'Weather' --set-key 'Name[zh_CN]' --set-value '天气' \
    --set-generic-name 'Weather Forecast' --set-key 'GenericName[en_US]' --set-value 'Weather Forecast' --set-key 'GenericName[zh_CN]' --set-value '天气预报' \
    --set-comment 'View real-time weather forecasts and other information' --set-key 'Comment[en_US]' --set-value 'View real-time weather forecasts and other information' --set-key 'Comment[zh_CN]' --set-value '查看实时天气预报' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=kweather org.kde.kweather' \
    --set-icon 'org.kde.kweather' \
    --set-key 'NoDisplay' --set-value 'false' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'org.kde.kweather' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Utility;' \
~/.local/share/applications/org.kde.kweather.desktop

## touché
sudo flatpak install -y --noninteractive flathub com.github.joseexposito.touche
[ ! -f ~/.local/share/applications/com.github.joseexposito.touche.desktop ] && touch ~/.local/share/applications/com.github.joseexposito.touche.desktop
desktop-file-edit \
    --set-name 'Touché' --set-key 'Name[en_US]' --set-value 'Touché' --set-key 'Name[zh_CN]' --set-value '手势' \
    --set-generic-name 'Touchégg Editor' --set-key 'GenericName[en_US]' --set-value 'Touchégg Editor' --set-key 'GenericName[zh_CN]' --set-value '觸控板手势' \
    --set-comment 'Configure Touchégg multi-touch gestures' --set-key 'Comment[en_US]' --set-value 'Configure Touchégg multi-touch gestures' --set-key 'Comment[zh_CN]' --set-value '设置多指觸控手势' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=com.github.joseexposito.touche com.github.joseexposito.touche' \
    --set-icon 'com.github.joseexposito.touche' \
    --set-key 'NoDisplay' --set-value 'true' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'com.github.joseexposito.touche' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Utility;' \
~/.local/share/applications/com.github.joseexposito.touche.desktop

### bottles
sudo flatpak install -y --noninteractive flathub com.usebottles.bottles
[ ! -f ~/.local/share/applications/com.usebottles.bottles.desktop ] && touch ~/.local/share/applications/com.usebottles.bottles.desktop
desktop-file-edit \
    --set-name 'Bottles' --set-key 'Name[en_US]' --set-value 'Bottles' --set-key 'Name[zh_CN]' --set-value 'Bottles' \
    --set-generic-name 'Wine Config Tool' --set-key 'GenericName[en_US]' --set-value 'Wine Config Tool' --set-key 'GenericName[zh_CN]' --set-value 'Wine编辑工具' \
    --set-comment 'Run Windows Software' --set-key 'Comment[en_US]' --set-value 'Run Windows Software' --set-key 'Comment[zh_CN]' --set-value '运行Windows程序' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=bottles --file-forwarding com.usebottles.bottles @@u %u @@' \
    --set-icon 'com.usebottles.bottles' \
    --set-key 'NoDisplay' --set-value 'false' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'com.usebottles.bottles' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Utility;' \
~/.local/share/applications/com.usebottles.bottles.desktop


# cleanup
sudo snap remove firefox
[ -d ~/snap/firefox/ ] && sudo rm -rf ~/snap/firefox/
[ -d ~/Downloads/firefox.tmp/ ] && sudo rm -rf ~/Downloads/firefox.tmp/
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Flatpak applications installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_flathub.sh+#bash ./inst/1_flathub.sh+g' ~/.setup_cache/setup.sh
