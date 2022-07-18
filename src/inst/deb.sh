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

# install apps (apt)
  # installed by Kubuntu by defauly: python3, git, kate, kcalc, partitionmanager
  sudo apt-get install kwrite krita seahorse evolution evolution-ews xdotool kdocker curl python3-pip -y
  #sudo apt-get install axel -y

# install apps (ppa)
  ## Inkscape
  sudo add-apt-repository ppa:inkscape.dev/stable
  sudo apt-get update && sudo apt-get install inkscape -y

# install apps (source list)
  ## enpass
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc
  sudo apt-get update && sudo apt-get install enpass -y

# install apps (downloaded)
  [ ! -d ./deb/ ] && mkdir ./deb/
  echo -e " \n${TEXT_YELLOW}Downloading deb packages...${TEXT_RESET} \n" && sleep 1
  
  ## redirecting links
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  wget -q https://zoom.us/client/latest/zoom_amd64.deb
  wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
  wget -q https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb

  ## direct links
  wget -q https://github.com/JoseExposito/touchegg/releases/download/2.0.14/touchegg_2.0.14_amd64.deb #_to_be_updated
  wget -q https://downloads.slack-edge.com/releases/linux/4.27.154/prod/x64/slack-desktop-4.27.154-amd64.deb #_to_be_updated
  wget -q https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb #_to_be_updated
  wget -q https://github.com/jurplel/qView/releases/download/5.0/qview_5.0.1-focal4_amd64.deb #_to_be_updated
  sleep 1 && mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./deb/*.deb

# fix missings
sudo apt-get --fix-missing update && sudo apt-get install -y $(check-language-support) && sudo apt-get install -f -y

# auto config

  ## default open with Discovery
  #if grep -q "alias rm='bash ~/.rm.sh >/dev/null 2>&1'" ~/.bashrc ; then sed -i '/alias rm=/d' ~/.bashrc ; fi
  #mimeapps

  ## Start Slack minimized
  sudo sed -i 's+Exec=/usr/bin/slack %U+Exec=/usr/bin/slack -u %U+g' /usr/share/applications/slack.desktop
  # right click on the Slack icon on the bottom right, click "Check for Updates..." to open login interface, check "Launch on Login" if preferred

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
  kwriteconfig5 --file ~/.config/qView/qView.conf --group options --key titlebarmode "2"

###>>>sed-i-d-start-1
# manual config
# aske whether to configure apt installed apps manually
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure apt installed apps manually now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # ask for individual apps
        
        ###>>>sed-i-d-start-2
        ## fdm
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Free Download Manager? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please config and then close Free Donwload Manager to continue.${TEXT_RESET} \n" && sleep 1
                /opt/freedownloadmanager/fdm
                # notify end
                echo -e " \n${TEXT_GREEN}Free Download Manager configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Free Download Manager not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## inkscape
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Inkscape? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please config and then close Inkscape to continue.${TEXT_RESET} \n" && sleep 1
                inkscape
                # notify end
                echo -e " \n${TEXT_GREEN}Inkscape configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Inkscape not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## qview
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure qView? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                  # do not check update notification when first open 
                  echo -e " \n${TEXT_YELLOW}Please close qViw to continue.${TEXT_RESET} \n" && sleep 1
                  qview
                # notify end
                echo -e " \n${TEXT_GREEN}qView configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}qView not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## libreoffice
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure LibreOffice? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please config ${TEXT_GREEN}[themes/fonts/saving formats/toolbars]${TEXT_YELLOW} and then close LibreOffice to continue.${TEXT_RESET} \n" && sleep 1
                libreoffice
                # notify end
                echo -e " \n${TEXT_GREEN}LibreOffice configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}LibreOffice not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## chrome
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Google Chrome? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please login to your Google account and then close Chrome to continue.${TEXT_RESET} \n" && sleep 1
                /usr/bin/google-chrome-stable
                # notify end
                echo -e " \n${TEXT_GREEN}Google Chrome configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Google Chrome not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## evolution
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Evolution (email client)? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                # restore backup
                # ask whether set evolution as autostart
                # notify end
                echo -e " \n${TEXT_GREEN}Evolution (email client) onfigured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Evolution (email client) not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## expandrive
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure ExpanDrive? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                # ask whether set evolution as autostart
                echo -e '[Desktop Entry] \nType=Application \nVersion=1.0 \nName=expandrive --autorun \nComment=expandrive --autorunstartup script \nExec=/opt/ExpanDrive/expandrive --autorun \nStartupNotify=false \nTerminal=false' > '~/.config/autostart/expandrive --autorun.desktop'
                # notify end
                echo -e " \n${TEXT_GREEN}ExpanDrive configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}ExpanDrive not configured.${TEXT_RESET} \n" && sleep 1;;
        esac        
        
        ## slack
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Slack? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                #config
                /usr/bin/slack
                # ask whether to set as autostart
                # notify end
                echo -e " \n${TEXT_GREEN}Slack configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Slack not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        ###>>>sed-i-d-end-2
        
        # notify end
        echo -e " \n${TEXT_GREEN}Apt installed apps Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Apt installed apps Not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac
###>>>sed-i-d-end-1

# cleanup
sudo apt-get remove thunderbird krdc konversation ktorrent skanlite usb-creator-kde kmahjongg kmines kpat ksudoku -y
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./deb/

# notify end
echo -e " \n${TEXT_GREEN}Deb pacakges installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/deb.sh+#bash ./src/deb.sh+g' ~/.setup_cache/setup.sh
