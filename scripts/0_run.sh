#!bin/bash

# set promot color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'


# update
        echo -e $TEXT_YELLOW
        echo "Updating system packages..."
        echo -e $TEXT_RESET
bash 1_update.sh && sleep 1
        echo -e $TEXT_YELLOW
        echo "All system packages updated!"
        echo -e $TEXT_RESET
