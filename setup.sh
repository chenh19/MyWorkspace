#!/bin/bash

# set promot color
TEXT_RESET='\e[0m'
TEXT_GREEN='\e[1;32m'
TEXT_YELLOW='\e[1;33m'

# check internet connection
wget -q --spider http://google.com
echo -e $TEXT_GREEN
if [ $? -eq 0 ]
then 
  echo "Internet is connected, continue..."
else 
  echo "No internet connection, please first connect to internet then hit [Enter] to continue..."
fi
echo -e $TEXT_RESET

# create cache directory
cd ~
[ ! -d .setup_cache ] && mkdir .setup_cache

# download setup scripts
cd ./.setup_cache
[ ! -d master ] && wget https://codeload.github.com/chenh19/myworkspace/zip/refs/heads/main && unzip -o -q main && rm main
cd ./myworkspace-main && rm LICENSE README.md setup.sh && cd ./scripts

# run
bash 0_run.sh

# cleanup
#cd ../../../ && rm -rf ./.setup_cache
