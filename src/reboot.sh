 #!/bin/bash
# This script does xxx

# set terminal font color
TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# detect whether reboot is required
if [ -f /var/run/reboot-required ]; then

  # ask whether reboot
  read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like to reboot the system now? [y/n/c]'$TEXT_RESET)"$' \n' choice
  case "$choice" in
	
  y|Y ) # notify reboot
	sudo echo ""
	echo -e "${TEXT_YELLOW}Rebooting in 5 seconds...${TEXT_RESET} \n" && sleep 5
	reboot;;
        	
  n|N ) # notify cancellation
	echo -e " \n${TEXT_YELLOW}Please manually reboot later.${TEXT_RESET} \n" && sleep 5;;

  * ) 	# notify cancellation
	echo -e " \n${TEXT_YELLOW}Please manually reboot later.${TEXT_RESET} \n" && sleep 5;;

	esac
fi
