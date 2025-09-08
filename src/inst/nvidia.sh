#!/bin/bash

# edit sources.list
source /etc/os-release
echo -e "# See https://wiki.debian.org/SourcesList for more information.\ndeb http://deb.debian.org/debian $VERSION_CODENAME main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian $VERSION_CODENAME-updates main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME-updates main contrib non-free non-free-firmware\n\ndeb http://deb.debian.org/debian-security/ $VERSION_CODENAME-security main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian-security/ $VERSION_CODENAME-security main contrib non-free non-free-firmware\n\n# Backports allow you to install newer versions of software made available for this release\ndeb http://deb.debian.org/debian $VERSION_CODENAME-backports main contrib non-free non-free-firmware\ndeb-src http://deb.debian.org/debian $VERSION_CODENAME-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list

sudo apt update -qq && sudo apt install linux-headers-amd64 -y
sudo apt install nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree -y

echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1 nvidia-drm.fbdev=1"' | sudo tee /etc/default/grub.d/nvidia-modeset.cfg
sudo update-grub
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' | sudo tee /etc/modprobe.d/nvidia-power-management.conf

echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" | sudo tee -a /etc/modprobe.d/nvidia-options.conf
