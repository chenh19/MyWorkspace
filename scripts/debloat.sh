#!/bin/bash
sudo snap remove firefox && sudo rm -r ~/snap/firefox/
sudo apt-get remove thunderbird kate krdc konversation ktorrent skanlite usb-creator-kde kmahjongg kmines kpat ksudoku -y
sudo apt-get update && sudo apt autoremove -y && sudo apt clean
