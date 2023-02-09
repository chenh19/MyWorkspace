#!/bin/bash
# This script intsall programming games

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install games
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install programming games? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing programming games...${TEXT_RESET} \n" && sleep 1
        
        # 2048
        sudo snap install qt-2048-snap
        [ ! -f ~/.local/share/applications/qt-2048-snap_qt-2048-snap.desktop ] && touch ~/.local/share/applications/qt-2048-snap_qt-2048-snap.desktop
        desktop-file-edit \
            --set-name '2048' --set-key 'Name[en_US]' --set-value '2048' --set-key 'Name[zh_CN]' --set-value '2048' \
            --set-generic-name 'Puzzle Game' --set-key 'GenericName[en_US]' --set-value 'Puzzle Game' --set-key 'GenericName[zh_CN]' --set-value '2048小游戏' \
            --set-comment 'Single player 2d puzzle game' --set-key 'Comment[en_US]' --set-value 'Single player 2d puzzle game' --set-key 'Comment[zh_CN]' --set-value '2048智力拼图小游戏' \
            --set-key 'Exec' --set-value 'env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/qt-2048-snap_qt-2048-snap.desktop /snap/bin/qt-2048-snap' \
            --set-icon '/snap/qt-2048-snap/11/meta/gui/icon.png' \
            --set-key 'NoDisplay' --set-value 'false' \
            --set-key 'Path' --set-value '' \
            --set-key 'StartupNotify' --set-value 'true' \
            --set-key 'Terminal' --set-value 'false' \
            --set-key 'TerminalOptions' --set-value '' \
            --set-key 'Type' --set-value 'Application' \
            --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
            --set-key 'X-KDE-Username' --set-value '' \
            --set-key 'X-X-SnapInstanceName' --set-value 'qt-2048-snap' \
            --set-key 'Keywords' --set-value 'Puzzle;2048;game;board' \
            --set-key 'Version' --set-value '1.0' \
            --remove-key 'Categories' --add-category 'Game;' \
        ~/.local/share/applications/qt-2048-snap_qt-2048-snap.desktop
        
        # human resource machine
        wget -q https://www.dropbox.com/s/4f804e3873e0wq7/HumanResourceMachine.zip?dl=0 && echo '"Human Resource Machine" installing package is downloaded.' && sleep 5
        unzip -o -q HumanResourceMachine.zip?dl=0 && sleep 1 && rm -f HumanResourceMachine.zip?dl=0 && echo "" && sleep 1
        mv -f ./HumanResourceMachine-Linux-2016-03-23.sh ./inst/ && sleep 1
        echo -e "${TEXT_YELLOW}You may change the Human Resource Machine installing path as you like.${TEXT_RESET} \n"
        sudo bash ./inst/HumanResourceMachine-Linux-2016-03-23.sh && sleep 5
        rm -f ./inst/HumanResourceMachine-Linux-2016-03-23.sh

        # notify end
        echo -e " \n${TEXT_GREEN}Programming games installed!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Programming games not installed.${TEXT_RESET} \n" && sleep 5;;
esac


# mark setup.sh
sed -i 's+bash ./inst/6_game.sh+#bash ./inst/6_game.sh+g' ~/.setup_cache/setup.sh
