#!/usr/bin/env bash
# This script intsalls additional tools

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# ask whether to install additional tools
read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}'Would you like to install additional tools? [y/n/c]'${TEXT_RESET})"$'\n' choice
case "$choice" in
  y|Y ) # notify start
        echo -e "\n${TEXT_YELLOW}Installing additional tools...${TEXT_RESET}\n" && sleep 1
        sudo apt update -qq && sudo apt upgrade -y
        
        # install apps (source list)
        
          ## onedrive
          # https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md#distribution-debian-13
          wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_13/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
          echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_13/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list
          sudo apt update -qq && sudo apt install --no-install-recommends --no-install-suggests onedrive -y
          [ -f /usr/share/keyrings/obs-onedrive.gpg ] && sudo rm -f /usr/share/keyrings/obs-onedrive.gpg
          [ -f /etc/apt/sources.list.d/onedrive.list ] && sudo rm -f /etc/apt/sources.list.d/onedrive.list
          
          ## enpass
          #echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list >/dev/null 2>&1
          #wget -qO- "https://apt.enpass.io/keys/enpass-linux.key" | sudo tee /etc/apt/trusted.gpg.d/enpass.asc >/dev/null 2>&1
          #sudo apt update -qq && sudo apt install enpass -y
          [ -f /etc/apt/sources.list.d/enpass.list ] && sudo rm -f /etc/apt/sources.list.d/enpass.list
          [ -f /etc/apt/trusted.gpg.d/enpass.asc ] && sudo rm -f /etc/apt/trusted.gpg.d/enpass.asc
          [ ! -d ~/Documents/Enpass/ ] && mkdir ~/Documents/Enpass/
        
          ## resilio sync
          echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list >/dev/null 2>&1
          wget -qO- https://linux-packages.resilio.com/resilio-sync/key.asc | sudo tee /etc/apt/trusted.gpg.d/resilio-sync.asc > /dev/null 2>&1
          sudo apt update -qq && sudo apt install resilio-sync -y
          sudo systemctl disable resilio-sync
          sudo kwriteconfig6 --file /usr/lib/systemd/user/resilio-sync.service --group Install --key WantedBy --type string "default.target"
          systemctl --user enable resilio-sync
          systemctl --user start resilio-sync
          [ ! -d ~/Sync/ ] && mkdir ~/Sync/ && kwriteconfig6 --file ~/Sync/.directory --group "Desktop Entry" --key Icon --type string "folder-cloud"
          [ -f /etc/apt/sources.list.d/resilio-sync.list ] && sudo rm -f /etc/apt/sources.list.d/resilio-sync.list
          [ -f /etc/apt/trusted.gpg.d/resilio-sync.asc* ] && sudo rm -f /etc/apt/trusted.gpg.d/resilio-sync.asc*
          
          ## virtualbox
          #[ -f /etc/apt/sources.list.d/virtualbox.list ] && sudo rm -f /etc/apt/sources.list.d/virtualbox.list
          #[ -f /usr/share/keyrings/oracle-virtualbox-2016.gpg ] && sudo rm -f /usr/share/keyrings/oracle-virtualbox-2016.gpg
          #source /etc/os-release
          #echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $VERSION_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
          #wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --dearmor --output /usr/share/keyrings/oracle-virtualbox-2016.gpg -
          #wget -qO- https://www.dropbox.com/scl/fi/og4of00530879jak03nzp/oracle_vbox_2016.asc?rlkey=mjn9tj78kqix7uujp2hdaava6 | sudo gpg --yes --dearmor --output /usr/share/keyrings/oracle-virtualbox-2016.gpg - # to update
          #sleep 1 && sudo apt update -qq && sudo apt install virtualbox-7.1 -y
          #[ ! -d ~/VirtualBox\ VMs/ ] && mkdir ~/VirtualBox\ VMs/
        
        # install apps (.deb)
        
          echo ""
          [ ! -d ./deb/ ] && mkdir ./deb/
        
          ## official redirecting links
          wget -q "https://zoom.us/client/latest/zoom_amd64.deb" -O zoom.deb && echo '"Zoom" deb package is downloaded.' && sleep 1
          #wget -q "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb" -O teamviewer.deb && echo '"Teamviewer" deb package is downloaded.' && sleep 1
          #wget -q "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" -O onlyoffice.deb && echo '"OnlyOffice" deb package is downloaded.' && sleep 1
          
          ## self maintained redirecting links
          wget -q "https://www.dropbox.com/scl/fi/c8l8p9d570rrtlthbekvz/enpass.deb?rlkey=onpnnrn80njld2n48dk2rerfe" -O enpass.deb && echo '"Enpass" deb package is downloaded.' && sleep 1
          wget -q "https://www.dropbox.com/scl/fi/d55hac9aiwzzc7aq8ky72/simplenote.deb?rlkey=p0lg6vdsefoi16pc04sg1r1n6" -O simplenote.deb && echo '"Simplenote" deb package is downloaded.' && sleep 1
          wget -q "https://www.dropbox.com/scl/fi/nhow2orfr13h2sab1eulj/4kvideodownloader.deb?rlkey=s3a7aj6z6i1bgjjng7uwh5spg" -O 4kvideodownloader.deb && echo -e '"4K Video Downloader+" deb package is downloaded.' && sleep 1
          #wget -q "https://www.dropbox.com/scl/fi/s0aopqvbu9pz4jxfo23n4/slack.deb?rlkey=2errjlsb9uxl0hkjgfezkczab" -O slack.deb && echo '"Slack" deb package is downloaded.' && sleep 1
          
          ## install
          echo ""
          mv -f ./*.deb ./deb/ && sudo apt install -f -y --allow-downgrades ./deb/*.deb && sleep 1
          rm -rf ./deb/
        
        # install apps (.zip)
        
          echo ""
          ## iOpenPod
          [ ! -f iOpenPod-Linux.tar.gz ] && wget -q "https://www.dropbox.com/scl/fi/dik3xnklvjdooamhdvv72/iOpenPod-Linux.tar.gz?rlkey=o38bsfrq59pb8tlozfxyvmkiy" -O iOpenPod-Linux.tar.gz && sleep 1
          [ ! -f ffmpeg.tar.xz ] && wget -q "https://www.dropbox.com/scl/fi/w37apnsoxbqxfl8cj96r9/ffmpeg.tar.xz?rlkey=ktgu63ye13rmq4o4kw5zeqo86" -O ffmpeg.tar.xz && sleep 1
          [ ! -f fpcalc.tar.gz ] && wget -q "https://www.dropbox.com/scl/fi/6o7siid927tkh8rqowslh/fpcalc.tar.gz?rlkey=ekkx4unj1vwhhy23dq9urzyn7" -O fpcalc.tar.gz && sleep 1
          tar -xzf iOpenPod-Linux.tar.gz && sleep 1 && rm -f iOpenPod-Linux.tar.gz && sleep 1
          tar -xJf ffmpeg.tar.xz && sleep 1 && rm -f ffmpeg.tar.xz && sleep 1
          mv ./ffmpeg-*/ ./ffmpeg/ && sleep 1
          tar -xzf fpcalc.tar.gz && sleep 1 && rm -f fpcalc.tar.gz && sleep 1
          mv ./chromaprint-fpcalc-*/ ./fpcalc/ && sleep 1
          cp -f ./ffmpeg/bin/ffmpeg ./fpcalc/fpcalc ./iOpenPod/ && sleep 1
          rm -rf ./ffmpeg/ ./fpcalc/ && sleep 1
          sudo cp -f ./iOpenPod/_internal/assets/icons/icon-256.png /opt/icon/iopenpod.png && sleep 1
          sudo cp -rf ./iOpenPod/ /opt/ && sleep 1
          rm -rf ./iOpenPod/
          ## config
          mkdir -p ~/.config/iOpenPod/
          echo -e '{\n  "ffmpeg_path": "/opt/iOpenPod/ffmpeg",\n  "fpcalc_path": "/opt/iOpenPod/fpcalc",\n  "lossy_quality": "high",\n  "backup_before_sync": false\n}' > ~/.config/iOpenPod/settings.json
          ## shortcut
          [ ! -f /usr/share/applications/iopenpod.desktop ] && sudo touch /usr/share/applications/iopenpod.desktop
          sudo desktop-file-edit \
            --set-name 'iOpenPod' --set-key 'Name[en_US]' --set-value 'iOpenPod' --set-key 'Name[zh_CN]' --set-value 'iOpenPod' \
            --set-comment 'Open-source iPod Sync Tool' --set-key 'Comment[en_US]' --set-value 'Open-source iPod Sync Tool' --set-key 'Comment[zh_CN]' --set-value '开源iPod同步工具' \
            --set-generic-name 'Manage your iPod without iTunes' --set-key 'GenericName[en_US]' --set-value 'Manage your iPod without iTunes' --set-key 'GenericName[zh_CN]' --set-value '告别 iTunes，重新掌控你的 iPod' \
            --set-key 'Exec' --set-value '/opt/iOpenPod/iOpenPod' \
            --set-icon '/opt/icon/iopenpod.png' \
            --set-key 'StartupNotify' --set-value 'true' \
            --set-key 'Terminal' --set-value 'false' \
            --set-key 'Type' --set-value 'Application' \
            --remove-key 'Categories' --add-category 'AudioVideo;' \
          /usr/share/applications/iopenpod.desktop
        
        # AppImages
        
          echo ""
          ## OneDriveGUI
          wget -q "https://www.dropbox.com/scl/fi/l4s04hw0z0y9su54fzewe/onedrivegui.AppImage?rlkey=tmwf6y38kpovdkl5wvy7pmczk" -O onedrivegui.AppImage && echo '"OneDriveGUI" AppImage package is downloaded.' && sleep 1
          [ ! -d /opt/onedrivegui/ ] && sudo mkdir /opt/onedrivegui/
          sudo mv -f ./onedrivegui.AppImage /opt/onedrivegui/ && sleep 1
          sudo chmod +x /opt/onedrivegui/onedrivegui.AppImage
          [ ! -f /usr/share/applications/onedrivegui.desktop ] && sudo touch /usr/share/applications/onedrivegui.desktop
          sudo desktop-file-edit \
            --set-name 'OneDrive' --set-key 'Name[en_US]' --set-value 'OneDrive' --set-key 'Name[zh_CN]' --set-value 'OneDrive' \
            --set-comment 'Cloud Storage' --set-key 'Comment[en_US]' --set-value 'Cloud Storage' --set-key 'Comment[zh_CN]' --set-value '云储存空间' \
            --set-generic-name 'OneDrive Client' --set-key 'GenericName[en_US]' --set-value 'OneDrive Client' --set-key 'GenericName[zh_CN]' --set-value 'OneDrive 客户端' \
            --set-key 'Exec' --set-value '/opt/onedrivegui/onedrivegui.AppImage' \
            --set-icon '/opt/icon/onedrive.png' \
            --set-key 'Type' --set-value 'Application' \
            --remove-key 'Categories' --add-category 'Utility;' \
          /usr/share/applications/onedrivegui.desktop
        
        # auto config
        
          ## OneDriveGUI
          cp -rf ./cfg/onedrive-gui/ ~/.config/
          #cp -f /usr/share/applications/onedrivegui.desktop ~/.config/autostart/ && sudo chmod +x ~/.config/autostart/onedrivegui.desktop
          #echo -e "[Desktop Entry]\nIcon=/opt/icon/onedrive.png\nName=OneDrive\nType=Link\nURL[\$e]=file:$HOME/OneDrive/" > ~/Desktop/onedrive.desktop
          
          ## zoom auto scaling
          kwriteconfig6 --file ~/.config/zoomus.conf --group General --key autoScale --type bool "false"
          
          ## 4k video downloader+
          [ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit \
              --set-icon '4kvideodownloaderplus' \
          /usr/share/applications/4kvideodownloaderplus.desktop
          
          ## teamviewer
          #[ ! -d ~/.config/teamviewer/ ] && mkdir ~/.config/teamviewer/
          #[ -d ~/.config/teamviewer/ ] && rm -rf ~/.config/teamviewer/*
          #echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0" > ~/.config/teamviewer/client.conf
          
          ## apt modernize-sources
          #sudo apt modernize-sources -y #(for apt 3.0 and above; wait)
        
        # cleanup
        sudo apt update -qq && sudo apt autoremove -y && sudo apt clean
        ;;
        
  * ) # notify cancellation
        echo -e "\n${TEXT_YELLOW}Additional tools not installed.${TEXT_RESET}\n" && sleep 1;;
        
esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_addtools.sh+#bash ./inst/1_addtools.sh+g' ~/.setup_cache/setup.sh
