#!/usr/bin/env bash
# This script intsalls winboat

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing WinBoat...${TEXT_RESET}\n" && sleep 1

# winboat docker version
## Add Docker's official GPG key:
sudo apt update -qq && sudo apt install ca-certificates curl wget -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sleep 1

## Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sleep 1

## Install dependencies:
sudo apt update -qq && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sleep 1

## Download and install:
echo ""
wget -q "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb" -O docker-desktop.deb && echo '"Docker Desktop" deb package is downloaded.' && sleep 1
wget -q "https://www.dropbox.com/scl/fi/u1ql2pg3ftcq2u61evu9k/winboat.deb?rlkey=be7x3ogc1hhrrv3nn2vr1437v" -O winboat.deb && echo '"WinBoat" deb package is downloaded.' && sleep 1
echo ""
sudo apt install ./docker-desktop.deb ./winboat.deb -y
sleep 1
rm -f ./docker-desktop.deb ./winboat.deb

## Config
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
[ -f /etc/apt/keyrings/docker.asc ] && sudo rm -f /etc/apt/keyrings/docker.asc
[ -f /etc/apt/sources.list.d/docker.sources ] && sudo rm -f /etc/apt/sources.list.d/docker.sources
[ -f /usr/share/applications/winboat.desktop ] && sudo desktop-file-edit \
    --set-name 'WinBoat' --set-key 'Name[en_US]' --set-value 'WinBoat' --set-key 'Name[zh_CN]' --set-value 'WinBoat' \
    --set-comment 'Windows for Penguins' --set-key 'Comment[en_US]' --set-value 'Windows for Penguins' --set-key 'Comment[zh_CN]' --set-value '容器Windows' \
    --set-generic-name 'Run Windows apps on Linux with seamless integration' --set-key 'GenericName[en_US]' --set-value 'Run Windows apps on Linux with seamless integration' --set-key 'GenericName[zh_CN]' --set-value 'Windows无缝融合' \
    --remove-key 'Categories' --add-category 'Utility;' \
/usr/share/applications/winboat.desktop
sudo apt update -qq
sleep 1

# notify start
echo -e "\n${TEXT_GREEN}Winboat installed!${TEXT_RESET}\n" && sleep 3

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/2_winboat.sh+#bash ./inst/2_winboat.sh+g' ~/.setup_cache/setup.sh
