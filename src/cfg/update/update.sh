#!/bin/bash
# This script updates all packages in the system (deb/flatpak/snap)

# apt update & cleanup
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y && echo ""

# flatpak update
sudo flatpak update -y && echo ""

# snap update
sudo snap refresh && echo ""

# R packges update
sudo Rscript ./.update.R && echo ""

# Conda update
conda update --all -y && echo ""

# kernel update
sudo ukuu --scripted --install-latest && echo ""

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean && echo ""

# notify end
echo "System up to date." && echo ""

