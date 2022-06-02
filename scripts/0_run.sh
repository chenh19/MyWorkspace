#!bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_RED_B='\e[1;31m'

# check internet connection
wget -q --spider http://google.com
if [ $? -eq 0 ]
then 
  echo "Online"
else 
  echo "Offline"
fi
echo -e $TEXT_RESET

# update
bash 1_update.sh
