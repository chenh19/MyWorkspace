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
echo -e "${TEXT_YELLOW}Installing Deb packages...${TEXT_RESET} \n" && sleep 1

# edit sources.list
echo -e "# See https://wiki.debian.org/SourcesList for more information.\ndeb http://deb.debian.org/debian $(lsb_release -cs) main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $(lsb_release -cs) main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian $(lsb_release -cs)-updates main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $(lsb_release -cs)-updates main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian-security/ $(lsb_release -cs)-security main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian-security/ $(lsb_release -cs)-security main contrib non-free non-free-firmware\n\n# Backports allow you to install newer versions of software made available for this release\ndeb http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list

# install updates
sudo apt-get update
if dpkg -l | grep -q "^ii.*raspi-firmware"; then sudo dpkg --purge raspi-firmware; fi
sudo apt-get remove gimp firefox-esr goldendict akregator kontrast kmail kmailtransport-akonadi dragonplayer juk kasumi konqueror kamera kmouth kmag kfind mlterm mlterm-tools mlterm-common ncurses-term xiterm+thai -y  && sudo apt-get autoremove -y
sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y

# install apps (apt)
  ## installed by Debian by defauly: kwrite, python3, git, kate, kcalc, partitionmanager, libreoffice, exfatprogs
  sudo apt-get install wget bash-completion systemd-timesyncd ufw plasma-firewall default-jre default-jdk seahorse evolution evolution-ews tree samba neofetch krita krita-l10n kdenlive libavcodec-extra vlc elisa plymouth-themes -y

  ## timekpr-next
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Timekpr-nExT for parent control? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) echo "" && sudo apt-get install timekpr-next -y
              # notify end
              echo -e " \n${TEXT_GREEN}Timekpr-nExT installed!${TEXT_RESET} \n" && sleep 1;;
          * ) # notify cancellation
              echo -e " \n${TEXT_YELLOW}Timekpr-nExT not installed.${TEXT_RESET} \n" && sleep 1;;
  esac

# install apps (ppa)

# install apps (source list)
  ## enpass
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
  sudo apt-get update -qq && sudo apt-get install enpass -y

  ## resilio sync
  [ ! -d ~/Sync/ ] && mkdir ~/Sync/ && kwriteconfig5 --file ~/Sync/.directory --group "Desktop Entry" --key Icon "folder-cloud"
  [ -f /usr/share/keyrings/pgdg_resilio.gpg ] && sudo rm -f /usr/share/keyrings/pgdg_resilio.gpg
  echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
  curl -L https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add
  sudo apt-get update -qq && sudo apt-get install resilio-sync -y
  sudo systemctl disable resilio-sync
  sudo kwriteconfig5 --file /usr/lib/systemd/user/resilio-sync.service --group Install --key WantedBy "default.target"
  systemctl --user enable resilio-sync
  systemctl --user start resilio-sync

  # install apps (downloaded)
  [ ! -d ./deb/ ] && mkdir ./deb/
  echo -e " \n${TEXT_YELLOW}Downloading deb packages...${TEXT_RESET} \n" && sleep 1

  ## redirecting links
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && echo '"Google Chrome" deb package is downloaded.' && sleep 1
  wget -q https://zoom.us/client/latest/zoom_amd64.deb && echo '"Zoom" deb package is downloaded.' && sleep 1
  wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && echo '"Teamviewer" deb package is downloaded.' && sleep 1
  wget -q https://www.eudic.net/download/eudic.deb && echo -e '"EuDic" deb package is downloaded.' && sleep 1

  ## absolute links
  wget -q https://downloads.slack-edge.com/desktop-releases/linux/x64/4.37.101/slack-desktop-4.37.101-amd64.deb && echo '"Slack" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb && echo '"Simplenote" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/jurplel/qView/releases/download/6.1/qview_6.1-1-focal_amd64.deb && echo '"qView" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://github.com/balena-io/etcher/releases/download/v1.18.11/balena-etcher_1.18.11_amd64.deb && echo '"Balena Etcher" deb package is downloaded.' && sleep 1 #_to_be_updated
  wget -q https://dl.4kdownload.com/app/4kvideodownloaderplus_1.5.1-1_amd64.deb?source=website -O 4kvideodownloader+.deb && echo -e '"4K Video Downloader+" deb package is downloaded.' && sleep 1 #_to_be_updated

  ## install
  mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./deb/*.deb

# fix missings
sudo apt-get --fix-missing update && sudo apt-get install -f -y

# auto config

  ## enable firewall
  sudo ufw enable

  ## chrome as default
  kwriteconfig5 --file ~/.config/kdeglobals --group General --key BrowserApplication "google-chrome.desktop"

  ## time sync
  sudo timedatectl set-ntp true
  sudo timedatectl status

  ## Etcher
  [ ! -d ~/.config/balena-etcher/ ] && mkdir ~/.config/balena-etcher/
  echo -e '{\n  "errorReporting": false,\n  "updatesEnabled": true,\n  "desktopNotifications": true,\n  "autoBlockmapping": true,\n  "decompressFirst": true\n}' > ~/.config/balena-etcher/config.json

  ## zoom auto scaling
  kwriteconfig5 --file ~/.config/zoomus.conf --group General --key autoScale "false"

  ## teamviewer wallpaper
  [ ! -d ~/.config/teamviewer/ ] && mkdir ~/.config/teamviewer/
  [ -d ~/.config/teamviewer/ ] && rm -rf ~/.config/teamviewer/*
  echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0" > ~/.config/teamviewer/client.conf

  ## simplenote quites unexpectedly
  sudo sed -i 's+Exec=/opt/Simplenote/simplenote %U+Exec=/opt/Simplenote/simplenote --no-sandbox %U+g' /usr/share/applications/simplenote.desktop

  ## qView
  [ ! -d ~/.config/qView/ ] && mkdir ~/.config/qView/
  [ -d ~/.config/qView/ ] && rm -rf ~/.config/qView/*
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key updatenotifications "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key loopfoldersenabled "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key saverecents "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key titlebarmode "2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolor "#dee0e2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolorenabled "true"

  # resilio
  if dpkg -l | grep -q "^ii.*resilio-sync" && [ ! -f /usr/share/keyrings/pgdg_resilio.gpg ]; then
      resilio_id=3F171DE2
      sudo apt-key export $resilio_id | sudo gpg --dearmour -o /usr/share/keyrings/pgdg_resilio.gpg
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgdg_resilio.gpg] http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
      sudo apt-key del $resilio_id
      unset resilio_id
  fi

# cleanup
rm -rf ./deb/
sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean

# notify end
echo -e " \n${TEXT_GREEN}Deb packages installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/0_deb.sh+#bash ./inst/0_deb.sh+g' ~/.setup_cache/setup.sh
