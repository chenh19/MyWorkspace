#!/bin/bash
# This script configures git ssh (ref: https://youtu.be/YnSMYgIybFU)

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.ssh/ ] && mkdir ~/.ssh/
cd ~


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Setting Git SSH...${TEXT_RESET} \n" && sleep 1

# check for existing keys
#ls -al ~/.ssh

# ask for your_email
read -p "$(echo -e $TEXT_YELLOW'Please enter your GitHub email address: '$TEXT_RESET)"$' \n' email

# create a key if does not exist
echo -e " \n${TEXT_YELLOW}When asked "Enter a file in which to save the key", please press [Enter] (default file location)${TEXT_RESET} \n"
echo -e " \n${TEXT_YELLOW}Then, please input a passphrase (anything you can remember).${TEXT_RESET} \n"
ssh-keygen -t ed25519 -C $email

# add SSH key to ssh-agent-
eval `ssh-agent -s`
ssh-add ~/.ssh/id_ed25519

# get the key
echo -e " \n${TEXT_GREEN}All done! Git SSH key: ${TEXT_RESET} \n"
cat ~/.ssh/id_ed25519.pub
echo -e " \n${TEXT_GREEN}Please copy the above key, then navigate to Github account and add the ssh key.${TEXT_RESET} \n"


# mark setup.sh
sed -i 's+bash ./cfg/0_gitssh.sh+#bash ./cfg/0_gitssh.sh+g' ~/.setup_cache/setup.sh
