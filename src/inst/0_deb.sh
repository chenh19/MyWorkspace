#!/bin/bash
# This script installs deb packages by apt-get and dpkg

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Deb packages installing...${TEXT_RESET} \n" && sleep 1
sudo apt-get update

# install updates
sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y
echo -e " \n${TEXT_GREEN}Distribution update completed!${TEXT_RESET} \n" && sleep 1

# install java
sudo apt-get install default-jre default-jdk -y
echo -e " \n${TEXT_GREEN}Java environment installed!${TEXT_RESET} \n" && sleep 1

# install complete language packs
sudo apt-get install language-pack-en-base language-pack-en language-pack-gnome-en-base language-pack-gnome-en language-pack-kde-en -y
echo -e " \n${TEXT_GREEN}Complete English language packs installed!${TEXT_RESET} \n" && sleep 1

  ## ask whether to install Chinese packs
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Install Chinese language packs? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) sudo apt-get install language-pack-zh-hans-base language-pack-zh-hans language-pack-gnome-zh-hans-base language-pack-gnome-zh-hans language-pack-kde-zh-hans -y
              echo -e " \n${TEXT_GREEN}Complete Chinese language packs installed!${TEXT_RESET} \n" && sleep 1;;
          * ) echo -e " \n${TEXT_YELLOW}Chinese language packs not installed!${TEXT_RESET} \n" && sleep 1;;
  esac

# install apps (apt)
  # installed by Kubuntu by defauly: python3, git, kate, kcalc, partitionmanager
  # with better alternative option: syncthing-gtk, axel
  sudo apt-get install kwrite krita krita-l10n seahorse evolution evolution-ews xdotool kdocker curl python3-pip tree samba piper -y

# install apps (ppa)

  ## libreoffice
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to add PPA for LibreOffice (for KDE neon)? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # add ppa
              echo "" && sudo add-apt-repository ppa:libreoffice/ppa -y
              # notify end
              echo -e " \n${TEXT_GREEN}LibreOffice PPA added!${TEXT_RESET} \n" && sleep 1;;
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}LibreOffice PPA not added, using default repository.${TEXT_RESET} \n" && sleep 1;;
  esac
  sudo apt-get update && sudo apt-get install libreoffice libreoffice-plasma libreoffice-qt5 libreoffice-kf5 libreoffice-style-breeze libreoffice-sdbc-hsqldb libreoffice-help-en-us libreoffice-help-zh-cn libreoffice-l10n-zh-cn libreoffice-java-common -y

  ## Inkscape
  sudo add-apt-repository ppa:inkscape.dev/stable -y
  sudo apt-get update && sudo apt-get install inkscape -y
  
  ## WiFi Hotspot
  sudo add-apt-repository ppa:lakinduakash/lwh -y
  sudo apt-get update && sudo apt-get install linux-wifi-hotspot -y

# install apps (source list)
  ## enpass
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
  sudo apt-get update && sudo apt-get install enpass -y
  
  ## resilio sync
  [ ! -d ~/Sync/ ] && mkdir ~/Sync/ && kwriteconfig5 --file ~/Sync/.directory --group "Desktop Entry" --key Icon "folder-cloud"
  echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
  curl -L https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add
  sudo apt-get update && sudo apt-get install resilio-sync -y
  sudo systemctl disable resilio-sync
  sudo kwriteconfig5 --file /usr/lib/systemd/user/resilio-sync.service --group Install --key WantedBy "default.target"
  systemctl --user enable resilio-sync
  systemctl --user start resilio-sync

# install apps (pip)
  ## speedtest
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Speedtest-CLI by Ookla? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Installing Speedtest-CLI...${TEXT_RESET} \n" && sleep 1
                #install
                sudo pip install speedtest-cli
                echo -e " \n${TEXT_GREEN}Testing internet speed...${TEXT_RESET} \n" && sleep 1
                speedtest
                # notify end
                echo -e " \n${TEXT_GREEN}Speedtest-CLI installed!${TEXT_RESET} \n" && sleep 5;;
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}Speedtest-CLI not installed.${TEXT_RESET} \n" && sleep 5;;
  esac

# install apps (downloaded)
  [ ! -d ./deb/ ] && mkdir ./deb/
  echo -e " \n${TEXT_YELLOW}Downloading deb packages...${TEXT_RESET} \n" && sleep 1
  
  ## redirecting links
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && echo '"Google Chrome" deb package is downloaded.' && sleep 1
  wget -q https://zoom.us/client/latest/zoom_amd64.deb && echo '"Zoom" deb package is downloaded.' && sleep 1
  wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && echo '"Teamviewer" deb package is downloaded.' && sleep 1

  ## absolute links
  wget -q https://github.com/JoseExposito/touchegg/releases/download/2.0.15/touchegg_2.0.15_amd64.deb && echo '"Touchegg" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-desktop-4.29.149-amd64.deb && echo '"Slack" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb && echo '"Simplenote" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/jurplel/qView/releases/download/5.0/qview_5.0.1-focal4_amd64.deb && echo '"qView" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/ciderapp/cider-releases/releases/download/v1.5.9/cider_1.5.9_amd64.deb && echo '"Cider" deb package is downloaded.' && sleep 1 #_to_be_updated
  
  ## ask whether to download
  ### fdm
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download Free Download Manager? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Downloading Free Download Manager...${TEXT_RESET} \n" && sleep 1
              # download
              wget -q https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb
              # notify end
              echo -e ' \n"Free Download Manager" deb package is downloaded. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"Free Download Manager" deb package not downloaded. \n' && sleep 1;;
  esac
  ### expandrive
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download ExpanDrive? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Downloading ExpanDrive...${TEXT_RESET} \n" && sleep 1
              # download
              wget -q https://packages.expandrive.com/expandrive/pool/stable/e/ex/ExpanDrive_2022.7.1_amd64.deb #_to_be_updated
              # notify end
              echo -e ' \n"ExpanDrive" deb package is downloaded. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"ExpanDrive" deb package not downloaded. \n' && sleep 1;;
  esac
  ### baiduyun
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download BaiduYun? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Downloading BaiduYun...${TEXT_RESET} \n" && sleep 1
              # download
              wget -q https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/4.14.5/baidunetdisk_4.14.5_amd64.deb #_to_be_updated
              # notify end
              echo -e ' \n"BaiduYun" deb package is downloaded. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"BaiduYun" deb package not downloaded. \n' && sleep 1;;
  esac
  ### angry IP scanner
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download Angry IP Scanner? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Downloading Angry IP Scanner...${TEXT_RESET} \n" && sleep 1
              # download
              wget -q https://github.com/angryip/ipscan/releases/download/3.8.2/ipscan_3.8.2_amd64.deb #_to_be_updated
              # notify end
              echo -e ' \n"Angry IP Scanner" deb package is downloaded. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"Angry IP Scanner" deb package not downloaded. \n' && sleep 1;;
  esac
  ### 4k video downloader
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download 4K Video Downloader? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
              echo -e " \n${TEXT_YELLOW}Downloading 4K Video Downloader...${TEXT_RESET} \n" && sleep 1
              # download
              wget -q https://dl.4kdownload.com/app/4kvideodownloader_4.21.7-1_amd64.deb?source=website -O 4kvideodownloader.deb #_to_be_updated
              # notify end
              echo -e ' \n"4K Video Downloader" deb package is downloaded. \n' && sleep 1;;
          * ) # notify cancellation
              echo -e ' \n"4K Video Downloader" deb package not downloaded. \n' && sleep 1;;
  esac  
  
  ## install
  mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./deb/*.deb
  
# fix missings
sudo apt-get --fix-missing update && sudo apt-get install -y $(check-language-support) && sudo apt-get install -f -y

# auto config
  ## zoom auto scaling
  kwriteconfig5 --file ~/.config/zoomus.conf --group General --key autoScale "false"

  ## teamviewer wallpaper
  [ -d ~/.config/teamviewer/ ] && rm -rf ~/.config/teamviewer/
  cp -rf ./cfg/teamviewer/ ~/.config/

  ## simplenote quites unexpectedly
  sudo sed -i 's+Exec=/opt/Simplenote/simplenote %U+Exec=/opt/Simplenote/simplenote --no-sandbox %U+g' /usr/share/applications/simplenote.desktop

  ## qView
  [ ! -d ~/.config/qView/ ] && mkdir ~/.config/qView/
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key updatenotifications "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key loopfoldersenabled "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key saverecents "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key titlebarmode "2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolor "#dee0e2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolorenabled "true"


# cleanup
sudo apt-get remove firefox kate thunderbird krdc konversation ktorrent skanlite usb-creator-kde kmahjongg kmines kpat ksudoku -y
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./deb/

# notify end
echo -e " \n${TEXT_GREEN}Deb packages installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./inst/0_deb.sh+#bash ./inst/0_deb.sh+g' ~/.setup_cache/setup.sh
