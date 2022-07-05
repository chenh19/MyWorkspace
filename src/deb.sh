#!/bin/bash
# This script installs deb packages by apt

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

# install updates
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y

# install java
sudo apt-get update && sudo apt-get install default-jre default-jdk -y

# install apps (directly)
# installed by Kubuntu by defauly: python3, git, kate, kcalc, partitionmanager
sudo apt-get install kwrite krita seahorse evolution evolution-ews xdotool kdocker curl python3-pip -y
#sudo apt-get install axel -y

# install apps (downloaded)
[ ! -d ./deb/ ] && mkdir ./deb/
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -q https://zoom.us/client/latest/zoom_amd64.deb
wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb

wget -q https://github.com/JoseExposito/touchegg/releases/download/2.0.14/touchegg_2.0.14_amd64.deb #_to_be_updated
wget -q https://downloads.slack-edge.com/releases/linux/4.27.154/prod/x64/slack-desktop-4.27.154-amd64.deb #_to_be_updated
wget -q https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb #_to_be_updated
wget -q https://github.com/jurplel/qView/releases/download/5.0/qview_5.0.1-focal4_amd64.deb #_to_be_updated
mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./deb/*.deb

# config
# Start Slack minimized
sudo sed -i 's+Exec=/usr/bin/slack %U+Exec=/usr/bin/slack -u %U+g' /usr/share/applications/slack.desktop
# right click on the Slack icon on the bottom right, click "Check for Updates..." to open login interface, check "Launch on Login" if preferred
# zoom auto scaling
kwriteconfig5 --file ~/.config/zoomus.conf --group General --key autoScale "false"
# teamviewer wallpaper
[ -d ~/.config/teamviewer/ ] && rm -rf ~/.config/teamviewer/
cp -rf ./src/teamviewer/ ~/.config/
# simplenote quites unexpectedly
sudo sed -i 's+Exec=/opt/Simplenote/simplenote %U+Exec=/opt/Simplenote/simplenote --no-sandbox %U+g' /usr/share/applications/simplenote.desktop

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./deb/

# notify end
echo -e " \n${TEXT_GREEN}Deb pacakges installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/deb.sh+#bash ./src/deb.sh+g' ~/.setup_cache/setup.sh
