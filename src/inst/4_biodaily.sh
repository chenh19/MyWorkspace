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
        sudo apt-get update -qq && sudo apt-get upgrade -y
        
        # install PyMOL/FastQC/Meld
        [ ! -d ~/igv ] && mkdir ~/igv/
        sudo apt-get install pymol fastqc clustalx meld -y

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
        sudo apt-get update -qq && sudo apt-get install zotero libreoffice-java-common -y
        sudo kwriteconfig5 --file /usr/share/applications/zotero.desktop --group "Desktop Entry" --key Comment "Bibliography Manager"

        # install IGV
        wget -q https://data.broadinstitute.org/igv/projects/downloads/2.17/IGV_Linux_2.17.4_WithJava.zip -O ./igv.zip && sleep 1 #_to_be_updated
        unzip -o -q ./igv.zip && sleep 1 && rm -f ./igv.zip
        [ ! -d /opt/igv/ ] && sudo mkdir /opt/igv/
        sudo cp -rf ./IGV_Linux_*/* /opt/igv/ && sleep 1
        [ ! -f /usr/share/applications/igv.desktop ] && sudo touch /usr/share/applications/igv.desktop
        sudo desktop-file-edit \
            --set-name 'IGV' --set-key 'Name[en_US]' --set-value 'IGV' --set-key 'Name[zh_CN]' --set-value 'IGV' \
            --set-generic-name 'Integrative Genomics Viewer' --set-key 'GenericName[en_US]' --set-value 'Integrative Genomics Viewer' --set-key 'GenericName[zh_CN]' --set-value '基因组浏览器' \
            --set-comment 'High-performance Viewer for Large Genomics Datasets' --set-key 'Comment[en_US]' --set-value 'High-performance Viewer for Large Genomics Datasets' --set-key 'Comment[zh_CN]' --set-value '高性能的基因组可视化工具' \
            --set-key 'Exec' --set-value '/opt/igv/igv_hidpi.sh' \
            --set-icon '/opt/icon/igv.png' \
            --set-key 'StartupNotify' --set-value 'true' \
            --set-key 'Terminal' --set-value 'false' \
            --set-key 'Type' --set-value 'Application' \
            --remove-key 'Categories' --add-category 'Science;' \
        /usr/share/applications/igv.desktop
        rm -rf ./IGV_Linux_*/

        # ask whether to download genomes for IGV
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to download Hosted Genomes for offline use of IGV (this might take some time)? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) bash <(wget -qO- https://raw.githubusercontent.com/chenh19/igv_genomes/main/download.sh);;
          * )   ;;
        esac
        
        # cleanup
        sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}Daily biological tools installed!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Daily biological tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/4_biodaily.sh+#bash ./inst/4_biodaily.sh+g' ~/.setup_cache/setup.sh
