#!bin/bash

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

# update
bash 1_update.sh
