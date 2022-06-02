#!bin/bash

# set promot color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'

# update
echo -e $TEXT_YELLOW
echo "System packages updating..."
echo -e $TEXT_RESET
bash 1_update.sh
echo -e $TEXT_YELLOW
echo "System packages update finished"
echo -e $TEXT_RESET
