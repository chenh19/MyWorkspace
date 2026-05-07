#!/usr/bin/env bash
# This script intsalls games

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# ask whether to install games
read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}'Would you like to install games? [y/n/c]'${TEXT_RESET})"$'\n' choice
case "$choice" in
  y|Y ) # notify start
        echo -e "\n${TEXT_YELLOW}Installing games...${TEXT_RESET}\n" && sleep 1

        sudo apt update -qq && sudo apt upgrade -y
        sudo apt install kapman kdiamond bovo kigo gcompris-qt stellarium kamoso 2048-qt -y

        # human resource machine
        echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Do you have the password for Human Resource Machine? [y/n/c]'$TEXT_RESET)"$'\n' choice
        case "$choice" in
          y|Y ) unset password
                until [[ "$password" == te*ld && ${#password} == 9 ]] ; do
                    echo ""
                    read -s -p "$(echo -e $TEXT_YELLOW'Please enter the password to unzip the installer: '$TEXT_RESET)"$'\n' password
                done
                [ ! -d ./inst/ ] && mkdir ./inst/
                wget -q https://www.dropbox.com/scl/fi/y86120dperk5rpwji59j4/HumanResourceMachine.zip?rlkey=demi1mciz9qoc175di9sncoy3 -O HumanResourceMachine.zip && sleep 1
                7z x -aoa -p$password HumanResourceMachine.zip -o$HOME/.setup_cache/inst/ && sleep 1
                rm -f HumanResourceMachine.zip
                echo -e "\n${TEXT_YELLOW}You may change the Human Resource Machine installing path as you like.${TEXT_RESET}\n" && sleep 3
                bash ./inst/HumanResourceMachine-Linux-2016-03-23.sh && sleep 1
                [ -f ~/.local/share/applications/tomorrowcorporation_com-HumanResourceMachine_1.desktop ] && sudo mv -f ~/.local/share/applications/tomorrowcorporation_com-HumanResourceMachine_1.desktop /usr/share/applications/
                sudo chmod 644 /usr/share/applications/tomorrowcorporation_com-HumanResourceMachine_1.desktop
                ;;
            * ) ;;
        esac

        # notify end
        echo -e "\n${TEXT_GREEN}Games installed!${TEXT_RESET}\n" && sleep 3;;

  * ) # notify cancellation
        echo -e "\n${TEXT_YELLOW}Games not installed.${TEXT_RESET}\n" && sleep 1;;

esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/3_games.sh+#bash ./inst/3_games.sh+g' ~/.setup_cache/setup.sh
