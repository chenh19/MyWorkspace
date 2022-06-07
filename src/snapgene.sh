#!/bin/bash
# This script does xxx

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install SnapGene/IGV/PyMOL
read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}'Would you like to install SnapGene, IGV, and PyMOL? [y/n/c]'${TEXT_RESET})"$(echo -e ' \n') choice
case "$choice" in
  y|Y ) # notify start;
        sudo echo "";
        echo -e "${TEXT_YELLOW}Installing SnapGene, IGV, and PyMOL...${TEXT_RESET} \n" && sleep 1;

        # install IGV and PyMOL;
        sudo apt-get update && sudo apt-get install igv pymol -y;

        # install snapgene font;
        echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;
        sudo apt-get install ttf-mscorefonts-installer -y;

        # install snapgene;
        [ ! -d ./snapgene/ ] && mkdir ./snapgene/;
        wget -q 'https://www.snapgene.com/local/targets/download.php?variant=viewer&os=linux_deb&majorRelease=latest&minorRelease=latest' -O snapgene.deb;
        wget -q 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1l-1ubuntu1_amd64.deb';
        mv -f ./*.deb ./snapgene/ && sudo dpkg -i ./snapgene/*.deb;
        sudo apt-get -f -y install;

        # configure;
        sudo sed -i 's+Exec=/opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+Exec=XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+g' /usr/share/applications/snapgene-viewer.desktop;

        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean;
        rm -rf ./snapgene/;

        # notify end
        echo -e " \n${TEXT_GREEN}SnapGene, IGV, and PyMOL installed!${TEXT_RESET} \n" && sleep 5;;

  n|N ) # notify cancellation;
        echo -e " \n${TEXT_GREEN}SnapGene, IGV, and PyMOL is not installed.${TEXT_RESET} \n" && sleep 5;;
  
  * ) # notify cancellation;
        echo -e " \n${TEXT_GREEN}SnapGene, IGV, and PyMOL is not installed.${TEXT_RESET} \n" && sleep 5;;
        
esac
