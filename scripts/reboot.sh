#!bin/bash

# set promot color
        TEXT_RESET='\e[0m'
        TEXT_YELLOW='\e[1;33m'


# ask whether to reboot
        echo -e $TEXT_YELLOW
read -n1 -s -r -p $'All done! Reboot the system now? [y/n/c]\n' choice
        echo ""
read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}Cleaning up...${TEXT_RESET}) choice
case "$choice" in
  y|Y ) echo "Rebooting in 5..." && sleep 5 && reboot;;
  n|N ) echo "Please manually reboot the system later.";;
  * ) echo "Please manually reboot the system later.";;
esac
        echo -e $TEXT_RESET

        "$(echo -e $BOLD$YELLOW"foo bar "$RESET)"

read -n1 -s -r -p "$(echo -e ${TEXT_YELLOW}Cleaning up...${TEXT_RESET}) choice

read -p "$(echo -e $BOLD$YELLOW"foo bar "$RESET)"
${TEXT_YELLOW}All done! Reboot the system now? [y/n/c]\n${TEXT_RESET}
$'All done! Reboot the system now? [y/n/c]\n${TEXT_RESET}
