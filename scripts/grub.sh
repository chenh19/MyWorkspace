#!/bin/bash

sudo sed -i 's+GRUB_TIMEOUT=0+GRUB_TIMEOUT=2+g' /etc/default/grub
sudo sed -i 's+GRUB_CMDLINE_LINUX=""+GRUB_CMDLINE_LINUX="psmouse.synaptics_intertouch=0"+g' /etc/default/grub
sudo update-grub
