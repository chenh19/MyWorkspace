#!/bin/bash
# This script installs Python developing environment

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# ask whether to set up Python environment for Bioinformatic developing
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to set up Python environment for bioinformatic developing? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        sudo echo ""
        echo -e "${TEXT_YELLOW}Installing Python bioinfomatics developing enviroment...${TEXT_RESET} \n" && sleep 1
        
        # install anaconda
        [ ! -d ./shscript/ ] && mkdir ./shscript/
        wget -O ./shscript/Anaconda-latest-Linux-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh #_to_be_updated
        echo -e "${TEXT_YELLOW}Please press Space key to scroll the license${TEXT_RESET} \n" && sleep 1
        bash ./shscript/Anaconda-latest-Linux-x86_64.sh && sleep 3
        conda update anaconda -y && conda update --all -y
        conda config --add channels defaults
        conda config --add channels bioconda
        conda config --add channels conda-forge
        #conda install kallisto -y
        #conda install numpy -y
        conda config --set auto_activate_base false # disable auto activate base in terminal
        #conda activate # activate base when needed
        #rm -rf ~/anaconda3/ # uninstall anaconda
        # note: conda installed packages are constrained to the conda environment, while pip3 installed packages might affect system environment
        
        
        # ask whether to install Jupyter Lab
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Jupyter Lab? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                sudo echo ""
                echo -e "${TEXT_YELLOW}Installing Jupyter Lab...${TEXT_RESET} \n" && sleep 1
                
                # install Jupyter Lab
                [ ! -d ./devdeb/ ] && mkdir ./devdeb/
                wget -q https://github.com/jupyterlab/jupyterlab-desktop/releases/download/v3.3.4-2/JupyterLab-Setup-Debian.deb #_to_be_updated
                sleep 1 && mv -f ./*.deb ./devdeb/ && sudo dpkg -i ./devdeb/*.deb && sleep 1
                sudo apt-get -f -y install
                
                # notify end
                echo -e " \n${TEXT_GREEN}Jupyter Lab installed!${TEXT_RESET} \n" && sleep 5;;
                
          * ) # notify cancellation
                echo -e " \n${TEXT_YELLOW}Jupyter Lab not installed.${TEXT_RESET} \n" && sleep 5;;
        esac
        
        # cleanup
        sudo apt-get autoremove -y && sudo apt-get clean
        [ -d ./devdeb/ ] && rm -rf ./devdeb/
        [ -d ./shscript/ ] && rm -rf ./shscript/

        # notify end
        echo -e " \n${TEXT_GREEN}Python bioinformatic developing environment ready!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Python bioinformatic tools not installed.${TEXT_RESET} \n" && sleep 5;;

esac

# mark setup.sh
sed -i 's+bash ./src/biodevpy.sh+#bash ./src/biodevpy.sh+g' ~/.setup_cache/setup.sh
