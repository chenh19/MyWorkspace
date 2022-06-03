#!/bin/bash

wget -q https://www.dropbox.com/s/oi8ffh9ogsir4ac/appimage.zip?dl=0 && unzip -o -q appimage.zip?dl=0 && rm appimage.zip?dl=0
sudo cp -rf ./appimage/applications/* /usr/share/applications/
sudo cp -rf ./appimage/opt/* /opt/
