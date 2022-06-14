#!/bin/bash
# This script installs R, RStudio, and R packages

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to set up the environment for Bioinformatic developing
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to set up the environment for bioinformatic developing, such as R and Python? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing bioinfomatics developing enviroment (R/Python)...${TEXT_RESET} \n" && sleep 1

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
        #echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap', 'Seurat', 'workflowr', 'blogdown')) \nBiocManager::install(c('GenomicRanges','qvalue'))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        sudo Rscript ./rscript/packages.R
        Rscript ./rscript/webdriver.R
        
        # install RKWard and fastqc
        # rkward is dependent on kate, which is installed by Kubuntu by defauly
        sudo apt-get install rkward kbibtex fastqc -y

        # install RStudio and Jupyter Lab
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.02.3-492-amd64.deb #_to_be_updated
        wget -q https://github.com/jupyterlab/jupyterlab-desktop/releases/download/v3.3.4-2/JupyterLab-Setup-Debian.deb #_to_be_updated
        sleep 1 && mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
        sudo apt-get -f -y install
        
        # install anaconda
        [ ! -d ./shscript/ ] && mkdir ./shscript/
        wget -O ./shscript/Anaconda-latest-Linux-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh #_to_be_updated
        echo -e "${TEXT_YELLOW}Please press Space key to scroll the license${TEXT_RESET} \n" && sleep 1
        bash ./shscript/Anaconda-latest-Linux-x86_64.sh && sleep 3
        conda update anaconda -y && conda update --all -y
        conda config --set auto_activate_base false # disable auto activate base in terminal
        # conda activate # activate base when needed
        # rm -rf ~/anaconda3/ # uninstall anaconda

        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean
        rm -rf ./rscript/ ./devdeb/ ./shscript/

        # notify end
        echo -e " \n${TEXT_GREEN}Bioinformatic developing environment ready!${TEXT_RESET} \n" && sleep 5

  n|N ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac

# mark setup.sh
sed -i 's+bash ./src/biodev.sh+#bash ./src/biodev.sh+g' ~/.setup_cache/setup.sh
