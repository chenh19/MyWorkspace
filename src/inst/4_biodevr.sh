#!/bin/bash
# This script installs R developing environment and IDE

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to set up R environment for bioinformatic developing
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to set up R environment for bioinformatic developing? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing R bioinfomatics developing enviroment...${TEXT_RESET} \n" && sleep 1
        sudo apt-get update -qq && sudo apt-get upgrade -y
        [ ! -d ~/Developing/ ] && mkdir ~/Developing/ && kwriteconfig5 --file ~/Developing/.directory --group "Desktop Entry" --key Icon "folder-script"

        ## install dependencies
        sudo apt-get install default-jre default-jdk cmake pandoc libcurl4-openssl-dev libssl-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjpeg-dev libtiff-dev libtiff5-dev libgit2-dev libglpk-dev libnlopt-dev libgeos-dev libxml2-dev texlive-latex-extra -y

        ## install R from cran
        gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
        gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | sudo tee /etc/apt/trusted.gpg.d/cran_debian_key.asc
        echo -e "deb https://cloud.r-project.org/bin/linux/debian $(lsb_release -cs)-cran40/" | sudo tee /etc/apt/sources.list.d/r-project.list
        sleep 1 && sudo apt-get update -qq && sudo apt-get install r-base littler -y
        sudo R CMD javareconf

        ## config posit package manager
        if ! grep -q "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" /etc/R/Rprofile.site ; then echo -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" | sudo tee -a /etc/R/Rprofile.site ; fi

        ## install R packages
        [ ! -d ./rscript/ ] && mkdir ./rscript/
        echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'XML', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggplot2', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap', 'Seurat', 'workflowr', 'blogdown', 'bookdown', 'svDialogs', 'Rcpp'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))\nBiocManager::install(c('GenomicRanges','qvalue','DESeq2','EnhancedVolcano','org.Hs.eg.db'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        echo "" && sudo Rscript ./rscript/packages.R
        echo "" && Rscript ./rscript/webdriver.R
        
        ## install RStudio
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.12.1-402-amd64.deb && echo '"RStudio" deb package is downloaded.' && sleep 1 #_to_be_updated
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
        echo -e " \n${TEXT_GREEN}R bioinformatic developing environment ready!${TEXT_RESET} \n" && sleep 5;;
        
  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}R bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;
esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/5_biodevr.sh+#bash ./inst/5_biodevr.sh+g' ~/.setup_cache/setup.sh
