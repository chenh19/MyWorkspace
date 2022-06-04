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
cd ./myworkspace-main && rm -rf ./docs && rm LICENSE README.md && sleep 1
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

# pinyin input
echo -e "${TEXT_YELLOW}Chinese Pinyin Input Method installing...${TEXT_RESET}" && sleep 1
bash ./scripts/fcitx.sh && sleep 1
echo -e "${TEXT_YELLOW}Chinese Pinyin Input Method installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# AppImages (EuDic/Etcher/Tropy)
echo -e "${TEXT_YELLOW}AppImages deploying...${TEXT_RESET}" && sleep 1
bash ./scripts/appimage.sh && sleep 1
echo -e "${TEXT_YELLOW}AppImages deployed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# wechat
echo -e "${TEXT_YELLOW}WeChat installing...${TEXT_RESET}" && sleep 1
#bash ./scripts/wechat.sh && sleep 1
echo -e "${TEXT_YELLOW}WeChat installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# R & RStudio
echo -e "${TEXT_YELLOW}R & RStudio installing...${TEXT_RESET}" && sleep 1
#bash ./scripts/rstudio.sh && sleep 1
echo -e "${TEXT_YELLOW}R & RStudio installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# SnapGene/IGV/PyMOL
echo -e "${TEXT_YELLOW}SnapGene/IGV/PyMOL installing...${TEXT_RESET}" && sleep 1
#bash ./scripts/rstudio.sh && sleep 1
echo -e "${TEXT_YELLOW}SnapGene/IGV/PyMOL installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# ukuu
echo -e "${TEXT_YELLOW}UKUU installing...${TEXT_RESET}" && sleep 1
#bash ./scripts/ukuu.sh && sleep 1
echo -e "${TEXT_YELLOW}UKUU installed!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

# grub
echo -e $TEXT_YELLOW
read -n1 -s -r -p $'Are you using ThinkPad? [y/n/c]\n' choice
case "$choice" in
  y|Y ) echo "Configuring grub for ThinkPad..." && bash ./scripts/grub.sh;;
  n|N ) echo "No need to configure grub.";;
  * ) echo "No need to configure grub.";;
esac
echo -e $TEXT_RESET

# debloating
echo -e "${TEXT_YELLOW}Debloating...${TEXT_RESET}" && sleep 1
bash ./scripts/debloat.sh && sleep 1
echo -e "${TEXT_YELLOW}Debloated!${TEXT_RESET}" && sleep 1
echo "===================================================================================="

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
