#!/bin/bash
# This script installs flathub and Discover backend

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing Flathub...${TEXT_RESET} \n" && sleep 1
sudo apt-get update && sudo apt-get upgrade -y

# add flathub to discover (KDE app store)
sudo apt-get install flatpak plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install apps
sudo flatpak install -y --noninteractive flathub org.kde.kclock
sudo flatpak install -y --noninteractive flathub org.kde.kweather
sudo flatpak install -y --noninteractive flathub com.github.joseexposito.touche
sudo flatpak install -y --noninteractive flathub com.usebottles.bottles
sudo flatpak install -y --noninteractive flathub me.hyliu.fluentreader

  ## ask whether to install
  ### syncthing
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install SyncThing? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Installing SyncThing...${TEXT_RESET} \n" && sleep 1
              # install
              [ ! -d ~/Sync/ ] && mkdir ~/Sync/ && kwriteconfig5 --file ~/Sync/.directory --group "Desktop Entry" --key Icon "folder-cloud"
              sudo flatpak install -y --noninteractive flathub com.github.zocker_160.SyncThingy
              # notify end
              echo -e " \n${TEXT_GREEN}SyncThing installed.${TEXT_RESET} \n" && sleep 1;;
          * ) # notify cancellation
              echo -e " \n${TEXT_YELLOW}SyncThing not installed.${TEXT_RESET} \n" && sleep 1;;
  esac

# auto config
[ ! -d ~/.local/share/applications ] && mkdir ~/.local/share/applications
##Clock
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
##Weather
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
##Fluent Reader
[ ! -f ~/.local/share/applications/me.hyliu.fluentreader.desktop ] && touch ~/.local/share/applications/me.hyliu.fluentreader.desktop
desktop-file-edit \
    --set-name 'Fluent Reader' --set-key 'Name[en_US]' --set-value 'Fluent Reader' --set-key 'Name[zh_CN]' --set-value 'RSS阅读器' \
    --set-generic-name 'Modern RSS reader' --set-key 'GenericName[en_US]' --set-value 'Modern RSS reader' --set-key 'GenericName[zh_CN]' --set-value '浏览订阅信息' \
    --set-comment 'Read RSS Feeds' --set-key 'Comment[en_US]' --set-value 'Read RSS Feeds' --set-key 'Comment[zh_CN]' --set-value '阅读RSS订阅' \
    --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=start-fluent-reader --file-forwarding me.hyliu.fluentreader @@u %U @@' \
    --set-icon 'me.hyliu.fluentreader' \
    --set-key 'NoDisplay' --set-value 'false' \
    --set-key 'Path' --set-value '' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'X-Flatpak' --set-value 'me.hyliu.fluentreader' \
    --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
    --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
    --set-key 'X-KDE-Username' --set-value '' \
    --remove-key 'Categories' --add-category 'Science;' \
~/.local/share/applications/me.hyliu.fluentreader.desktop
##Touché
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
## touchegg
[ ! -d ~/.config/touchegg/ ] && mkdir ~/.config/touchegg/
cp -f ./cfg/touchegg/* ~/.config/touchegg/
##Bottles
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


###>>>sed-i-d-start-1
# manual config
# aske whether to configure apt installed apps manually
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure flatpak apps manually now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # ask for individual apps
        
        ###>>>sed-i-d-start-2
        ## syncthing
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Syncthing? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please config and then quit Syncthing (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                flatpak run com.github.zocker_160.SyncThingy
                # notify end
                echo -e " \n${TEXT_GREEN}Syncthing configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Syncthing not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        ###>>>sed-i-d-end-2
        
        # notify end
        echo -e " \n${TEXT_GREEN}Apt installed apps Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Apt installed apps not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac
###>>>sed-i-d-end-1


# cleanup
sudo snap remove firefox
[ -d ~/snap/ ] && sudo rm -rf ~/snap/
[ -d ~/Downloads/firefox.tmp/ ] && sudo rm -rf ~/Downloads/firefox.tmp/
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Flathub installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./inst/1_flathub.sh+#bash ./inst/1_flathub.sh+g' ~/.setup_cache/setup.sh
