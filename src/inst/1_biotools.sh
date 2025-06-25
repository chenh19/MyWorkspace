#!/bin/bash
# This script intsalls biological tools

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to install biological tools
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install biological tools? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing biological tools...${TEXT_RESET} \n" && sleep 1
        sudo apt-get update -qq && sudo apt-get upgrade -y
        if ! dpkg -l | grep -q "^ii.*wget" ; then sudo apt-get update -qq && sudo apt-get install wget -y && sleep 1 ; fi
        
        #########################################################################################

        ## install conda
        ### uninstall previous conda if any
        [ -d ~/.conda/ ] && rm -rf ~/.conda/
        [ -d ~/.cache/conda/ ] && rm -rf ~/.cache/conda/
        [ -d ~/.cache/conda-anaconda-tos/ ] && rm -rf ~/.cache/conda-anaconda-tos/
        [ -d ~/miniconda3/ ] && rm -rf ~/miniconda3/
        [ -f ~/.condarc ] && rm -f ~/.condarc
        sed -i '/alias rm=/d' ~/.bashrc
        if grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.bashrc ; then sed -i '/export PATH=/d' ~/.bashrc; fi
        if grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.zshrc ; then sed -i '/export PATH=/d' ~/.zshrc; fi

        ### install miniconda3
        mkdir -p ~/miniconda3
        curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda3/miniconda.sh
        bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
        [ ! -f ~/.condarc ] && touch ~/.condarc
        rm ~/miniconda3/miniconda.sh

        ### initialize conda and refresh shell
        source ~/miniconda3/bin/activate
        conda init --all
        source ~/.bashrc

        ### set up channels
        conda config --add channels bioconda
        conda config --add channels conda-forge
        conda config --set channel_priority strict

        ### disable auto-activation of conda
        if ! grep -q "auto_activate: false" ~/.condarc ; then conda config --set auto_activate false ; fi
        if [[ -f ~/.bashrc ]]; then
          start0=$(( $(grep -wn "# >>> conda initialize >>>" ~/.bashrc | head -n 1 | cut -d: -f1) - 1 ))
          end0=$(( $(grep -wn "# <<< conda initialize <<<" ~/.bashrc | tail -n 1 | cut -d: -f1) + 1 ))
          if [[ -n "$start0" && -n "$end0" ]]; then sed -i "${start0},${end0}d" ~/.bashrc; fi
          if ! grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.bashrc ; then echo -e 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc; fi
          unset start0 end0
        fi
        if [[ -f ~/.zshrc ]]; then
          start0=$(( $(grep -wn "# >>> conda initialize >>>" ~/.zshrc | head -n 1 | cut -d: -f1) - 1 ))
          end0=$(( $(grep -wn "# <<< conda initialize <<<" ~/.zshrc | tail -n 1 | cut -d: -f1) + 1 ))
          if [[ -n "$start0" && -n "$end0" ]]; then sed -i "${start0},${end0}d" ~/.zshrc; fi
          if ! grep -q 'export PATH="$HOME/miniconda3/bin:$PATH"' ~/.zshrc ; then echo -e 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.zshrc; fi
          unset start0 end0
        fi

        ### install packages for base
        conda install -y -n base conda-forge::python conda-forge::pip conda-forge::cmake conda-forge::parallel conda-forge::nlopt conda-forge::geos
        conda install -y -n base conda-forge::r-base conda-forge::r-littler conda-forge::r-devtools conda-forge::r-biocmanager conda-forge::r-rjava conda-forge::r-tidyverse
        conda install -y -n base conda-forge::r-readxl conda-forge::r-writexl conda-forge::r-expss conda-forge::r-vcfr conda-forge::r-filesstrings conda-forge::r-r.utils
        conda install -y -n base conda-forge::r-car conda-forge::r-foreach conda-forge::r-doparallel conda-forge::r-rselenium conda-forge::r-markdown conda-forge::r-ggthemes
        conda install -y -n base conda-forge::r-ggpubr conda-forge::r-ggseqlogo conda-forge::r-cowplot conda-forge::r-pheatmap conda-forge::r-rtsne conda-forge::r-umap conda-forge::r-seurat
        conda install -y -n base conda-forge::r-svdialogs conda-forge::r-workflowr conda-forge::r-quarto conda-forge::r-gt conda-forge::r-reactable conda-forge::r-kableextra conda-forge::r-flextable
        conda install -y -n base bioconda::bioconductor-genomicranges bioconda::bioconductor-qvalue bioconda::bioconductor-deseq2 bioconda::bioconductor-enhancedvolcano bioconda::bioconductor-org.hs.eg.db
        conda install -y -n base bioconda::bwa bioconda::bowtie2 bioconda::minimap2 bioconda::fastqc bioconda::fastp bioconda::seqtk bioconda::samtools bioconda::bamtools bioconda::bcftools bioconda::bedtools
        
        ### update base
        R CMD javareconf
        Rscript -e 'wdman::chrome(version = "latest")'
        Rscript -e 'tinytex::install_tinytex(force = TRUE)'
        conda update --all -y

        ### deactivate conda
        conda deactivate
        source ~/.bashrc

        #########################################################################################

        ## install PyMOL/ClustalX/Meld/FileZilla/DB Broswer/KDevelop
        [ ! -d ~/igv ] && mkdir ~/igv/
        sudo apt-get install pymol clustalx meld filezilla sqlitebrowser kdevelop -y
        
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

        ## install RStudio, Jupyter Lab, Quarto
        [ ! -d ./devdeb/ ] && mkdir ./devdeb/
        wget -q "https://www.dropbox.com/scl/fi/3j0gkfvl21wsetqeyxf4d/rstudio.deb?rlkey=2lq1ezrjb39yrfl6hxq9qmn2v" -O rstudio.deb && echo '"RStudio" deb package is downloaded.' && sleep 1
        wget -q "https://www.dropbox.com/scl/fi/q8lb22rf1f7ng293svh1u/jupyterlab.deb?rlkey=ptjie4pbjbnzso6okju17yseb" -O jupyterlab.deb && echo '"JupyterLab" deb package is downloaded.' && sleep 1
        wget -q "https://www.dropbox.com/scl/fi/pq48otnj90g7erg0e3udp/quarto.deb?rlkey=tjfdpxhkpjkfl0yic2plswefp" -O quarto.deb && echo '"Quarto" deb package is downloaded.' && sleep 1
        echo ""
        mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
        sudo apt-get install -f -y
        quarto install tinytex
        
        #########################################################################################
        
        # cleanup
        [ -f ./.Rhistory ] && rm -f ./.Rhistory
        [ -d ./rscript/ ] && rm -rf ./rscript/
        [ -d ./devdeb/ ] && rm -rf ./devdeb/
        sudo apt-get update -qq && sudo apt-get autoremove -y && sudo apt-get clean
        
        # notify end
        echo -e " \n${TEXT_GREEN}Biological tools installed!${TEXT_RESET} \n" && sleep 3;;
        
  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Biological tools not installed.${TEXT_RESET} \n" && sleep 1;;
        
esac


# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./inst/1_biotools.sh+#bash ./inst/1_biotools.sh+g' ~/.setup_cache/setup.sh
