#!/bin/bash
# This script installs appimages

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Deploying AppImages...${TEXT_RESET} \n" && sleep 1

## Eudic
[ ! -d ./eudic/ ] && mkdir ./eudic/
wget -q https://www.dropbox.com/s/s6r5quimfqzhlfn/eudic.AppImage?dl=0 -O ./eudic/eudic.AppImage && echo '"EuDic" AppImage package is downloaded.' && sleep 5 #_to_be_updated
sudo cp -rf ./eudic/ /opt/ && sleep 1 && sudo chmod +x /opt/eudic/eudic.AppImage
echo -e "[Desktop Entry]\nCategories=Office;\nComment=Dictionary\nExec=XDG_CURRENT_DESKTOP=GNOME /opt/eudic/eudic.AppImage\nGenericName=\nIcon=/opt/icon/eudic.png\nMimeType=\nName=EuDic\nPath=\nStartupNotify=true\nTerminal=false\nTerminalOptions=\nType=Application" > ./eudic.desktop
sudo cp -f ./eudic.desktop /usr/share/applications/ && sleep 5
rm -rf ./eudic/ ./eudic.desktop

## MuseScore
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install MuseScore? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
      y|Y ) # install
            [ ! -d ./musescore/ ] && mkdir ./musescore/
            wget -q https://github.com/musescore/MuseScore/releases/download/v4.0.1/MuseScore-4.0.1.230121751-x86_64.AppImage -O ./musescore/musescore.AppImage && echo '"MuseScore" AppImage package is downloaded.' && sleep 5 #_to_be_updated
            sudo cp -rf ./musescore/ /opt/ && sleep 1 && sudo chmod +x /opt/musescore/musescore.AppImage
            echo -e "[Desktop Entry]\nCategories=AudioVideo;\nComment=Create, play and print sheet music\nExec=/opt/musescore/musescore.AppImage\nGenericName=Music notation\nIcon=/opt/icon/musescore.png\nMimeType=\nName=MuseScore\nPath=\nStartupNotify=true\nTerminal=false\nTerminalOptions=\nType=Application" > ./musescore.desktop
            sudo cp -f ./musescore.desktop /usr/share/applications/ && sleep 5
            rm -rf ./musescore/ ./musescore.desktop
            # notify end
            echo -e " \n${TEXT_GREEN}MuseScore installed!${TEXT_RESET} \n" && sleep 1;;
      * )   # notify cancellation
            echo -e " \n${TEXT_YELLOW}MuseScore not installed.${TEXT_RESET} \n" && sleep 1;;
esac


###>>>sed-i-d-start-1
# manual config
# aske whether to configure appimages manually
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure AppImage apps now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # ask for individual apps

        ###>>>sed-i-d-start-2
        ## eudic
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure EuDic? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please configure and then close EuDic to continue.${TEXT_RESET} \n" && sleep 1
                XDG_CURRENT_DESKTOP=GNOME /opt/eudic/eudic.AppImage
                # notify end
                echo -e " \n${TEXT_GREEN}EuDic configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}EuDic not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        ###>>>sed-i-d-end-2

        # notify end
        echo -e " \n${TEXT_GREEN}AppImage apps Configured!${TEXT_RESET} \n" && sleep 5;;

  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}AppImage apps not configured.${TEXT_RESET} \n" && sleep 5;;

esac
###>>>sed-i-d-end-1


# notify end
echo -e " \n${TEXT_GREEN}AppImages Deployed!${TEXT_RESET} \n" && sleep 1

# mark setup.sh
sed -i 's+bash ./inst/2_appimage.sh+#bash ./inst/2_appimage.sh+g' ~/.setup_cache/setup.sh
