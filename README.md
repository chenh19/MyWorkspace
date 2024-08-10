# MyWorkspace
*Current version: v2.1.4 (for X11)*  

## Introduction

- This is an automated configuration tool for freshly installed [**Debian (KDE)**](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/), which is my wife's least hated linux distro.
- This tool will install and configure these [**applications**](https://github.com/chenh19/MyWorkspace/blob/main/list.md).

## How to use

- Simply connect to internet and execute the below command in [**Konsole**](https://konsole.kde.org/) (terminal): 
```
sudo apt-get update -qq && sudo apt-get install wget -y && sleep 1
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/MyWorkspace/main/setup.sh)
```
- There is also a simple [**tutorial**](https://chenh19.github.io/MyWorkspace/) for quick reference.
