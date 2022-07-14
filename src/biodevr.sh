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
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to set up R environment for bioinformatic developing? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing R bioinfomatics developing enviroment...${TEXT_RESET} \n" && sleep 1

        # update system and install packages required by R and R packages installing
        sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install default-jre default-jdk libxml2-dev libssl-dev libcurl4-openssl-dev libnlopt-dev libgeos-dev texlive-latex-extra -y

        # install R from cran
        wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg
        echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list
        sudo apt-get update && sudo apt-get install r-base -y
        sudo R CMD javareconf

        # install R packages and web driver
        [ ! -d ./rscript/ ] && mkdir ./rscript/
        echo -e "install.packages(c('RSelenium'))" > ./rscript/packages.R # for testing
        #echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap', 'Seurat', 'workflowr', 'blogdown', 'svDialogs')) \nBiocManager::install(c('GenomicRanges','qvalue'))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        sudo Rscript ./rscript/packages.R
        Rscript ./rscript/webdriver.R
        
        # install RKWard and fastqc
        # rkward is dependent on kate, which is installed by Kubuntu by default but usually uninstalled by me
        #sudo apt-get install kate kbibtex rkward -y
        
        # install RStudio
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.0-548-amd64.deb #_to_be_updated
        sleep 1 && mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
        sudo apt-get -f -y install

        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean
        rm -rf ./rscript/ ./devdeb/ ./shscript/

        # notify end
        echo -e " \n${TEXT_GREEN}R bioinformatic developing environment ready!${TEXT_RESET} \n" && sleep 5

  n|N ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}R bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}R bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac

# mark setup.sh
sed -i 's+bash ./src/biodev.sh+#bash ./src/biodev.sh+g' ~/.setup_cache/setup.sh
