#!/usr/bin/env bash
# This script intsalls biological tools

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# ask whether to install biological tools
read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}'Would you like to install biological tools? [y/n/c]'${TEXT_RESET})"$'\n' choice
case "$choice" in
  y|Y ) # notify start
        echo -e "\n${TEXT_YELLOW}Installing biological tools...${TEXT_RESET}\n" && sleep 1
        sudo apt update -qq && sudo apt upgrade -y
        if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt update -qq && sudo apt install wget -y && sleep 1 ; fi
        
        ## install PyMOL/FastQC/Meld etc
        [ ! -d ~/igv ] && mkdir ~/igv/
        sudo apt install pymol fastqc fastp seqtk cutadapt bwa bowtie2 minimap2 samtools bamtools clustalx meld filezilla sqlitebrowser kdevelop parallel -y
        
        ## install Zotero
        wget -qO- "https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh" | sudo bash
        sudo apt update -qq && sudo apt install zotero libreoffice-java-common -y
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
        ## not installing: texlive-latex-extra
        sudo apt install default-jre default-jdk cmake pandoc libcurl4-openssl-dev libssl-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjpeg-dev libtiff-dev libtiff5-dev libgit2-dev libglpk-dev libnlopt-dev libgeos-dev libxml2-dev libv8-dev libcairo2-dev libmagick++-dev libpoppler-cpp-dev -y
        
        ### install R from cran
        gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
        gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | sudo tee /etc/apt/trusted.gpg.d/cran_debian_key.asc
        echo -e "deb https://cloud.r-project.org/bin/linux/debian $(lsb_release -cs)-cran40/" | sudo tee /etc/apt/sources.list.d/r-project.list
        sleep 1 && sudo apt update -qq && sudo apt install r-base littler -y
        sudo R CMD javareconf
        
        ### config posit package manager
        if ! grep -q "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" /etc/R/Rprofile.site ; then echo -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/$(lsb_release -cs)/latest'))" | sudo tee -a /etc/R/Rprofile.site ; fi
        
        ### install R packages
        [ ! -d ./rscript/ ] && mkdir ./rscript/
        ## not installing: 'blogdown', 'bookdown'
        echo -e "install.packages(c('devtools', 'BiocManager', 'tidyverse', 'tinytex', 'readxl', 'writexl', 'expss', 'vcfR', 'filesstrings', 'R.utils', 'car', 'foreach', 'doParallel', 'rJava', 'RSelenium', 'XML', 'base64enc', 'htmltools', 'markdown', 'rmarkdown', 'ggplot2', 'ggthemes', 'ggpubr', 'ggseqlogo', 'cowplot', 'ggrepel', 'ggtext', 'pheatmap', 'UpSetR', 'Rtsne', 'umap', 'Seurat', 'svDialogs', 'Rcpp', 'workflowr', 'quarto', 'gt', 'reactable', 'kableExtra', 'flextable', 'magick', 'pdftools'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))\nBiocManager::install(c('GenomicRanges','qvalue','DESeq2','EnhancedVolcano','org.Hs.eg.db'), force = TRUE, Ncpus = system('nproc --all', intern = TRUE))" > ./rscript/packages.R
        echo -e "wdman::chrome(version = 'latest')" > ./rscript/webdriver.R
        echo -e "tinytex::install_tinytex()" > ./rscript/tinytex.R
        echo "" && sudo Rscript ./rscript/packages.R
        echo "" && sudo Rscript ./rscript/tinytex.R
        echo "" && Rscript ./rscript/webdriver.R
        
        ### install RStudio, Jupyter Lab, Quarto
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q "https://www.dropbox.com/scl/fi/3j0gkfvl21wsetqeyxf4d/rstudio.deb?rlkey=2lq1ezrjb39yrfl6hxq9qmn2v" -O rstudio.deb && echo '"RStudio" deb package is downloaded.' && sleep 1
        wget -q "https://www.dropbox.com/scl/fi/q8lb22rf1f7ng293svh1u/jupyterlab.deb?rlkey=ptjie4pbjbnzso6okju17yseb" -O jupyterlab.deb && echo '"JupyterLab" deb package is downloaded.' && sleep 1
        wget -q "https://www.dropbox.com/scl/fi/pq48otnj90g7erg0e3udp/quarto.deb?rlkey=tjfdpxhkpjkfl0yic2plswefp" -O quarto.deb && echo '"Quarto" deb package is downloaded.' && sleep 1
        echo ""
        mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
        sudo apt install -f -y
        quarto install tinytex
                
        # cleanup
        [ -f ./.Rhistory ] && rm -f ./.Rhistory
        [ -d ./rscript/ ] && rm -rf ./rscript/
        [ -d ./devdeb/ ] && rm -rf ./devdeb/
        sudo apt update -qq && sudo apt autoremove -y && sudo apt clean
        
        # notify end
        echo -e "\n${TEXT_GREEN}Biological tools installed!${TEXT_RESET}\n" && sleep 3;;
        
  * ) # notify cancellation
        echo -e "\n${TEXT_YELLOW}Biological tools not installed.${TEXT_RESET}\n" && sleep 1;;
        
esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_biotools.sh+#bash ./inst/1_biotools.sh+g' ~/.setup_cache/setup.sh
