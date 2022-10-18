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

  ## ask whether to install
  ### syncthing
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install SyncThing? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Installing SyncThing...${TEXT_RESET} \n" && sleep 1
              # install
              sudo flatpak install -y --noninteractive flathub com.github.zocker_160.SyncThingy
              [ ! -d ~/Sync/ ] && mkdir ~/Sync/
              # notify end
              echo -e ' \n"SyncThing installed. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"SyncThing not installed. \n' && sleep 1;;
  esac

# auto config
## touchegg
[ ! -d ~/.config/touchegg/ ] && mkdir ~/.config/touchegg/
cp -f ./cfg/touchegg/* ~/.config/touchegg/


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
