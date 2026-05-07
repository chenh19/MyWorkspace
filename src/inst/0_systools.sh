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

# debloat
sudo apt update
packages=(raspi-firmware firefox-esr gimp goldendict goldendict-ng akregator kmousetool kontrast kmail kmailtransport-akonadi dragonplayer juk konqueror kasumi kamera kmag kmouth kfind kaddressbook korganizer mlterm mlterm-tools mlterm-common ncurses-term xiterm+thai xterm plasma-welcome)
to_remove=()
for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" 2>/dev/null | grep -q "Status: install ok installed"; then to_remove+=("$pkg"); fi
done
if [ ${#to_remove[@]} -gt 0 ]; then sudo apt remove -y "${to_remove[@]}"; fi
sudo apt autoremove -y

# install updates

  ## full-upgrade
  sudo apt full-upgrade -y
  ## wget
  if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt update -qq && sudo apt install wget -y && sleep 1 ; fi
  ## backports linux kernel (if needed)
  #sudo apt install -y -t $(lsb_release -cs)-backports linux-image-amd64
  ## NVIDIA graphic driver
  if lspci | grep -q NVIDIA; then
    sudo apt install linux-headers-amd64 -y && sleep 1
    sudo apt install nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree nvidia-detect nvtop -y
    echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1 nvidia-drm.fbdev=1"' | sudo tee /etc/default/grub.d/nvidia-modeset.cfg
    sleep 1 && sudo update-grub
    echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" | sudo tee /etc/modprobe.d/nvidia-options.conf
    sudo systemctl enable nvidia-suspend.service
    sudo systemctl enable nvidia-hibernate.service
    sudo systemctl enable nvidia-resume.service
  fi

# install apps (apt)

  ## not installing or installed by Debian by default: kwrite thunderbird python3 git kate kcalc partitionmanager libreoffice exfatprogs evolution evolution-ews elisa fsearch kdocker bash-completion plasma-firewall samba libavcodec-extra needrestart
  sudo apt install micro fastfetch default-jre default-jdk pkexec systemd-timesyncd ufw seahorse tree plymouth-themes solaar ttf-mscorefonts-installer krita krita-l10n inkscape kdenlive vlc -y
  
# install apps (source list)
  
  ## wine
  [ -f /etc/apt/sources.list.d/winehq-*.sources ] && sudo rm -f /etc/apt/sources.list.d/winehq-*.sources
  [ -f /etc/apt/keyrings/winehq-archive.key ] && sudo rm -f /etc/apt/keyrings/winehq-archive.key
  source /etc/os-release
  sudo dpkg --add-architecture i386
  sudo mkdir -pm755 /etc/apt/keyrings
  sudo wget -qNP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/$VERSION_CODENAME/winehq-$VERSION_CODENAME.sources
  wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --yes --dearmor --output /etc/apt/keyrings/winehq-archive.key -
  sudo apt update -qq && sudo apt install --install-recommends winehq-stable winetricks -y
  
  ## AnyDesk
  sudo apt update -qq && sudo apt install ca-certificates curl apt-transport-https -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
  sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc
  echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null
  sudo apt update -qq && sudo apt install anydesk -y
  [ -f /usr/share/applications/anydesk.desktop ] && sudo desktop-file-edit \
    --set-name 'AnyDesk' --set-key 'Name[en_US]' --set-value 'AnyDesk' --set-key 'Name[zh_CN]' --set-value '远程协助' \
    --set-comment 'Remote Control Tool' --set-key 'Comment[en_US]' --set-value 'Remote Control Tool' --set-key 'Comment[zh_CN]' --set-value '远程控制工具' \
    --set-generic-name 'Remote Desktop Software' --set-key 'GenericName[en_US]' --set-value 'Remote Desktop Software' --set-key 'GenericName[zh_CN]' --set-value '远程桌面协助工具' \
    --remove-key 'Categories' --add-category 'Network;' \
  /usr/share/applications/anydesk.desktop

# install apps (.deb)

  echo ""
  [ ! -d ./deb/ ] && mkdir ./deb/

  ## official redirecting links
  wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb && echo '"Google Chrome" deb package is downloaded.' && sleep 1
  
  ## self maintained redirecting links
  wget -q "https://www.dropbox.com/scl/fi/ohmiilwoep7ugvlpbov8i/freedownloadmanager.deb?rlkey=34tnbu8t68u0ffeeukcrqcq9v" -O freedownloadmanager.deb && echo '"Free Download Manager" deb package is downloaded.' && sleep 1
  wget -q "https://www.dropbox.com/scl/fi/f8z2xbm8zy1p9r2014bq1/eudic.deb?rlkey=3ce5bwl8ltg1xq1e7mqweelwb" -O eudic.deb && echo -e '"EuDic" deb package is downloaded.' && sleep 1
  wget -q "https://www.dropbox.com/scl/fi/x8gwrqsas8lqt2ckdyqc6/wechat.deb?rlkey=o0sg577sxwbwr3e68rgi2lney" -O wechat.deb && echo '"WeChat" deb package is downloaded.' && sleep 1
  
  ## install
  echo ""
  mv -f ./*.deb ./deb/ && sudo apt install -f -y --allow-downgrades ./deb/*.deb

# install apps (.zip)

  echo ""
  ## Etcher
  [ -d /opt/balenaEtcher/ ] && sudo rm -rf /opt/balenaEtcher/
  wget -q "https://www.dropbox.com/scl/fi/appud7mczsnhg05gekq6j/etcher.zip?rlkey=55amwyk81b8x4t4yqa0q758wp" -O etcher.zip && echo '"Balena Etcher" zip package is downloaded.' && sleep 1
  unzip -o -q ./etcher.zip && sleep 1 && rm -f ./etcher.zip
  [ ! -d /opt/balenaEtcher/ ] && sudo mkdir /opt/balenaEtcher/
  sudo cp -rf ./balenaEtcher-linux-*/* /opt/balenaEtcher/ && sleep 1
  [ ! -f /usr/share/applications/balena-etcher.desktop ] && sudo touch /usr/share/applications/balena-etcher.desktop
  sudo desktop-file-edit \
    --set-name 'Etcher' --set-key 'Name[en_US]' --set-value 'Etcher' --set-key 'Name[zh_CN]' --set-value 'Etcher刻录' \
    --set-comment 'Bootable USB Creator' --set-key 'Comment[en_US]' --set-value 'Bootable USB Creator' --set-key 'Comment[zh_CN]' --set-value '启动盘制作工具' \
    --set-generic-name 'A cross-platform tool to flash OS images onto SD cards and USB drives safely and easily' --set-key 'GenericName[en_US]' --set-value 'A cross-platform tool to flash OS images onto SD cards and USB drives safely and easily' --set-key 'GenericName[zh_CN]' --set-value '简单方便制作U盘启动盘' \
    --set-key 'Exec' --set-value '/opt/balenaEtcher/balena-etcher %U' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'StartupNotify' --set-value 'false' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'TerminalOptions' --set-value '' \
    --set-icon '/opt/icon/etcher.png' \
    --remove-key 'Categories' --add-category 'Utility;' \
  /usr/share/applications/balena-etcher.desktop
  sleep 1 && rm -rf ./balenaEtcher-linux-*/

# AppImages

  ## qView
  wget -q "https://www.dropbox.com/scl/fi/htussdjx59jobwssy2m2h/qview.AppImage?rlkey=x6cfgmvnpo9fh1wwoymoplw6v" -O qview.AppImage && echo '"qView" AppImage package is downloaded.' && sleep 1
  [ ! -d /opt/qView/ ] && sudo mkdir /opt/qView/
  sudo mv -f ./qview.AppImage /opt/qView/ && sleep 1
  sudo chmod +x /opt/qView/qview.AppImage
  [ ! -f /usr/share/applications/com.interversehq.qView.desktop ] && sudo touch /usr/share/applications/com.interversehq.qView.desktop
  sudo desktop-file-edit \
    --set-name 'qView' --set-key 'Name[en_US]' --set-value 'qView' --set-key 'Name[zh_CN]' --set-value '图片浏览器' \
    --set-comment 'Image Viewer' --set-key 'Comment[en_US]' --set-value 'Image Viewer' --set-key 'Comment[zh_CN]' --set-value '图片浏览工具' \
    --set-generic-name 'Practical and Minimal Image Viewer' --set-key 'GenericName[en_US]' --set-value 'Practical and Minimal Image Viewer' --set-key 'GenericName[zh_CN]' --set-value '简易图像查看器' \
    --set-key 'Exec' --set-value '/opt/qView/qview.AppImage' \
    --set-icon '/opt/icon/qview.png' \
    --set-key 'Type' --set-value 'Application' \
    --set-key 'StartupNotify' --set-value 'false' \
    --remove-key 'Categories' --add-category 'AudioVideo;' \
  /usr/share/applications/com.interversehq.qView.desktop

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

# install widgets

  ## Toggle Overview
  /usr/lib/x86_64-linux-gnu/libexec/kf6/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/2132554

# auto config

  ## Touchpad gestures
  echo ""
  ### Touchegg
  #[ ! -d ~/.config/touchegg/ ] && mkdir ~/.config/touchegg/
  #cp -f ./cfg/touchegg/touchegg.conf ~/.config/touchegg/
  ### Global (KWin-InputAction)
  sudo apt update -qq && sudo apt install git cmake g++ extra-cmake-modules qt6-tools-dev kwin-wayland kwin-dev libkf6configwidgets-dev gettext libkf6kcmutils-dev libyaml-cpp-dev libxkbcommon-dev pkg-config libevdev-dev -y
  [ ! -f InputActions.zip ] && wget -q "https://www.dropbox.com/scl/fi/q5totw0zok4cwvj0mjr0g/InputActions.zip?rlkey=2n5x30p3n2ghuirse7evjyavx" -O InputActions.zip && sleep 1
  unzip -o -q InputActions.zip -d ./ && sleep 1 && rm -f InputActions.zip && sleep 1
  mv ./InputActions-*/ ./InputActions/
  mkdir -p ./InputActions/build/
  cmake ./InputActions/ -B ./InputActions/build/ -DCMAKE_INSTALL_PREFIX=/usr -DINPUTACTIONS_BUILD_KWIN=ON
  make -C ./InputActions/build/ -j$(nproc)
  sudo make -C ./InputActions/build/ install
  cp -rf ./cfg/inputactions/ ~/.config/
  kwriteconfig6 --file ~/.config/kwinrc --group Plugins --key kwin_gesturesEnabled --type bool "true"
  rm -rf ./InputActions/
  ### Google Chrome
  [ -f /usr/share/applications/google-chrome.desktop ] && sudo desktop-file-edit \
      --set-key 'Exec' --set-value '/usr/bin/google-chrome-stable --ozone-platform=wayland --enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation --disable-features=WaylandWindowDecorations,WaylandWpColorManagerV1 %U' \
  /usr/share/applications/google-chrome.desktop #--enable-features=TouchpadOverscrollHistoryNavigation,PreferredOzonePlatform

  ## enable firewall
  sudo ufw enable

  ## chrome as default
  kwriteconfig6 --file ~/.config/kdeglobals --group General --key BrowserApplication --type string "google-chrome.desktop"

  ## time sync
  sudo timedatectl set-ntp true
  sudo timedatectl status
  
  ## Fastfetch
  [ ! -d ~/.config/fastfetch/ ] && mkdir ~/.config/fastfetch/
  wget -qO- https://raw.githubusercontent.com/fastfetch-cli/fastfetch/dev/presets/neofetch.jsonc > ~/.config/fastfetch/config.jsonc
  
  ## Etcher
  cp -rf ./cfg/balenaEtcher/ ~/.config/
  
  ## qView
  [ ! -d ~/.config/qView/ ] && mkdir ~/.config/qView/
  [ -d ~/.config/qView/ ] && rm -rf ~/.config/qView/*
  kwriteconfig6 --file ~/.config/qView/qView.conf --group General --key firstlaunch --type bool "true"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key updatenotifications --type bool "false"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key loopfoldersenabled --type bool "false"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key saverecents --type bool "false"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key titlebarmode --type string "2"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key bgcolor --type string "#dee0e2"
  kwriteconfig6 --file ~/.config/qView/qView.conf --group options --key bgcolorenabled --type bool "true"

  ## vlc
  cp -rf ./cfg/vlc/ ~/.config/
  [ -f /usr/share/applications/vlc.desktop ] && sudo desktop-file-edit --set-key 'StartupNotify' --set-value 'false' /usr/share/applications/vlc.desktop

  ## fcitx
  cp -f /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/org.fcitx.Fcitx5.desktop
  cp -rf ./cfg/fcitx5/* ~/.config/fcitx5/
  im-config -c -n fcitx5
  if grep -q "# zh_CN.UTF-8 UTF-8" /etc/locale.gen ; then sudo sed -i 's+# zh_CN.UTF-8 UTF-8+zh_CN.UTF-8 UTF-8+g' /etc/locale.gen ; fi
  sudo locale-gen
  echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
  kwriteconfig6 --file ~/.config/kwinrc --group Wayland --key InputMethod --type string "/usr/share/applications/org.fcitx.Fcitx5.desktop"

  ## wechat
  [ ! -f /etc/lsb-release ] && sudo touch /etc/lsb-release

  ## solaar
  [ ! -d ~/.config/solaar/ ] && mkdir ~/.config/solaar/
  cp -f ./cfg/solaar/rules.yaml ~/.config/solaar/
  sudo cp -f ./cfg/solaar/42-logitech-unify-permissions.rules /etc/udev/rules.d
  
  ## thunderbird
  #sudo cp -rf ./cfg/Thunderbird/ /opt/
  #sudo chmod +x /opt/Thunderbird/thunderbird.sh
  #[ -f /usr/share/applications/thunderbird.desktop ] && sudo desktop-file-edit \
  #  --set-name 'Thunderbird' --set-key 'Name[en_US]' --set-value 'Thunderbird' --set-key 'Name[zh_CN]' --set-value '邮箱' \
  #  --set-comment 'Email Client' --set-key 'Comment[en_US]' --set-value 'Email Client' --set-key 'Comment[zh_CN]' --set-value '邮件客户端' \
  #  --set-generic-name 'Read/Write Mail/News with Thunderbird' --set-key 'GenericName[en_US]' --set-value 'Read/Write Mail/News with Thunderbird' --set-key 'GenericName[zh_CN]' --set-value '阅读邮件或新闻' \
  #  --set-key 'Exec' --set-value 'bash /opt/Thunderbird/thunderbird.sh' \
  #  --remove-key 'Categories' --add-category 'Network;' \
  #/usr/share/applications/thunderbird.desktop
  ##cp -f /usr/share/applications/thunderbird.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/thunderbird.desktop

  ## apt modernize-sources
  #sudo apt modernize-sources -y #(for apt 3.0 and above; wait)
  
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
