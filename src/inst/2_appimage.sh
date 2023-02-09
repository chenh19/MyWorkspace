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


# download appimages

## Eudic
[ ! -d ~/.setup_cache/eudic/ ] && mkdir ~/.setup_cache/eudic/
wget -q https://www.dropbox.com/s/i4bvaktkxik5v1x/eudic.zip?dl=0 && echo '"EuDic" AppImage package is downloaded.' && sleep 5 #_to_be_updated
unzip -o -q eudic.zip?dl=0 && sleep 1 && rm -f eudic.zip?dl=0 && sleep 5

## Tropy
[ ! -d ~/.setup_cache/tropy/ ] && mkdir ~/.setup_cache/tropy/
wget -q https://github.com/tropy/tropy/releases/download/v1.12.0/tropy-1.12.0-x64.tar.bz2 && echo '"Tropy" tar package is downloaded.' && sleep 5 #_to_be_updated
tar -xjf *.tar.bz2 -C ./tropy/ && sleep 1 && rm -f *tar.bz2
cp -rf ./tropy/resources/icons/hicolor/1024x1024/apps/tropy.png ./tropy/ && sleep 1


# move to /opt folder
sudo cp -rf ./eudic/ ./tropy/ /opt/
sleep 1 && sudo chmod +x /opt/eudic/eudic.AppImage /opt/tropy/tropy


# create desktop icons

## Eudic
echo -e "[Desktop Entry]\nCategories=Office;\nComment=Dictionary\nExec=XDG_CURRENT_DESKTOP=GNOME /opt/eudic/eudic.AppImage\nGenericName=\nIcon=/opt/eudic/eudic.png\nMimeType=\nName=EuDic\nPath=\nStartupNotify=true\nTerminal=false\nTerminalOptions=\nType=Application" > ./eudic.desktop

## Tropy
echo -e "[Desktop Entry]\nCategories=Graphics;\nComment=Image Manager\nExec=/opt/tropy/tropy\nGenericName=\nIcon=/opt/tropy/tropy.png\nMimeType=\nName=Tropy\nPath=\nStartupNotify=true\nTerminal=false\nTerminalOptions=\nType=Application" > ./tropy.desktop

# move to /usr/share/applications folder
sudo cp -rf ./*.desktop /usr/share/applications/ && sleep 5

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

# cleanup
rm -rf ./eudic/ ./tropy/ && rm -f ./*.desktop
sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}AppImages Deployed!${TEXT_RESET} \n" && sleep 1

# mark setup.sh
sed -i 's+bash ./inst/2_appimage.sh+#bash ./inst/2_appimage.sh+g' ~/.setup_cache/setup.sh
