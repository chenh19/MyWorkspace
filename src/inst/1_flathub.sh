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
sudo apt-get update -qq && sudo apt-get upgrade -y

# add flathub to discover (KDE app store)
sudo apt-get install flatpak plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## clock
sudo flatpak install -y --noninteractive flathub org.kde.kclock
[ -f /var/lib/flatpak/app/org.kde.kclock/current/active/export/share/applications/org.kde.kclock.desktop ] && sudo mv -f /var/lib/flatpak/app/org.kde.kclock/current/active/export/share/applications/org.kde.kclock.desktop /usr/share/applications/
[ ! -f /usr/share/applications/org.kde.kclock.desktop ] && sudo touch /usr/share/applications/org.kde.kclock.desktop
sudo desktop-file-edit \
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
/usr/share/applications/org.kde.kclock.desktop

## weather
sudo flatpak install -y --noninteractive flathub org.kde.kweather
[ -f /var/lib/flatpak/app/org.kde.kweather/current/active/export/share/applications/org.kde.kweather.desktop ] && sudo mv -f /var/lib/flatpak/app/org.kde.kweather/current/active/export/share/applications/org.kde.kweather.desktop /usr/share/applications/
[ ! -f /usr/share/applications/org.kde.kweather.desktop ] && sudo touch /usr/share/applications/org.kde.kweather.desktop
sudo desktop-file-edit \
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
/usr/share/applications/org.kde.kweather.desktop

## wechat universal
sudo flatpak install -y --noninteractive flathub com.tencent.WeChat
[ -f /var/lib/flatpak/app/com.tencent.WeChat/current/active/export/share/applications/com.tencent.WeChat.desktop ] && sudo mv -f /var/lib/flatpak/app/com.tencent.WeChat/current/active/export/share/applications/com.tencent.WeChat.desktop /usr/share/applications/
[ ! -f /usr/share/applications/com.tencent.WeChat.desktop ] && sudo touch /usr/share/applications/com.tencent.WeChat.desktop
sudo desktop-file-edit \
    --set-name 'WeChat' --set-key 'Name[en_US]' --set-value 'WeChat' --set-key 'Name[zh_CN]' --set-value '微信' \
    --set-generic-name 'Instant Messaging' --set-key 'GenericName[en_US]' --set-value 'Instant Messaging' --set-key 'GenericName[zh_CN]' --set-value '个人即时通讯' \
    --set-comment 'WeChat Universal' --set-key 'Comment[en_US]' --set-value 'WeChat Universal' --set-key 'Comment[zh_CN]' --set-value '微信统信版' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=wechat --file-forwarding com.tencent.WeChat @@u %U @@' \
    --set-icon 'com.tencent.WeChat' \
    --set-key 'NoDisplay' --set-value 'false' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'StartupWMClass' --set-value 'WeChat' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'com.tencent.WeChat' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Network;' \
/usr/share/applications/com.tencent.WeChat.desktop
#sudo flatpak override com.tencent.WeChat --filesystem=host
#sudo flatpak override com.tencent.WeChat --filesystem=home

# cleanup
[ -d ~/snap/firefox/ ] && sudo rm -rf ~/snap/firefox/
[ -d ~/Downloads/firefox.tmp/ ] && sudo rm -rf ~/Downloads/firefox.tmp/
sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Flatpak applications installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_flathub.sh+#bash ./inst/1_flathub.sh+g' ~/.setup_cache/setup.sh
