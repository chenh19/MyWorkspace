#!/bin/bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# font size
read -p "$(echo -e $TEXT_YELLOW'You may press [Ctrl] and [+]/[-] to adjust the font size. Press [Enter] to continue.'$TEXT_RESET)"$' \n'

# check internet connection
echo -e "${TEXT_YELLOW}Checking internet connection...${TEXT_RESET} \n"
wget -q --spider http://google.com
until [[ $? -eq 0 ]] ; do
    read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'No internet connection! please first connect to internet then press [Enter] to continue.'$TEXT_RESET)"$' \n'
    echo ""
    wget -q --spider http://google.com
done
echo -e "${TEXT_GREEN}Internet is connected!${TEXT_RESET} \n" && sleep 1

# download and organize setup scripts
echo -e "${TEXT_YELLOW}Preparing setup scripts...${TEXT_RESET} \n" && sleep 1
###>>>sed-i-d-start-0
unset start end

## ask for password
unset password
until [[ "$password" == te*ld && ${#password} == 9 ]] ; do
    echo ""
    read -s -p "$(echo -e $TEXT_YELLOW'Please enter the password to unzip the licenses: '$TEXT_RESET)"$' \n' password
done
echo ""

## prepare all scripts
[ ! -f main ] && wget -q https://codeload.github.com/chenh19/MyWorkspace/zip/refs/heads/main && sleep 1
unzip -o -q main && sleep 1 && rm main
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./inst/ ] && mkdir ./inst/
cp -rf ./MyWorkspace-main/src/inst/* ./inst/
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/
cp -rf ./cfg/System/ ~/Pictures/
sudo cp -rf ./cfg/icon/ ./cfg/shortcut/ /opt/
[ ! -d ~/Templates/ ] && mkdir ~/Templates/
kwriteconfig5 --file ~/Templates/.directory --group "Desktop Entry" --key Icon "folder-templates"
cp -rf ./cfg/template/* ~/Templates/
[ ! -d ~/Licenses/ ] && mkdir ~/Licenses/
kwriteconfig5 --file ~/Licenses/.directory --group "Desktop Entry" --key Icon "certificate-server"
7z x ./cfg/license/license.zip -p$password -o./cfg/license/ -y && sleep 1
rm -f ./cfg/license/license.zip
cp -rf ./cfg/license/* ~/Licenses/
wget -q https://www.dropbox.com/s/4f804e3873e0wq7/HumanResourceMachine.zip?dl=0 -O ./HumanResourceMachine.zip && sleep 1
7z x ./HumanResourceMachine.zip -p$password -o./inst/ && sleep 1
rm -f ./HumanResourceMachine.zip
[ ! -d ~/snap/ ] && mkdir ~/snap/
kwriteconfig5 --file ~/snap/.directory --group "Desktop Entry" --key Icon "folder-snap"
rm -rf ./MyWorkspace-main/

# move manual configuration to the end if not using individual scripts
sudo echo ""
scripts="./inst/*.sh"
for script in $scripts
do
    if grep -q "###>>>sed-i-d-start" $script
    then 
        start2="$(grep -wn "###>>>sed-i-d-start-2" $script | head -n 1 | cut -d: -f1)"
        end2="$(grep -wn "###>>>sed-i-d-end-2" $script | tail -n 1 | cut -d: -f1)"
        echo "" >> ./cfg/4_usrapp.sh
        sed -n "$start2,$end2"'p' $script >> ./cfg/4_usrapp.sh
        unset start2 end2
        start1="$(grep -wn "###>>>sed-i-d-start-1" $script | head -n 1 | cut -d: -f1)"
        end1="$(grep -wn "###>>>sed-i-d-end-1" $script | tail -n 1 | cut -d: -f1)"
        sed -i "$start1,$end1"'d' $script
        unset start1 end1
        echo "Manual configuration part of $script is moved to the end of this setup process."
    fi
done
cat ./cfg/4_usrapp_tail.sh >> ./cfg/4_usrapp.sh
rm ./cfg/4_usrapp_tail.sh
if grep -q "sed-i-d-" ./cfg/4_usrapp.sh ; then sed -i '/sed-i-d-/d' ./cfg/4_usrapp.sh ; fi

# avoid re-downloading
echo ""
sed -i 's+Preparing setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
echo -e "${TEXT_GREEN}All setup scripts ready!${TEXT_RESET} \n" && sleep 1
start0="$(grep -wn "###>>>sed-i-d-start-0" ~/.setup_cache/setup.sh | head -n 1 | cut -d: -f1)"
end0="$(grep -wn "###>>>sed-i-d-end-0" ~/.setup_cache/setup.sh | tail -n 1 | cut -d: -f1)"
sed -i "$start0,$end0"'d' ~/.setup_cache/setup.sh
unset start0 end0
###>>>sed-i-d-end-0

# setup
bash ./inst/0_deb.sh
bash ./inst/1_flathub.sh
bash ./inst/2_appimage.sh
bash ./inst/3_ukuu.sh
bash ./inst/4_fcitx5.sh
bash ./inst/5_wechat.sh
bash ./inst/6_game.sh
bash ./inst/7_biodaily.sh
bash ./inst/8_biodevr.sh
bash ./inst/9_biodevpy.sh

# config
bash ./cfg/0_sysmdl.sh
bash ./cfg/1_sysstg.sh
bash ./cfg/2_sysapp.sh
bash ./cfg/3_sysdsp.sh
bash ./cfg/4_usrapp.sh
bash ./cfg/5_reboot.sh
