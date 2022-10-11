#!/bin/bash
# This script configures specific models

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

# ask whether it's a laptop
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to install Laptop-Mode-Tools (might not be stable or useful)? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        echo -e " \n${TEXT_YELLOW}Configuring specifically for laptop mode power saving...${TEXT_RESET} \n" && sleep 1
        
        # install laptop-mode-tools
        wget -q https://codeload.github.com/rickysarraf/laptop-mode-tools/zip/refs/heads/lmt-upstream && sleep 1
        unzip -o -q lmt-upstream && sleep 1 && rm lmt-upstream
        mv -f ./laptop-mode-tools-lmt-upstream/ ./cfg/
        sudo bash ./cfg/laptop-mode-tools-lmt-upstream/install.sh
  
        # notify end
        echo -e " \n${TEXT_YELLOW}Laptop mode power saving configuration finished!${TEXT_RESET} \n" && sleep 5;;
  
  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}Laptop mode power saving configuration skipped.${TEXT_RESET} \n" && sleep 5;;

esac

# ask whether it's a thinkpad x1e
sudo echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Are you setting up ThinkPad X1 Extreme Gen 2? [y/n/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  y|Y ) # notify start
        echo -e " \n${TEXT_YELLOW}Configuring specifically for ThinkPad X1 EXtreme Gen 2...${TEXT_RESET} \n" && sleep 1
        if ! grep -q GRUB_CMDLINE_LINUX="psmouse.synaptics_intertouch=0" /etc/default/grub ; then sudo sed -i 's+GRUB_CMDLINE_LINUX=""+GRUB_CMDLINE_LINUX="psmouse.synaptics_intertouch=0"+g' /etc/default/grub && sudo update-grub ; fi
        
        # configure undervolt
        sudo apt-get update && sudo apt-get install -y python3-pip && sudo pip install undervolt
        [ ! -f /etc/systemd/system/undervolt.service ] && sudo touch /etc/systemd/system/undervolt.service
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.service --group Unit --key Description "undervolt"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.service --group Service --key Type "oneshot"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.service --group Service --key ExecStart "/usr/local/bin/undervolt -v --core -95 --cache -95 --gpu -95 -t 95"
        [ ! -f /etc/systemd/system/undervolt.timer ] && sudo touch /etc/systemd/system/undervolt.timer
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.timer --group Unit --key Description "Apply undervolt settings"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.timer --group Timer --key Unit "undervolt.service"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.timer --group Timer --key OnBootSec "30"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.timer --group Timer --key OnUnitActiveSec "10min"
        sudo kwriteconfig5 --file /etc/systemd/system/undervolt.timer --group Install --key WantedBy "multi-user.target"
        sudo systemctl enable undervolt.timer && sudo systemctl start undervolt.timer
        # Note: Dell has disabled undervolt in BIOS in the newer models; 12th gen intel doesn't seem to allow undervolt, either

        # notify end
        echo -e " \n${TEXT_YELLOW}ThinkPad X1 Extreme Gen 2 configuration finished!${TEXT_RESET} \n" && sleep 5;;

  * ) # notify cancellation
        echo -e " \n${TEXT_YELLOW}ThinkPad X1 Extreme Gen 2 configuration skipped.${TEXT_RESET} \n" && sleep 5;;

esac


# mark setup.sh
sed -i 's+bash ./cfg/1_sysmdl.sh+#bash ./cfg/1_sysmdl.sh+g' ~/.setup_cache/setup.sh
