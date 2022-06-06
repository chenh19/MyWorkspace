#!/bin/bash
# This script installs R, RStudio, and R packages

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Installing R/RStudio/R packages...${TEXT_RESET} \n" && sleep 1

# update system and install packages required by R and R packages installing
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install default-jre default-jdk libxml2-dev libssl-dev libcurl4-openssl-dev libnlopt-dev texlive-latex-extra -y

# install R from cran
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg
echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list
sudo apt-get update && sudo apt-get install r-base -y
sudo R CMD javareconf

# install R packages and download web scraping driver using R scripts
[ ! -d ./rscript/ ] && mkdir ./rscript/
echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'pheatmap', 'Rtsne', 'umap')) \nBiocManager::install(c('GenomicRanges','qvalue'))" > ./rscript/packages.R
echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
sudo Rscript ./rscript/packages.R
Rscript ./rscript/webdriver.R

# install RStudio and dependency that no longer provided by ubuntu 22.04
[ ! -d ./rstudio/ ] && mkdir ./rstudio/
wget -q https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.02.3-492-amd64.deb #_to_be_updated
mv -f ./*.deb ./rstudio/ && sudo dpkg -i ./rstudio/*.deb

# configure RStudio exec command in the desktop file so that it will not show a blank window
sudo sed -i 's+Exec=/usr/lib/rstudio/bin/rstudio %F+Exec=/usr/lib/rstudio/bin/rstudio --no-sandbox %F+g' /usr/share/applications/rstudio.desktop
sudo chmod +x /usr/share/applications/rstudio.desktop

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./rscript/ ./rstudio/

# notify end
echo -e " \n${TEXT_GREEN}R developing enviroment ready!${TEXT_RESET} \n" && sleep 1
