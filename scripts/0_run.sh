#!bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

# check internet connection
echo -e $TEXT_YELLOW
wget -q --spider http://google.com
if [ $? -eq 0 ]
then 
  echo "Internet is connected, continue..."
else 
  echo "No internet connection, please first connect to internet then hit [Enter] to continue..."
fi
echo -e $TEXT_RESET

# update
bash 1_update.sh
