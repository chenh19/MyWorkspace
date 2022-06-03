#!/bin/bash

# add flathub to discover (KDE app store)
sudo apt-get install flatpak -y
sudo apt-get install plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
