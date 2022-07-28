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

# install java
sudo apt-get install default-jre default-jdk -y

# install apps (apt)
  # installed by Kubuntu by defauly: python3, git, kate, kcalc, partitionmanager
  sudo apt-get install kwrite krita seahorse evolution evolution-ews xdotool kdocker curl python3-pip -y
  #sudo apt-get install axel -y

# install apps (ppa)
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
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && echo "Google Chrome package is downloaded." && sleep 1
  wget -q https://zoom.us/client/latest/zoom_amd64.deb && echo "Zoom package is downloaded." && sleep 1
  wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && echo "Teamviewer package is downloaded." && sleep 1
  wget -q https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb && echo "Free Download Manager package is downloaded." && sleep 1

  ## direct links #_to_be_updated
  wget -q https://github.com/JoseExposito/touchegg/releases/download/2.0.14/touchegg_2.0.14_amd64.deb && echo "Touchegg package is downloaded." && sleep 1
  wget -q https://downloads.slack-edge.com/releases/linux/4.27.154/prod/x64/slack-desktop-4.27.154-amd64.deb && echo "Teamviewer package is downloaded." && sleep 1
  wget -q https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb && echo "Simplenote package is downloaded." && sleep 1
  wget -q https://github.com/jurplel/qView/releases/download/5.0/qview_5.0.1-focal4_amd64.deb && echo "qView package is downloaded." && sleep 1
  sleep 1 && mv -f ./*.deb ./deb/ && sudo apt-get install -f -y ./deb/*.deb

# install apps (licensed)
  ## expandrive
  sudo echo ""
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install ExpanDrive? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
        y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Installing ExpanDrive...${TEXT_RESET} \n" && sleep 1
                # download
                wget -q https://packages.expandrive.com/expandrive/pool/stable/e/ex/ExpanDrive_2022.7.1_amd64.deb
                # install
                sleep 1 && mv -f ./ExpanDrive*.deb ./deb/ && sudo apt-get install -f -y ./deb/ExpanDrive*.deb
                # notify end
                echo -e " \n${TEXT_GREEN}ExpanDrive installed!${TEXT_RESET} \n" && sleep 5;;
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}ExpanDrive not installed.${TEXT_RESET} \n" && sleep 5;;
  esac

# fix missings
sudo apt-get --fix-missing update && sudo apt-get install -y $(check-language-support) && sudo apt-get install -f -y

# auto config

  ## default open with Discovery
  #if grep -q "alias rm='bash ~/.rm.sh >/dev/null 2>&1'" ~/.bashrc ; then sed -i '/alias rm=/d' ~/.bashrc ; fi
  #mimeapps
  
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
                
        ## enpass
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Enpass? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please create or log in to your vault, then quit Enpass (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                /opt/enpass/Enpass
                # notify end
                echo -e " \n${TEXT_GREEN}Enpass configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Enpass not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## simplenote
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Simplenote? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please create or log in to your Simplenote account, then close Simplenote to continue.${TEXT_RESET} \n" && sleep 1
                /opt/Simplenote/simplenote --no-sandbox
                # notify end
                echo -e " \n${TEXT_GREEN}Simplenote configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Simplenote not configured.${TEXT_RESET} \n" && sleep 1;;
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
                echo -e " \n${TEXT_YELLOW}Please configure ${TEXT_GREEN}[themes/fonts/saving formats/toolbars]${TEXT_YELLOW} and then close LibreOffice to continue.${TEXT_RESET} \n" && sleep 1
                libreoffice
                # notify end
                echo -e " \n${TEXT_GREEN}LibreOffice configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}LibreOffice not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## inkscape
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Inkscape? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please configure and then close Inkscape to continue.${TEXT_RESET} \n" && sleep 1
                inkscape
                # notify end
                echo -e " \n${TEXT_GREEN}Inkscape configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Inkscape not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
                
        ## fdm
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Free Download Manager? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please configure and then quit Free Donwload Manager (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                /opt/freedownloadmanager/fdm
                # disable autostart
                [ -f ~/.config/autostart/FDM.desktop ] && rm ~/.config/autostart/FDM.desktop
                # notify end
                echo -e " \n${TEXT_GREEN}Free Download Manager configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Free Download Manager not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
                
        ## evolution
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Evolution (email client)? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please login to your email account(s) or restore previous Evolution backup, then close Evolution to continue.${TEXT_RESET} \n" && sleep 1
                evolution
                # ask whether set as autostart
                sudo echo ""
                read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Evolution to automatically start at login? [y/n/c]'$TEXT_RESET)"$' \n' choice
                case "$choice" in
                  y|Y ) sudo cp -rf ./cfg/Startup/ /opt/
                        sudo chmod +x /opt/Startup/evolution.sh
                        [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
                        echo -e "[Desktop Entry] \nExec=/opt/Startup/evolution.sh \nIcon=dialog-scripts \nName=evolution.sh \nPath= \nType=Application \nX-KDE-AutostartScript=true" > ~/.config/autostart/evolution.sh.desktop
                        sudo chmod +x ~/.config/autostart/evolution.sh.desktop
                        echo -e " \n${TEXT_GREEN}Evolution will autostart on next login.${TEXT_RESET} \n" && sleep 1;;
                   * )  echo -e " \n${TEXT_YELLOW}Evolution will not autostart.${TEXT_RESET} \n" && sleep 1;;
                esac
                sudo cp -f ./cfg/evolution/org.gnome.Evolution.desktop /usr/share/applications/
                # notify end
                echo -e " \n${TEXT_GREEN}Evolution (email client) configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Evolution (email client) not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
                
        ## slack
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Slack? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please login to your Slack workspace(s) and quit Slack (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                /usr/bin/slack
                # ask whether to set as autostart
                sudo echo ""
                read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Slack to automatically start at login? [y/n/c]'$TEXT_RESET)"$' \n' choice
                case "$choice" in
                  y|Y ) [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
                        echo -e "[Desktop Entry] \nCategories=GNOME;GTK;Network;InstantMessaging; \nComment=Slack Desktop \nExec=/usr/bin/slack -u %U \nGenericName=Slack Client for Linux \nIcon=/usr/share/pixmaps/slack.png \nMimeType=x-scheme-handler/slack; \nName=Slack \nNoDisplay=false \nPath= \nStartupNotify=true \nStartupWMClass=Slack \nTerminal=false \nTerminalOptions= \nType=Application \nX-KDE-SubstituteUID=false \nX-KDE-Username= \n" > ~/.config/autostart/slack.desktop
                        sudo chmod +x ~/.config/autostart/slack.desktop
                        echo -e " \n${TEXT_GREEN}Slack will autostart on next login.${TEXT_RESET} \n" && sleep 1;;
                   * )  echo -e " \n${TEXT_YELLOW}Slack will not autostart.${TEXT_RESET} \n" && sleep 1;;
                esac
                # Start Slack minimized
                sudo sed -i 's+Exec=/usr/bin/slack %U+Exec=/usr/bin/slack -u %U+g' /usr/share/applications/slack.desktop
                # notify end
                echo -e " \n${TEXT_GREEN}Slack configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Slack not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## zoom
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Zoom? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please sign in Zoom with SSO: ${TEXT_GREEN}[uchicago.zoom.us]${TEXT_YELLOW} or ${TEXT_GREEN}[illinois.zoom.us]${TEXT_YELLOW}. Then, please quit Zoom (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                /usr/bin/zoom
                # notify end
                echo -e " \n${TEXT_GREEN}Zoom configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Zoom not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## expandrive
        if [ -d /opt/ExpanDrive/ ]
        then
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure ExpanDrive? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please enter ${TEXT_GREEN}[quzc-mkaz-tbw1-44xq-itev]${TEXT_YELLOW} to activate ExpanDrive.Then, please login to your cloud drive account(s) and quit ExpanDrive (from system tray) to continue.${TEXT_RESET} \n" && sleep 1
                /opt/ExpanDrive/expandrive
                # ask whether set expandrive as autostart
                sudo echo ""
                read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like ExpanDrive to automatically start at login? [y/n/c]'$TEXT_RESET)"$' \n' choice
                case "$choice" in
                  y|Y ) [ ! -d ~/.config/autostart/ ] && mkdir ~/.config/autostart/
                        echo -e '[Desktop Entry] \nType=Application \nVersion=1.0 \nName=expandrive --autorun \nComment=expandrive --autorunstartup script \nExec=/opt/ExpanDrive/expandrive --autorun \nStartupNotify=false \nTerminal=false' > ~/.config/autostart/'expandrive --autorun.desktop'
                        sudo chmod +x ~/.config/autostart/'expandrive --autorun.desktop'
                        echo -e " \n${TEXT_GREEN}Evolution will autostart on next login.${TEXT_RESET} \n" && sleep 1;;
                   * )  echo -e " \n${TEXT_YELLOW}Evolution will not autostart.${TEXT_RESET} \n" && sleep 1;;
                esac
                # notify end
                echo -e " \n${TEXT_GREEN}ExpanDrive configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}ExpanDrive not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        fi
        ###>>>sed-i-d-end-2
        
        # notify end
        echo -e " \n${TEXT_GREEN}Apt installed apps Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Apt installed apps not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac
###>>>sed-i-d-end-1

# cleanup
sudo apt-get remove kate thunderbird krdc konversation ktorrent skanlite usb-creator-kde kmahjongg kmines kpat ksudoku -y
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./deb/

# notify end
echo -e " \n${TEXT_GREEN}Deb pacakges installed!${TEXT_RESET} \n" && sleep 5

# mark setup.sh
sed -i 's+bash ./inst/0_deb.sh+#bash ./inst/0_deb.sh+g' ~/.setup_cache/setup.sh
