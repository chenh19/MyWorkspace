#!/usr/bin/env bash
# This script installs system packages by apt and dpkg

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# notify start
echo -e "${TEXT_YELLOW}Installing system tools...${TEXT_RESET}\n" && sleep 1

# edit sources.list
source /etc/os-release
echo -e "# See https://wiki.debian.org/SourcesList for more information.\ndeb http://deb.debian.org/debian $VERSION_CODENAME main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian $VERSION_CODENAME-updates main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME-updates main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian-security/ $VERSION_CODENAME-security main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian-security/ $VERSION_CODENAME-security main contrib non-free non-free-firmware\n\n# Backports allow you to install newer versions of software made available for this release\ndeb http://deb.debian.org/debian $VERSION_CODENAME-backports main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list

# install updates
sudo apt update
packages=(raspi-firmware firefox-esr gimp goldendict goldendict-ng akregator kmousetool kontrast kmail kmailtransport-akonadi dragonplayer juk konqueror kasumi kamera kmag kmouth kfind mlterm mlterm-tools mlterm-common ncurses-term xiterm+thai)
to_remove=()
for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" 2>/dev/null | grep -q "Status: install ok installed"; then to_remove+=("$pkg"); fi
done
if [ ${#to_remove[@]} -gt 0 ]; then sudo apt remove -y "${to_remove[@]}"; fi
sudo apt autoremove -y
sudo apt full-upgrade -y
#sudo apt install -y -t $(lsb_release -cs)-backports linux-image-amd64
if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt update -qq && sudo apt install wget -y && sleep 1 ; fi
if lspci | grep -q NVIDIA; then sudo apt update -qq && sudo apt install nvidia-detect nvidia-driver firmware-misc-nonfree nvtop -y; fi
#note: legacy GPUs like GT 1030 is not supported by the open GPU kernel modules (nvidia-open-kernel-dkms)

# install apps (apt)
  ## not installing or installed by Debian by default: kwrite python3 git kate kcalc partitionmanager libreoffice exfatprogs evolution evolution-ews elisa fsearch kdocker bash-completion plasma-firewall samba libavcodec-extra
  sudo apt install default-jre default-jdk systemd-timesyncd ufw seahorse tree plymouth-themes solaar ttf-mscorefonts-installer thunderbird krita krita-l10n inkscape kdenlive vlc -y
  # QT_AUTO_SCREEN_SCALE_FACTOR=1 krita

# install apps (ppa)

# install apps (source list)

  ## onedrive
  # https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md#distribution-debian-13
  wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_13/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_13/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list
  sudo apt update -qq && sudo apt install --no-install-recommends --no-install-suggests onedrive -y
  [ -f /usr/share/keyrings/obs-onedrive.gpg ] && sudo rm -f /usr/share/keyrings/obs-onedrive.gpg
  [ -f /etc/apt/sources.list.d/onedrive.list ] && sudo rm -f /etc/apt/sources.list.d/onedrive.list
  
  ## enpass
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list >/dev/null 2>&1
  wget -qO- "https://apt.enpass.io/keys/enpass-linux.key" | sudo tee /etc/apt/trusted.gpg.d/enpass.asc >/dev/null 2>&1
  sudo apt update -qq && sudo apt install enpass -y
  [ -f /etc/apt/sources.list.d/enpass.list ] && sudo rm -f /etc/apt/sources.list.d/enpass.list
  [ -f /etc/apt/trusted.gpg.d/enpass.asc ] && sudo rm -f /etc/apt/trusted.gpg.d/enpass.asc
  [ ! -d ~/Documents/Enpass/ ] && mkdir ~/Documents/Enpass/
  
  ## wine
  [ -f /etc/apt/sources.list.d/winehq-*.sources ] && sudo rm -f /etc/apt/sources.list.d/winehq-*.sources
  [ -f /etc/apt/keyrings/winehq-archive.key ] && sudo rm -f /etc/apt/keyrings/winehq-archive.key
  source /etc/os-release
  sudo dpkg --add-architecture i386
  sudo mkdir -pm755 /etc/apt/keyrings
  sudo wget -qNP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/$VERSION_CODENAME/winehq-$VERSION_CODENAME.sources
  wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --yes --dearmor --output /etc/apt/keyrings/winehq-archive.key -
  sudo apt update -qq && sudo apt install --install-recommends winehq-stable -y

  ## resilio sync
  echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list >/dev/null 2>&1
  wget -qO- https://linux-packages.resilio.com/resilio-sync/key.asc | sudo tee /etc/apt/trusted.gpg.d/resilio-sync.asc > /dev/null 2>&1
  if dpkg -l | grep -q "^ii.*resilio-sync" && [ ! -f /usr/share/keyrings/pgdg_resilio.gpg ]; then
      resilio_id=3F171DE2
      sudo apt-key export $resilio_id | sudo gpg --dearmour -o /usr/share/keyrings/pgdg_resilio.gpg
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgdg_resilio.gpg] http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
      sudo apt-key del $resilio_id
      sudo rm -f /etc/apt/trusted.gpg.d/resilio-sync.asc*
      unset resilio_id
  fi
  sudo apt update -qq && sudo apt install resilio-sync -y
  sudo systemctl disable resilio-sync
  sudo kwriteconfig5 --file /usr/lib/systemd/user/resilio-sync.service --group Install --key WantedBy "default.target"
  systemctl --user enable resilio-sync
  systemctl --user start resilio-sync
  [ ! -d ~/Sync/ ] && mkdir ~/Sync/ && kwriteconfig5 --file ~/Sync/.directory --group "Desktop Entry" --key Icon "folder-cloud"
  [ -f /etc/apt/sources.list.d/resilio-sync.list ] && sudo rm -f /etc/apt/sources.list.d/resilio-sync.list
  [ -f /etc/apt/trusted.gpg.d/resilio-sync.asc* ] && sudo rm -f /etc/apt/trusted.gpg.d/resilio-sync.asc*
  [ -f /usr/share/keyrings/pgdg_resilio.gpg ] && sudo rm -f /usr/share/keyrings/pgdg_resilio.gpg

# install apps (downloaded)

echo ""
[ ! -d ./deb/ ] && mkdir ./deb/

  ## official redirecting links
  wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb && echo '"Google Chrome" deb package is downloaded.' && sleep 1
  wget -q "https://zoom.us/client/latest/zoom_amd64.deb" -O zoom.deb && echo '"Zoom" deb package is downloaded.' && sleep 1 #x11 scaling
  # QT_SCALE_FACTOR=2 /usr/bin/zoom
  wget -q "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb" -O teamviewer.deb && echo '"Teamviewer" deb package is downloaded.' && sleep 1 #x11 scaling
  # QT_SCALE_FACTOR=2 /opt/teamviewer/tv_bin/script/teamviewer
  #wget -q "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" -O onlyoffice.deb && echo '"OnlyOffice" deb package is downloaded.' && sleep 1
  
  ## self maintained redirecting links
  #wget -q "https://www.dropbox.com/scl/fi/i5w10jbmg1a25891castf/etcher.deb?rlkey=bcg1lyuwfo43ejtv6h2nn1htv" -O etcher.deb && echo '"Balena Etcher" deb package is downloaded.' && sleep 1 #dependency issue
  #wget -q "https://www.dropbox.com/scl/fi/nhow2orfr13h2sab1eulj/4kvideodownloader.deb?rlkey=s3a7aj6z6i1bgjjng7uwh5spg" -O 4kvideodownloader.deb && echo -e '"4K Video Downloader+" deb package is downloaded.' && sleep 1 #x11 scaling
  # QT_SCALE_FACTOR=2 4kvideodownloaderplus
  wget -q "https://www.dropbox.com/scl/fi/8s36u19ya5op3msfcngtk/qview-old.deb?rlkey=klsgn6llvqpn9t4nyz8wo9iyg" -O qview.deb && echo '"qView" deb package is downloaded.' && sleep 1
  wget -q "https://www.dropbox.com/scl/fi/f8z2xbm8zy1p9r2014bq1/eudic.deb?rlkey=3ce5bwl8ltg1xq1e7mqweelwb" -O eudic.deb && echo -e '"EuDic" deb package is downloaded.' && sleep 1
  # QT_SCALE_FACTOR=2 /usr/share/eusoft-eudic/AppRun
  wget -q "https://www.dropbox.com/scl/fi/d55hac9aiwzzc7aq8ky72/simplenote.deb?rlkey=p0lg6vdsefoi16pc04sg1r1n6" -O simplenote.deb && echo '"Simplenote" deb package is downloaded.' && sleep 1
  wget -q "https://www.dropbox.com/scl/fi/s779gps9u2qkr6o7klwk5/fastfetch.deb?rlkey=036z6hfh42y8j232ptgoyi12w" -O fastfetch.deb && echo '"Fastfetch" deb package is downloaded.' && sleep 1
  #wget -q "https://www.dropbox.com/scl/fi/s0aopqvbu9pz4jxfo23n4/slack.deb?rlkey=2errjlsb9uxl0hkjgfezkczab" -O slack.deb && echo '"Slack" deb package is downloaded.' && sleep 1
  wget -q "https://www.dropbox.com/scl/fi/x8gwrqsas8lqt2ckdyqc6/wechat.deb?rlkey=o0sg577sxwbwr3e68rgi2lney" -O wechat.deb && echo '"WeChat" deb package is downloaded.' && sleep 1
  # QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2 /usr/bin/wechat
  wget -q "https://www.dropbox.com/scl/fi/ohmiilwoep7ugvlpbov8i/freedownloadmanager.deb?rlkey=34tnbu8t68u0ffeeukcrqcq9v" -O freedownloadmanager.deb && echo '"Free Download Manager" deb package is downloaded.' && sleep 1
  #wget -q "https://www.dropbox.com/scl/fi/rufzgb528vzg19w45c5vx/touchegg.deb?rlkey=bjp0q9jaf25oo34vuyu0qzzw1" -O touchegg.deb && echo '"Touchegg" deb package is downloaded.' && sleep 1
  
  
  ## install
  echo ""
  mv -f ./*.deb ./deb/ && sudo apt install -f -y ./deb/*.deb

# install input method

  ## fcitx
  [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
  [ ! -d ~/.config/fcitx5/ ] && mkdir ~/.config/fcitx5/
  [ ! -d ~/.config/fcitx5/conf/ ] && mkdir ~/.config/fcitx5/conf/
  [ ! -d ~/.local/share/fcitx5/ ] && mkdir ~/.local/share/fcitx5/
  [ ! -d ~/.local/share/fcitx5/themes/ ] && mkdir ~/.local/share/fcitx5/themes/
  sudo apt install fcitx5 fcitx5-pinyin fcitx5-chinese-addons fcitx5-mozc fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-qt5 kde-config-fcitx5 fcitx5-config-qt -y
  sudo apt --fix-missing update && sudo apt install -f -y
  [ ! -f fcitx5-themes.zip ] && wget -q "https://www.dropbox.com/scl/fi/7fldgym73qz3oq88z4ruh/fcitx5-themes.zip?rlkey=y9ko399f3pxkmne2mdkbxgxo9" -O fcitx5-themes.zip && sleep 1
  unzip -o -q fcitx5-themes.zip -d ./cfg/ && sleep 1 && rm -f fcitx5-themes.zip && sleep 1
  cp -rf ./cfg/fcitx5-themes/* ~/.local/share/fcitx5/themes/ && sleep 1

# AppImages

  ## OneDrive
  wget -q "https://www.dropbox.com/scl/fi/l4s04hw0z0y9su54fzewe/onedrivegui.AppImage?rlkey=tmwf6y38kpovdkl5wvy7pmczk" -O onedrivegui.AppImage && echo '"OneDriveGUI" AppImage package is downloaded.' && sleep 1
  [ ! -d /opt/onedrivegui/ ] && sudo mkdir /opt/onedrivegui/
  sudo mv -f ./onedrivegui.AppImage /opt/onedrivegui/ && sleep 1
  sudo chmod +x /opt/onedrivegui/onedrivegui.AppImage
  [ ! -f /usr/share/applications/onedrivegui.desktop ] && sudo touch /usr/share/applications/onedrivegui.desktop
  sudo desktop-file-edit \
    --set-name 'OneDrive' --set-key 'Name[en_US]' --set-value 'OneDrive' --set-key 'Name[zh_CN]' --set-value 'OneDrive' \
    --set-generic-name 'Cloud Storage' --set-key 'GenericName[en_US]' --set-value 'Cloud Storage' --set-key 'GenericName[zh_CN]' --set-value '云储存空间' \
    --set-comment 'OneDrive Client' --set-key 'Comment[en_US]' --set-value 'OneDrive Client' --set-key 'Comment[zh_CN]' --set-value 'OneDrive 客户端' \
    --set-key 'Exec' --set-value '/opt/onedrivegui/onedrivegui.AppImage' \
    --set-icon '/opt/icon/onedrive.png' \
    --set-key 'Type' --set-value 'Application' \
    --remove-key 'Categories' --add-category 'Utility;' \
  /usr/share/applications/onedrivegui.desktop
  sleep 1
  cp -rf ./cfg/onedrive-gui/ ~/.config/
  #cp -f /usr/share/applications/onedrivegui.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/onedrivegui.desktop

# install apps (.run)

  ## virtualbox (wait for official update)
  [ ! -d ~/VirtualBox\ VMs/ ] && mkdir ~/VirtualBox\ VMs/
  wget -q "https://www.dropbox.com/scl/fi/ecpe9nup1xu5lsvx6qdnm/virtualbox.run?rlkey=rc2hhdmjfu36ve8b4imifa3nv" -O ./inst/virtualbox.run && echo '"VirtualBox" installer is downloaded.' && sleep 1
  sudo bash ./inst/virtualbox.run
  
# auto config

  ## enable firewall
  sudo ufw enable

  ## chrome as default
  kwriteconfig5 --file ~/.config/kdeglobals --group General --key BrowserApplication "google-chrome.desktop"

  ## time sync
  sudo timedatectl set-ntp true
  sudo timedatectl status
  
  ## Touchegg
  #[ ! -d ~/.config/touchegg/ ] && mkdir ~/.config/touchegg/
  #cp -f ./cfg/touchegg/touchegg.conf ~/.config/touchegg/
  
  ## Fastfetch
  [ ! -d ~/.config/fastfetch/ ] && mkdir ~/.config/fastfetch/
  wget -qO- https://raw.githubusercontent.com/fastfetch-cli/fastfetch/dev/presets/neofetch.jsonc > ~/.config/fastfetch/config.jsonc
  
  ## Etcher
  #[ ! -d ~/.config/balena-etcher/ ] && mkdir ~/.config/balena-etcher/
  #echo -e '{\n  "errorReporting": false,\n  "updatesEnabled": true,\n  "desktopNotifications": true,\n  "autoBlockmapping": true,\n  "decompressFirst": true\n}' > ~/.config/balena-etcher/config.json

  ## zoom auto scaling
  kwriteconfig5 --file ~/.config/zoomus.conf --group General --key autoScale "false"

  ## teamviewer wallpaper
  [ ! -d ~/.config/teamviewer/ ] && mkdir ~/.config/teamviewer/
  [ -d ~/.config/teamviewer/ ] && rm -rf ~/.config/teamviewer/*
  echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0" > ~/.config/teamviewer/client.conf

  ## simplenote quites unexpectedly
  #sudo sed -i 's+Exec=/opt/Simplenote/simplenote %U+Exec=/opt/Simplenote/simplenote --no-sandbox %U+g' /usr/share/applications/simplenote.desktop

  ## qView
  [ ! -d ~/.config/qView/ ] && mkdir ~/.config/qView/
  [ -d ~/.config/qView/ ] && rm -rf ~/.config/qView/*
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key updatenotifications "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key loopfoldersenabled "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key saverecents "false"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key titlebarmode "2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolor "#dee0e2"
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key bgcolorenabled "true"

  ## apt modernize-sources
  #sudo apt modernize-sources -y #(for apt 3.0 and above)
  
  ## fcitx
  cp -f /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/org.fcitx.Fcitx5.desktop
  cp -rf ./cfg/fcitx5/* ~/.config/fcitx5/
  im-config -c -n fcitx5
  if grep -q "# zh_CN.UTF-8 UTF-8" /etc/locale.gen ; then sudo sed -i 's+# zh_CN.UTF-8 UTF-8+zh_CN.UTF-8 UTF-8+g' /etc/locale.gen ; fi
  sudo locale-gen
  echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nGTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment

  ## wechat
  [ ! -f /etc/lsb-release ] && sudo touch /etc/lsb-release

  ## solaar
  [ ! -d ~/.config/solaar/ ] && mkdir ~/.config/solaar/
  cp -f ./cfg/solaar/rules.yaml ~/.config/solaar/
  sudo cp -f ./cfg/solaar/42-logitech-unify-permissions.rules /etc/udev/rules.d

  ## thunderbird
  #sudo chmod +x /opt/Thunderbird/thunderbird.sh
  #[ -f /usr/share/applications/thunderbird.desktop ] && sudo desktop-file-edit \
  #  --set-name 'Thunderbird' --set-key 'Name[en_US]' --set-value 'Thunderbird' --set-key 'Name[zh_CN]' --set-value '邮箱' \
  #  --set-generic-name 'Email Client' --set-key 'GenericName[en_US]' --set-value 'Email Client' --set-key 'GenericName[zh_CN]' --set-value '邮件客户端' \
  #  --set-comment 'Read/Write Mail/News with Thunderbird' --set-key 'Comment[en_US]' --set-value 'Read/Write Mail/News with Thunderbird' --set-key 'Comment[zh_CN]' --set-value '阅读邮件或新闻' \
  #  --set-key 'Exec' --set-value 'bash /opt/Thunderbird/thunderbird.sh' \
  #  --remove-key 'Categories' --add-category 'Network;' \
  #/usr/share/applications/thunderbird.desktop
  #sleep 1
  ##cp -f /usr/share/applications/thunderbird.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/thunderbird.desktop

# cleanup
rm -rf ./deb/
rm -rf ./cfg/fcitx5-themes/
[ -d ~/snap/firefox/ ] && sudo rm -rf ~/snap/firefox/
[ -d ~/Downloads/firefox.tmp/ ] && sudo rm -rf ~/Downloads/firefox.tmp/
sudo apt update -qq && sudo apt autoremove -y && sudo apt clean

# notify end
echo -e "\n${TEXT_GREEN}System tools installed!${TEXT_RESET}\n" && sleep 3

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/0_systools.sh+#bash ./inst/0_systools.sh+g' ~/.setup_cache/setup.sh
