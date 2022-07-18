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
        
        # config conda
        echo -e " \n${TEXT_YELLOW}Paste below command in the new terminal window and execute. Once finished, please close the new terminal window to continue.${TEXT_RESET} \n" && sleep 1
        echo -e " \n${TEXT_GREEN}bash <(wget -qO- https://raw.githubusercontent.com/chenh19/MyWorkspace/main/src/inst/9_biodevpy_conda.sh)${TEXT_RESET} \n" && sleep 1
        konsole
        
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
                
                # config Jupyter Lab
                [ ! -d ~/.config/jupyterlab-desktop/lab/user-settings/ ] && mkdir ~/.config/jupyterlab-desktop/lab/user-settings/
                [ ! -d ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/ ] && mkdir ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/
                [ ! -d ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/ ] && mkdir ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/
                echo -e '{ \n    "theme": "JupyterLab Light", \n    "theme-scrollbars": false, \n    "overrides": { \n        "code-font-family": null, \n        "code-font-size": null, \n        "content-font-family": null, \n        "content-font-size1": null, \n        "ui-font-family": null, \n        "ui-font-size1": null \n    } \n}' > ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
                
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

###>>>sed-i-d-start-1
# manual config
if [ -d ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/ ] 
then

# aske whether to configure Python dev env manually
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure Python developing environment now? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # ask for individual apps
        
        ###>>>sed-i-d-start-2
        ## eudic
        sudo echo ""
        read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to configure JupyterLab? [y/n/c]'$TEXT_RESET)"$' \n' choice
        case "$choice" in
          y|Y ) # notify start
                echo -e " \n${TEXT_YELLOW}Please config and then close Jupyter Lab to continue.${TEXT_RESET} \n" && sleep 1
                /opt/JupyterLab/jupyterlab-desktop
                # notify end
                echo -e " \n${TEXT_GREEN}JupyterLab configured!${TEXT_RESET} \n" && sleep 1;;
          * )   # notify cancellation
                echo -e " \n${TEXT_YELLOW}JupyterLab not configured.${TEXT_RESET} \n" && sleep 1;;
        esac
        ###>>>sed-i-d-end-2
        
        # notify end
        echo -e " \n${TEXT_GREEN}Python developing environment Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Python developing environment not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac

fi
###>>>sed-i-d-end-1

# mark setup.sh
sed -i 's+bash ./inst/9_biodevpy.sh+#bash ./inst/9_biodevpy.sh+g' ~/.setup_cache/setup.sh
