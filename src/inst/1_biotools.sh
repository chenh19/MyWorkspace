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
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install bioinformatics tools? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing bioinformatics tools...${TEXT_RESET} \n" && sleep 1
        sudo apt-get update -qq && sudo apt-get upgrade -y
        if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt-get update -qq && sudo apt-get install wget -y && sleep 1 ; fi
        [ ! -d ~/Developing/ ] && mkdir ~/Developing/ && kwriteconfig5 --file ~/Developing/.directory --group "Desktop Entry" --key Icon "folder-script"
        
        ## install PyMOL/FastQC/Meld
        [ ! -d ~/igv ] && mkdir ~/igv/
        sudo apt-get install pymol fastqc clustalx meld -y

        ## install Snapgene-viewer
        [ ! -d ./snapgene/ ] && mkdir ./snapgene/
        echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
        sleep 3 && sudo apt-get install ttf-mscorefonts-installer -y && sleep 3
        wget -q "https://www.snapgene.com/local/targets/download.php?variant=viewer&os=linux_deb&majorRelease=latest&minorRelease=latest" -O snapgene.deb && echo '"SnapGene" deb package is downloaded.' && sleep 1
        mv -f ./snapgene.deb ./snapgene/ && sudo dpkg -i ./snapgene/snapgene.deb
        sudo apt-get -f -y install
        sudo sed -i 's+Exec=/opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+Exec=XDG_CURRENT_DESKTOP=GNOME /opt/gslbiotech/snapgene-viewer/snapgene-viewer.sh %U+g' /usr/share/applications/snapgene-viewer.desktop
        rm -rf ./snapgene/
        
        ## install Zotero
        wget -qO- "https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh" | sudo bash
        sudo apt-get update -qq && sudo apt-get install zotero libreoffice-java-common -y
        sudo kwriteconfig5 --file /usr/share/applications/zotero.desktop --group "Desktop Entry" --key Comment "Bibliography Manager"

        ## install IGV
        [ -d /opt/igv/ ] && sudo rm -rf /opt/igv/
        wget -q "https://www.dropbox.com/scl/fi/7fs5h4p2i0tckkvqsa3od/igv.zip?rlkey=nb6aopovnu18ssmvri0c6alhz" -O igv.zip && sleep 1
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

        ## install R
        ### install dependencies
        sudo apt-get install default-jre default-jdk cmake pandoc libcurl4-openssl-dev libssl-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjpeg-dev libtiff-dev libtiff5-dev libgit2-dev libglpk-dev libnlopt-dev libgeos-dev libxml2-dev texlive-latex-extra -y

        ### install R from cran
        gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
        gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | sudo tee /etc/apt/trusted.gpg.d/cran_debian_key.asc
        echo -e "deb https://cloud.r-project.org/bin/linux/debian $(lsb_release -cs)-cran40/" | sudo tee /etc/apt/sources.list.d/r-project.list
        sleep 1 && sudo apt-get update -qq && sudo apt-get install r-base littler -y
        sudo R CMD javareconf

        ### config posit package manager
        if ! grep -q "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" /etc/R/Rprofile.site ; then echo -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" | sudo tee -a /etc/R/Rprofile.site ; fi

        ### install R packages
        [ ! -d ./rscript/ ] && mkdir ./rscript/
        echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'XML', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggplot2', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap', 'Seurat', 'workflowr', 'blogdown', 'bookdown', 'svDialogs', 'Rcpp'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))\nBiocManager::install(c('GenomicRanges','qvalue','DESeq2','EnhancedVolcano','org.Hs.eg.db'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        echo "" && sudo Rscript ./rscript/packages.R
        echo "" && Rscript ./rscript/webdriver.R
        
        ### install RStudio
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q "https://www.dropbox.com/scl/fi/3j0gkfvl21wsetqeyxf4d/rstudio.deb?rlkey=2lq1ezrjb39yrfl6hxq9qmn2v" -O rstudio.deb && echo '"RStudio" deb package is downloaded.' && sleep 1
        mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
        sudo apt-get install -f -y
        [ ! -d ~/.config/RStudio/ ] && mkdir ~/.config/RStudio/
        kwriteconfig5 --file ~/.config/RStudio/desktop.ini --group General --key view.zoomLevel "1.1"
        
        # cleanup
        [ -f ./.Rhistory ] && rm -f ./.Rhistory
        [ -d ./rscript/ ] && rm -rf ./rscript/
        [ -d ./devdeb/ ] && rm -rf ./devdeb/
        sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean

        # notify end
        echo -e " \n${TEXT_GREEN}Daily biological tools installed!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Daily biological tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_biotools.sh+#bash ./inst/1_biotools.sh+g' ~/.setup_cache/setup.sh
