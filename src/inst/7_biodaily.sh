#!/bin/bash
# This script intsalls daily biological tools (SnapGene, PyMOL, etc)

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install SnapGene/IGV/PyMOL
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install daily biological tools, such as SnapGene and PyMOL? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing daily biological tools (SnapGene/IGV/PyMOL/FastQC)...${TEXT_RESET} \n" && sleep 1
        sudo apt-get update && sudo apt-get upgrade -y
        
        # install IGV/PyMOL/FastQC/Meld
        [ ! -d ~/igv ] && mkdir ~/igv/
        sudo apt-get install igv pymol fastqc meld -y
                
        # install Snapgene-viewer
        [ ! -d ./snapgene/ ] && mkdir ./snapgene/
        echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
        sleep 3 && sudo apt-get install ttf-mscorefonts-installer -y && sleep 3
        wget -q 'https://www.snapgene.com/local/targets/download.php?variant=viewer&os=linux_deb&majorRelease=latest&minorRelease=latest' -O snapgene.deb && echo '"SnapGene" deb package is downloaded.' && sleep 1
        mv -f ./snapgene.deb ./snapgene/ && sudo dpkg -i ./snapgene/snapgene.deb
        sudo apt-get -f -y install
        sudo sed -i 's+Exec=/opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+Exec=XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+g' /usr/share/applications/snapgene-viewer.desktop
        rm -rf ./snapgene/
        
        # install Zotero
        wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
        sudo apt-get update && sudo apt-get install zotero libreoffice-java-common -y
        sudo kwriteconfig5 --file /usr/share/applications/zotero.desktop --group "Desktop Entry" --key Comment "Bibliography Manager"
        
        ## install Tropy
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Tropy? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Installing Tropy...${TEXT_RESET} \n" && sleep 1
                # install
                [ ! -d ~/.setup_cache/tropy/ ] && mkdir ~/.setup_cache/tropy/
                wget -q https://github.com/tropy/tropy/releases/download/v1.12.0/tropy-1.12.0-x64.tar.bz2 -O tropy.tar.bz2 && echo '"Tropy" tar package is downloaded.' && sleep 5 #_to_be_updated
                tar -xjf tropy.tar.bz2 -C ./tropy/ && sleep 1 && rm -f tropy.tar.bz2
                cp -f ./tropy/resources/icons/hicolor/1024x1024/apps/tropy.png ./tropy/ && sleep 1
                sudo cp -rf ./tropy/ /opt/ && sleep 1 && sudo chmod +x /opt/tropy/tropy
                echo -e "[Desktop Entry]\nCategories=Graphics;\nComment=Image Manager\nExec=/opt/tropy/tropy\nGenericName=\nIcon=/opt/tropy/tropy.png\nMimeType=\nName=Tropy\nPath=\nStartupNotify=true\nTerminal=false\nTerminalOptions=\nType=Application" > ./tropy.desktop
                sudo cp -f ./tropy.desktop /usr/share/applications/ && sleep 5
                rm -rf ./tropy/ ./tropy.desktop
                # notify end
                echo -e " \n${TEXT_GREEN}Tropy installed.${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Tropy not installed.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        # Fluent Reader
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Fluent Reader? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Installing Fluent Reader...${TEXT_RESET} \n" && sleep 1
                # install
                sudo flatpak install -y --noninteractive flathub me.hyliu.fluentreader
                [ ! -f ~/.local/share/applications/me.hyliu.fluentreader.desktop ] && touch ~/.local/share/applications/me.hyliu.fluentreader.desktop
                desktop-file-edit \
                  --set-name 'Fluent Reader' --set-key 'Name[en_US]' --set-value 'Fluent Reader' --set-key 'Name[zh_CN]' --set-value 'RSS阅读器' \
                  --set-generic-name 'Modern RSS reader' --set-key 'GenericName[en_US]' --set-value 'Modern RSS reader' --set-key 'GenericName[zh_CN]' --set-value '浏览订阅信息' \
                  --set-comment 'Read RSS Feeds' --set-key 'Comment[en_US]' --set-value 'Read RSS Feeds' --set-key 'Comment[zh_CN]' --set-value '阅读RSS订阅' \
                  --set-key 'Exec' --set-value '/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=start-fluent-reader --file-forwarding me.hyliu.fluentreader @@u %U @@' \
                  --set-icon 'me.hyliu.fluentreader' \
                  --set-key 'NoDisplay' --set-value 'false' \
                  --set-key 'Path' --set-value '' \
                  --set-key 'StartupNotify' --set-value 'true' \
                  --set-key 'Terminal' --set-value 'false' \
                  --set-key 'TerminalOptions' --set-value '' \
                  --set-key 'Type' --set-value 'Application' \
                  --set-key 'X-Flatpak' --set-value 'me.hyliu.fluentreader' \
                  --set-key 'X-KDE-FormFactor' --set-value 'desktop;tablet;handset;' \
                  --set-key 'X-KDE-SubstituteUID' --set-value 'false' \
                  --set-key 'X-KDE-Username' --set-value '' \
                  --remove-key 'Categories' --add-category 'Science;' \
                ~/.local/share/applications/me.hyliu.fluentreader.desktop
                # notify end
                echo -e " \n${TEXT_GREEN}Fluent Reader installed.${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Fluent Reader not installed.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        # University VPN
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install University VPN? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                sudo echo ""
                echo -e "${TEXT_YELLOW}Installing University VPN...${TEXT_RESET} \n" && sleep 1
                # install University VPN
                wget -q https://www.dropbox.com/s/o4a5so0at8tev76/anyconnect.zip?dl=0 && echo '"Cisco Anyconnet client" deb package is downloaded.' && sleep 5 #_to_be_updated
                unzip -o -q anyconnect.zip?dl=0 && sleep 1 && rm -f anyconnect.zip?dl=0 && sleep 1
                cd ./anyconnect-linux64-4.10.04065/vpn
                sudo bash vpn_install.sh && sleep 5
                cd ~/.setup_cache/
                rm -rf ./anyconnect-linux64-4.10.04065/
                # notify end
                echo -e " \n${TEXT_GREEN}University VPN installed!${TEXT_RESET} \n" && sleep 5;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}University VPN not installed.${TEXT_RESET} \n" && sleep 5;;
        esac
        
        # notify end
        echo -e " \n${TEXT_GREEN}Daily biological tools installed!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Daily biological tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac

###>>>sed-i-d-start-1
# manual config
if [ ! -z "$(dpkg -l | grep snapgene)" ]
then

# aske whether to configure daily biological software manually
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure daily biological software now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # ask for individual apps
        
        ###>>>sed-i-d-start-2
        ## zotero
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Zotero? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please log in to Zotero acount, set default PDF viewer (/bin/okular), and enable LibreOffice plugin. Then, please close Zotero to continue.${TEXT_RESET} \n" && sleep 1
                /usr/lib/zotero/zotero
                # notify end
                echo -e " \n${TEXT_GREEN}Zotero configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}Zotero not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## snapgene
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure SnapGene Viewer? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please configure and then close SnapGene to continue.${TEXT_RESET} \n" && sleep 1
                XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh
                # notify end
                echo -e " \n${TEXT_GREEN}SnapGene Viewer configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}SnapGene Viewer not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        
        ## university vpn
        if [ -f /opt/cisco/anyconnect/bin/vpnui ] 
        then
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure University VPN? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please connect to ${TEXT_GREEN}[vpn.uchicago.edu]${TEXT_YELLOW} or ${TEXT_GREEN}[vpn.illinois.edu]${TEXT_YELLOW} and disconnect, then close the VPN client to continue.${TEXT_RESET} \n" && sleep 1
                /opt/cisco/anyconnect/bin/vpnui
                # notify end
                echo -e " \n${TEXT_GREEN}University VPN configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}University VPN not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        fi
        ###>>>sed-i-d-end-2
        
        # notify end
        echo -e " \n${TEXT_GREEN}Daily biological software Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Daily biological software not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac

fi
###>>>sed-i-d-end-1

# mark setup.sh
sed -i 's+bash ./inst/7_biodaily.sh+#bash ./inst/7_biodaily.sh+g' ~/.setup_cache/setup.sh
