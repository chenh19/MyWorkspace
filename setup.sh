#!/usr/bin/env bash
# This script downloads all scripts for setup

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# font size
read -p "$(echo -e ${TEXT_YELLOW}'You may press [Ctrl] and [+]/[-] to adjust the font size. Press [Enter] to continue.'${TEXT_RESET})"$'\n'

# check internet connection
echo -e "\n${TEXT_YELLOW}Checking internet connection...${TEXT_RESET}"
until curl -s --head  --request GET www.google.com | grep "200 OK" > /dev/null ; do
    read -n1 -s -r -p "$(echo -e '\n'${TEXT_YELLOW}'No internet connection! Please first connect to internet then press [Enter] to continue.'${TEXT_RESET})"$'\n'
done
echo -e "\n${TEXT_GREEN}Internet is connected!${TEXT_RESET}\n" && sleep 1

# setup
echo -e "\n${TEXT_YELLOW}Preparing setup scripts...${TEXT_RESET}\n" && sleep 1
###>>>sed-i-d-start-0
## initialize
unset start0 end0

## install wget
if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt update -qq && sudo apt install wget -y && sleep 1 ; fi

## prepare all scripts
[ ! -f main.zip ] && wget -q "https://github.com/chenh19/MyWorkspace/archive/refs/heads/main.zip" && sleep 1
unzip -o -q main.zip && sleep 1 && rm -f main.zip
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./inst/ ] && mkdir ./inst/
cp -rf ./MyWorkspace-main/src/inst/* ./inst/
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/
cp -rf ./cfg/System/ ~/Pictures/
sudo cp -rf ./cfg/icon/ ./cfg/grub/ /opt/
cp -f ./cfg/power/powerdevilrc ~/.config/
[ ! -d ~/Templates/ ] && mkdir ~/Templates/
kwriteconfig6 --file ~/Templates/.directory --group "Desktop Entry" --key Icon --type string "folder-templates"
[ ! -d ~/Documents/Templates/ ] && mkdir ~/Documents/Templates/
cp -rf ./cfg/template/* ~/Documents/Templates/
[ ! -d ~/snap/ ] && mkdir ~/snap/
kwriteconfig6 --file ~/snap/.directory --group "Desktop Entry" --key Icon --type string "folder-snap"
[ ! -d ~/Developing/ ] && mkdir ~/Developing/
kwriteconfig6 --file ~/Developing/.directory --group "Desktop Entry" --key Icon --type string "folder-script"
[ ! -d ~/OneDrive/ ] && mkdir ~/OneDrive/
kwriteconfig6 --file ~/OneDrive/.directory --group "Desktop Entry" --key Icon --type string "folder-onedrive"
[ ! -d ~/Dropbox/ ] && mkdir ~/Dropbox/
kwriteconfig6 --file ~/Dropbox/.directory --group "Desktop Entry" --key Icon --type string "folder-dropbox"
[ ! -d ~/Backup/ ] && mkdir ~/Backup/
kwriteconfig6 --file ~/Backup/.directory --group "Desktop Entry" --key Icon --type string "folder-tar"
[ ! -d ~/Licenses/ ] && mkdir ~/Licenses/
kwriteconfig6 --file ~/Licenses/.directory --group "Desktop Entry" --key Icon --type string "certificate-server"
rm -rf ./MyWorkspace-main/
echo -e "\n${TEXT_GREEN}All setup scripts ready!${TEXT_RESET}\n"

## hide files and folders
echo -e "Backup\nigv\nPublic\nR\nLicenses\nTemplates\nsnap\nZotero\nSync\nsync\nDeveloping\ndeveloping\nprojects\ndavmail.log\nOneDrive\nDropbox\nVirtualBox VMs\nminiconda3\nbin\nshapemapper\nwinboat" > ~/.hidden
echo -e "Templates\nEnpass\nWeChat Files\nxwechat_files" > ~/Documents/.hidden
echo -e "bin\ndev\nlib\nlibx32\nmnt\nproc\nsbin\nswapfile\nusr\nboot\netc\nlib32\nlost+found\nopt\nroot\nsnap\nsys\nvar\ncdrom\nlib64\npackages.expandrive.gpg\nrun\nsrv\ntmp\ninitrd.img\ninitrd.img.old\nvmlinuz\nvmlinuz.old" | sudo tee /.hidden >/dev/null 2>&1
echo -e "rslsync" | sudo tee /home/.hidden >/dev/null 2>&1

## for resuming
sed -i 's+Preparing setup scripts+Continue setting up+g' ~/.setup_cache/setup.sh
start0="$(grep -wn "###>>>sed-i-d-start-0" ~/.setup_cache/setup.sh | head -n 1 | cut -d: -f1)"
end0="$(grep -wn "###>>>sed-i-d-end-0" ~/.setup_cache/setup.sh | tail -n 1 | cut -d: -f1)"
sed -i "$start0,$end0"'d' ~/.setup_cache/setup.sh
unset start0 end0
###>>>sed-i-d-end-0

# setup
bash ./inst/0_systools.sh
bash ./inst/1_biotools.sh
bash ./inst/2_winboat.sh

# config
bash ./cfg/0_sysstg.sh
bash ./cfg/1_sysapp.sh
bash ./cfg/2_sysdsp.sh
bash ./cfg/3_reboot.sh
