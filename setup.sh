#!/bin/bash

# enter password for root & set promot color
sudo echo "===================================================================================="
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'


# check internet connection
echo -e "${TEXT_YELLOW}Checking internet connection...${TEXT_RESET}" && sleep 1
wget -q --spider http://google.com
if [ $? -eq 0 ]
then 
echo -e "${TEXT_YELLOW}Internet is connected!${TEXT_RESET}" && sleep 1
else 
echo -e "${TEXT_YELLOW}No internet connection, please first connect to internet then hit [Enter] to continue${TEXT_RESET}" # to be updated
fi
echo "===================================================================================="


# download setup scripts
cd ~
[ ! -d .setup_cache ] && mkdir ./.setup_cache
echo -e "${TEXT_YELLOW}Downloading setup scripts...${TEXT_RESET}" && sleep 1
cd ./.setup_cache
[ ! -d master ] && wget -q https://codeload.github.com/chenh19/myworkspace/zip/refs/heads/main && unzip -o -q main && rm main
cd ./myworkspace-main && rm LICENSE README.md && sleep 1
echo -e "${TEXT_YELLOW}All scripts downloaded!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# update
echo -e "${TEXT_YELLOW}Updating system packages...${TEXT_RESET}" && sleep 1
bash ./scripts/update.sh && sleep 1
echo -e "${TEXT_YELLOW}All system packages updated!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# flathub
echo -e "${TEXT_YELLOW}Installing Flathub...${TEXT_RESET}" && sleep 1
bash ./scripts/flathub.sh && sleep 1
echo -e "${TEXT_YELLOW}Flat installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# apt install
echo -e "${TEXT_YELLOW}Apt-get installing...${TEXT_RESET}" && sleep 1
bash ./scripts/apt.sh && sleep 1
echo -e "${TEXT_YELLOW}Apt-get pacakges installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# install wechat
#wget -q https://www.dropbox.com/s/t43dz4ws6576r58/deepin-wine-ubuntu-master.zip?dl=0 && unzip -o -q deepin-wine-ubuntu-master.zip?dl=0 && rm deepin-wine-ubuntu-master.zip?dl=0
#sudo bash ./deepin-wine-ubuntu-master/deepin-wine-setup.sh
#sudo bash ./deepin-wine-ubuntu-master/KDE-install.sh
#sudo ln -sf /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1.0 /usr/lib/i386-linux-gnu/deepin-wine/libwine.so.1
#sudo dpkg-reconfigure locales
#sudo dpkg -i ./deepin-wine-ubuntu-master/deepin.com.wechat_2.6.8.65deepin0_i386.deb

# 2nd update
echo -e "${TEXT_YELLOW}Updating system packages...${TEXT_RESET}" && sleep 1
bash ./scripts/update.sh && sleep 1
echo -e "${TEXT_YELLOW}All system packages updated!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# cleanup & reboot
echo -e "${TEXT_YELLOW}Cleaning up...${TEXT_RESET}" && sleep 1
#cd ../../ && rm -rf ./.setup_cache
echo -e $TEXT_YELLOW
read -n1 -s -r -p $'All done! Reboot the system now? [y/n/c]\n' choice # to be updated
echo ""
case "$choice" in
  y|Y ) echo "Rebooting in 5..." && sleep 5 && reboot;;
  n|N ) echo "Please manually reboot the system later.";;
  * ) echo "Please manually reboot the system later.";;
esac
echo -e $TEXT_RESET
