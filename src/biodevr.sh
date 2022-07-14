#!/bin/bash
# This script installs R, RStudio, and R packages

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to set up R environment for Bioinformatic developing
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to set up R environment for bioinformatic developing? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing R bioinfomatics developing enviroment (this might take a while)...${TEXT_RESET} \n" && sleep 1

        # update system and install packages required by R and R packages installing
        sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install default-jre default-jdk curl openssl libclang libxml2-dev libssl-dev libcurl4-openssl-dev libnlopt-dev libgeos-dev texlive-latex-extra -y

        # install R from cran
        wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg
        echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/r-project.list
        sudo apt-get update && sudo apt-get install r-base -y
        sudo R CMD javareconf

        # install R packages and web driver
        [ ! -d ./rscript/ ] && mkdir ./rscript/
        echo -e "install.packages(c('RSelenium'))" > ./rscript/packages.R # for testing
        #echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap', 'Seurat', 'workflowr', 'blogdown', 'bookdown', 'svDialogs', 'Rcpp')) \nBiocManager::install(c('GenomicRanges','qvalue'))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        sudo Rscript ./rscript/packages.R
        echo ""
        Rscript ./rscript/webdriver.R
        
        # ask whether to install RStudio
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install RStudio? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                sudo echo ""
                echo -e "${TEXT_YELLOW}Installing RStudio...${TEXT_RESET} \n" && sleep 1
                
                # install RStudio
                [ ! -d ./devdeb/ ] && mkdir ./devdeb/
                wget -q https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.0-548-amd64.deb #_to_be_updated
                sleep 1 && mv -f ./*.deb ./devdeb/ && sudo apt-get install ./devdeb/*.deb && sleep 1
                sudo apt-get -f -y install #sudo apt-get --fix-broken install -y
                
                # notify end
                echo -e " \n${TEXT_GREEN}RStudio installed!${TEXT_RESET} \n" && sleep 5;;
                
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}RStudio not installed.${TEXT_RESET} \n" && sleep 5;;
        esac
        
        # ask whether to install RKWard
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install RKWard? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                sudo echo ""
                echo -e "${TEXT_YELLOW}Installing RKWard...${TEXT_RESET} \n" && sleep 1
                
                # install RKWard
                # rkward is dependent on kate, which is installed by Kubuntu by default but usually uninstalled by me
                sudo apt-get install kate kbibtex rkward -y
                sudo apt-get install -f -y
                
                # notify end
                echo -e " \n${TEXT_GREEN}RKWard installed!${TEXT_RESET} \n" && sleep 5;;
                
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}RKWard not installed.${TEXT_RESET} \n" && sleep 5;;
        esac
        
        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean
        [ -d ./rscript/ ] && rm -rf ./rscript/
        [ -d ./devdeb/ ] && rm -rf ./devdeb/

        # notify end
        echo -e " \n${TEXT_GREEN}R bioinformatic developing environment ready!${TEXT_RESET} \n" && sleep 5;;
        
  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}R bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;
esac


# mark setup.sh
sed -i 's+bash ./src/biodevr.sh+#bash ./src/biodevr.sh+g' ~/.setup_cache/setup.sh
