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
echo ""
echo -e "${TEXT_YELLOW}Checking internet connection...${TEXT_RESET} \n"
until curl -s --head  --request GET www.google.com | grep "200 OK" > /dev/null ; do
    read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'No internet connection! Please first connect to internet then press [Enter] to continue.'$TEXT_RESET)"$' \n'
    echo ""
done
echo -e "${TEXT_GREEN}Internet is connected!${TEXT_RESET} \n" && sleep 1

# setup
echo ""
echo -e "${TEXT_YELLOW}Preparing setup scripts...${TEXT_RESET} \n" && sleep 1
###>>>sed-i-d-start-0
## initialize
unset start0 end0

## install wget
if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt-get update -qq && sudo apt-get install wget -y && sleep 1 ; fi

## prepare all scripts
[ ! -f main.zip ] && wget -q "https://github.com/chenh19/MyWorkspace/archive/refs/heads/main.zip" && sleep 1
unzip -o -q main.zip && sleep 1 && rm -f main.zip
cp -rf ./MyWorkspace-main/setup.sh ./
[ ! -d ./inst/ ] && mkdir ./inst/
cp -rf ./MyWorkspace-main/src/inst/* ./inst/
[ ! -d ./cfg/ ] && mkdir ./cfg/
cp -rf ./MyWorkspace-main/src/cfg/* ./cfg/
cp -rf ./cfg/System/ ~/Pictures/
sudo cp -rf ./cfg/icon/ ./cfg/grub/ ./cfg/Thunderbird/ /opt/
[ ! -d ~/Templates/ ] && mkdir ~/Templates/
kwriteconfig5 --file ~/Templates/.directory --group "Desktop Entry" --key Icon "folder-templates"
cp -rf ./cfg/template/* ~/Templates/
[ ! -d ~/snap/ ] && mkdir ~/snap/
kwriteconfig5 --file ~/snap/.directory --group "Desktop Entry" --key Icon "folder-snap"
[ ! -d ~/Developing/ ] && mkdir ~/Developing/
kwriteconfig5 --file ~/Developing/.directory --group "Desktop Entry" --key Icon "folder-script"
[ ! -d ~/OneDrive/ ] && mkdir ~/OneDrive/
kwriteconfig5 --file ~/OneDrive/.directory --group "Desktop Entry" --key Icon "folder-onedrive"
[ ! -d ~/Backup/ ] && mkdir ~/Backup/
kwriteconfig5 --file ~/Backup/.directory --group "Desktop Entry" --key Icon "folder-tar"
rm -rf ./MyWorkspace-main/
echo -e " \n${TEXT_GREEN}All setup scripts ready!${TEXT_RESET} \n"

## prepare all licenses
echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Do you have access to the licenses? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) unset password
	until [[ "$password" == te*ld && ${#password} == 9 ]] ; do
    	  echo ""
    	  read -s -p "$(echo -e $TEXT_YELLOW'Please enter the password to unzip the licenses: '$TEXT_RESET)"$' \n' password
	done
	[ ! -d ~/Licenses/ ] && mkdir ~/Licenses/
	kwriteconfig5 --file ~/Licenses/.directory --group "Desktop Entry" --key Icon "certificate-server"
	[ ! -f ~/Licenses/license.zip ] && wget -q "https://www.dropbox.com/scl/fi/tfjporb5ytmz2drsfsvng/license.zip?rlkey=4j5p50pfi5cdegbm757444lxo" -O ~/Licenses/license.zip && sleep 1
	7z x -aoa -p$password ~/Licenses/license.zip -o$HOME/Licenses/
	rm -f ~/Licenses/license.zip
	echo -e " \n${TEXT_GREEN}Licenses unzipped successfully!${TEXT_RESET} \n" && sleep 1;;
    * ) echo -e " \n${TEXT_YELLOW}Skipping license unzip step.${TEXT_RESET} \n" && sleep 1;;
esac

## Power Management
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DPMSControl --key idleTime "900"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group AC --group SuspendSession --key suspendType --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group DPMSControl --key idleTime "600"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group SuspendSession --key idleTime "900000"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group Battery --group SuspendSession --key suspendThenHibernate "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group DPMSControl --key idleTime "300"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group BrightnessControl --key value --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group DimDisplay --key idleTime --delete
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group HandleButtonEvents --key triggerLidActionWhenExternalMonitorPresent "false"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group SuspendSession --key idleTime "600000"
kwriteconfig5 --file ~/.config/powermanagementprofilesrc --group LowBattery --group SuspendSession --key suspendThenHibernate "false"

## hide files and folders
echo -e "Backup\nigv\nPublic\nR\nLicenses\nTemplates\nsnap\nZotero\nSync\nsync\nDeveloping\ndeveloping\nprojects\ndavmail.log\nOneDrive\nVirtualBox VMs" > ~/.hidden
echo -e "Enpass\nWeChat Files\nxwechat_files" > ~/Documents/.hidden
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

# config
bash ./cfg/0_sysstg.sh
bash ./cfg/1_sysapp.sh
bash ./cfg/2_sysdsp.sh
bash ./cfg/3_reboot.sh
