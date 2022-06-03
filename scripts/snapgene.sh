#!/bin/bash

sudo apt-get update && sudo apt-get install ttf-mscorefonts-installer igv pymol -y
wget -q https://www.dropbox.com/s/9dypgbwpg0iwgcc/snapgene.zip?dl=0 && unzip -o -q snapgene.zip?dl=0 && rm snapgene.zip?dl=0
sudo dpkg -i ./snapgene/*.deb
