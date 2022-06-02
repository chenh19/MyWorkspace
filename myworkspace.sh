#!/bin/bash

# enter password for root
        sudo echo ""


# set promot color
        TEXT_RESET='\e[0m'
        TEXT_YELLOW='\e[1;33m'


# check internet connection
        echo -e $TEXT_YELLOW
        echo "Checking internet connection..." && sleep 1
        echo -e $TEXT_RESET
wget -q --spider http://google.com
        echo -e $TEXT_YELLOW
if [ $? -eq 0 ]
then 
        echo "Internet is connected!"
else 
        echo "No internet connection, please first connect to internet then hit [Enter] to continue" # to be updated
fi
        echo -e $TEXT_RESET


# download setup scripts
cd ~
[ ! -d .setup_cache ] && mkdir .setup_cache
        echo -e $TEXT_YELLOW
        echo "Downloading setup scripts..." && sleep 1
        echo -e $TEXT_RESET
cd ./.setup_cache
[ ! -d master ] && wget https://codeload.github.com/chenh19/myworkspace/zip/refs/heads/main && unzip -o -q main && rm main
cd ./myworkspace-main && rm LICENSE README.md myworkspace.sh && sleep 1
        echo -e $TEXT_YELLOW
        echo "All scripts downloaded!" && sleep 1
        echo -e $TEXT_RESET


# run
cd ./scripts && bash 00_setup.sh


# cleanup
        echo -e $TEXT_YELLOW
        echo "Cleaning up..." && sleep 1
#cd ../../../ && rm -rf ./.setup_cache
        echo -e $TEXT_RESET
        echo -e $TEXT_YELLOW
        echo "All done!"
        echo -e $TEXT_RESET
