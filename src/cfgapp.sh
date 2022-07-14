#!/bin/bash
# This script configures KDE plasma settings

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


#-------------------------------------------------------------------------------------

# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Configuring applications...${TEXT_RESET} \n" && sleep 1

######################################################################################

# Konsole

## Konsole window height 32
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x864' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1536x960' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1080' "625"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Height 1920x1200' "625"

## Konsole window height 96
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x864' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1536x960' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1080' "803"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key 'eDP-1 Width 1920x1200' "803"

## konsole window show "Main Toolbar" and "Session Toolbar"
kwriteconfig5 --file ~/.config/konsolerc --group MainWindow --key State "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAfsAAAAcAFMAUwBIAE0AYQBuAGEAZwBlAHIARABvAGMAawAAAAAA/////wAAANUBAAADAAADIwAAAiUAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAgAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAAAAAAcAHMAZQBzAHMAaQBvAG4AVABvAG8AbABiAGEAcgEAAADo/////wAAAAAAAAAA"

######################################################################################

# kwrite hide minimap
kwriteconfig5 --file ~/.config/kwriterc --group 'KTextEditor View' --key 'Scroll Bar MiniMap' "false"

######################################################################################

## System Monitor
#Edit or remove pages: uncheck "Applications" and list in this order: "Overview", "Processes", "History"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'hiddenPages' "applications.page"
kwriteconfig5 --file ~/.config/systemmonitorrc --group General --key 'pageOrder' "overview.page,process.page,history.page,application.page"

######################################################################################

# spectacle
kwriteconfig5 --file ~/.config/spectaclerc --group GuiConfig --key 'quitAfterSaveCopyExport' "true"

######################################################################################

# okular
[ -f ~/.config/okularpartrc ] && rm ~/.config/okularpartrc
[ -f ~/.config/okularrc ] && rm ~/.config/okularrc
touch ~/.config/okularpartrc ~/.config/okularrc

# Settings > Configure Okular > General > check "Open new files in tabs"
kwriteconfig5 --file ~/.config/okularpartrc --group General --key 'ShellOpenFileInTabs' "true"

# Settings > Configure Okular > Performance > Memory usage > select "Greedy"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Core Performance' --key 'MemoryLevel' "Greedy"

# Settings > Configure Okular > Presentation > uncheck "Show progress indicator"
kwriteconfig5 --file ~/.config/okularpartrc --group 'Dlg Presentation' --key 'SlidesShowProgress' "false"

# Open and close multiple PDF files, uncheck "Warn me when I attempt to close multiple tabs"
kwriteconfig5 --file ~/.config/okularrc --group 'Notification Messages' --key 'ShowTabWarning' "false"

# Configure Toolbars
[ -d ~/.local/share/kxmlgui5/okular/ ] && rm -rf ~/.local/share/kxmlgui5/okular/
cp -rf ./cfg/okular/ ~/.local/share/kxmlgui5/

######################################################################################

# windows fonts
wget -q https://www.dropbox.com/s/nsfxnl3tt1md56u/windows-fonts.zip?dl=0 && sleep 1
unzip -o -q windows-fonts.zip?dl=0 && sleep 1 && rm windows-fonts.zip?dl=0 && sleep 1
sudo cp -rf ./fonts/windows/ /usr/share/fonts/

######################################################################################

# alt_rm
bash <(wget -qO- https://raw.githubusercontent.com/chenh19/alt_rm/main/install.sh)

######################################################################################

# Inkscape
echo -e " \n${TEXT_YELLOW}Please config and then close Inkscape to continue.${TEXT_RESET} \n" && sleep 1
inkscape

######################################################################################

# notify end
echo -e " \n${TEXT_GREEN}All applications configured!${TEXT_RESET} \n" && sleep 5


#-------------------------------------------------------------------------------------

# cleanup
sudo apt-get autoremove -y && sudo apt-get clean
rm -rf ./fonts/

# mark setup.sh
sed -i 's+bash ./src/settings.sh+#bash ./src/settings.sh+g' ~/.setup_cache/setup.sh
