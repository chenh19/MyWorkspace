# aske whether to configure apps manually
######################################################################################

# fdm
echo -e " \n${TEXT_YELLOW}Please config and then close Free Donwload Manager to continue.${TEXT_RESET} \n" && sleep 1
/opt/freedownloadmanager/fdm

######################################################################################

# Inkscape
echo -e " \n${TEXT_YELLOW}Please config and then close Inkscape to continue.${TEXT_RESET} \n" && sleep 1
inkscape

######################################################################################

# qView
# do not check update notification when first open 
echo -e " \n${TEXT_YELLOW}Please close qViw to continue.${TEXT_RESET} \n" && sleep 1
qview

######################################################################################

# libreoffice
echo -e " \n${TEXT_YELLOW}Please config ${TEXT_GREEN}[themes/fonts/saving formats/toolbars]${TEXT_YELLOW} and then close LibreOffice to continue.${TEXT_RESET} \n" && sleep 1
libreoffice

######################################################################################

# chrome
echo -e " \n${TEXT_YELLOW}Please login to your Google account and then close Chrome to continue.${TEXT_RESET} \n" && sleep 1
/usr/bin/google-chrome-stable

######################################################################################

# evolution
# restore backup
# ask whether set evolution as autostart

######################################################################################

# expandrive

~/.config/autostart/expandrive --autorun.desktop

[Desktop Entry]
Type=Application
Version=1.0
Name=expandrive --autorun
Comment=expandrive --autorunstartup script
Exec=/opt/ExpanDrive/expandrive --autorun
StartupNotify=false
Terminal=false

# ask whether set evolution as autostart

######################################################################################

# slack

# ask whether to set as autostart
