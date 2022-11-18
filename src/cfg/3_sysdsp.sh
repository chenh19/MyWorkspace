#!/bin/bash
# This script configures display options

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
sudo echo ""
echo -e "${TEXT_YELLOW}Setting display options...${TEXT_RESET} \n" && sleep 1

# global theme
## System Settings > Appearance > Global Theme > Breeze
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Light or Dark theme? [l/d/c]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  l|L ) plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 1" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
        [ -f ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings ] && echo -e '{ \n    "theme": "JupyterLab Light", \n    "theme-scrollbars": false, \n    "overrides": { \n        "code-font-family": null, \n        "code-font-size": null, \n        "content-font-family": null, \n        "content-font-size1": null, \n        "ui-font-family": null, \n        "ui-font-size1": null \n    } \n}' > ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
        echo -e " \n${TEXT_GREEN}Set global theme: Breeze Light${TEXT_RESET} \n" && sleep 1
        ;;
  d|D ) plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 2" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "editor_theme": "Tomorrow Night", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
        [ -f ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings ] && echo -e '{ \n    "theme": "JupyterLab Dark", \n    "theme-scrollbars": false, \n    "overrides": { \n        "code-font-family": null, \n        "code-font-size": null, \n        "content-font-family": null, \n        "content-font-size1": null, \n        "ui-font-family": null, \n        "ui-font-size1": null \n    } \n}' > ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
        echo -e " \n${TEXT_GREEN}Set global theme: Breeze Dark${TEXT_RESET} \n" && sleep 1
        ;;
  * ) 	plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        cp -rf ./cfg/teamviewer/ ~/.config/ && echo -e "[int32] ColorScheme = 1" >> ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{ \n    "initial_working_directory": "~", \n    "posix_terminal_shell": "bash", \n    "pdf_previewer": "none" \n}' > ~/.config/rstudio/rstudio-prefs.json
        [ -f ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings ] && echo -e '{ \n    "theme": "JupyterLab Light", \n    "theme-scrollbars": false, \n    "overrides": { \n        "code-font-family": null, \n        "code-font-size": null, \n        "content-font-family": null, \n        "content-font-size1": null, \n        "ui-font-family": null, \n        "ui-font-size1": null \n    } \n}' > ~/.config/jupyterlab-desktop/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
        echo -e " \n${TEXT_GREEN}Set global theme: Breeze Light (default)${TEXT_RESET} \n" && sleep 1
        ;;
esac

# scaling (take effect after rebooting)
[ ! -d /etc/sddm.conf.d/ ] && sudo mkdir /etc/sddm.conf.d/
echo -e "[Wayland]\nEnableHiDPI=true\n\n[X11]\nEnableHiDPI=true" | sudo tee /etc/sddm.conf.d/hidpi.conf
echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'How would you like to set to the system scaling factor, 250% (a), 200% (b), 150% (c) or default 100% (d)? [a/b/c/d]'$TEXT_RESET)"$' \n' choice
case "$choice" in
  a|A ) # Diskplay and Monitor > Display Configuration > Global scale: 250%
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "2.5"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=2.5;HDMI-1=2.5;DP-1=2.5;DP-2=2.5;DP3=2.5;DP4=2.5;"
        kwriteconfig5 --file ~/.config/kcmfonts --group 'General' --key forceFontDPI "240"
        # Right click on Taskbar, change height to 104
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "104"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "104"
        # System Settings > Appearance > Cursors > Size > 48
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorSize "48"
        # Overview button size: 60, 14, 14
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key fontSize "60"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingLeft "14"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingRight "14"
        # SDDM DPI
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 240" | sudo tee /etc/sddm.conf.d/dpi.conf
        sudo cp -f ./cfg/environment/environment /etc/
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        # notify end
        echo -e " \n${TEXT_GREEN}Set system scaling factor: 250%.${TEXT_RESET} \n"
        ;;
  b|B ) # Diskplay and Monitor > Display Configuration > Global scale: 200%
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "2"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=2;HDMI-1=2;DP-1=2;DP-2=2;DP3=2;DP4=2;"
        kwriteconfig5 --file ~/.config/kcmfonts --group 'General' --key forceFontDPI "192"
        # Right click on Taskbar, change height to 88
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "88"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "88"
        # System Settings > Appearance > Cursors > Size > 48
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorSize "48"
        # Overview button size: 56, 12, 12
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key fontSize "56"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingLeft "12"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingRight "12"
        # SDDM DPI
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 192" | sudo tee /etc/sddm.conf.d/dpi.conf
        sudo cp -f ./cfg/environment/environment /etc/
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        # notify end
        echo -e " \n${TEXT_GREEN}Set system scaling factor: 200%.${TEXT_RESET} \n"
        ;;
  c|C ) # Diskplay and Monitor > Display Configuration > Global scale: 150%
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "1.5"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=1.5;HDMI-1=1.5;DP-1=1.5;DP-2=1.5;DP3=1.5;DP4=1.5;"
        kwriteconfig5 --file ~/.config/kcmfonts --group 'General' --key forceFontDPI "144"
        # Right click on Taskbar, change height to 70
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "70"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "70"
        # System Settings > Appearance > Cursors > Size > 36
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorSize "36"
        # Overview button size: 45, 8, 8
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key fontSize "45"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingLeft "8"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingRight "8"
        # SDDM DPI
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 144" | sudo tee /etc/sddm.conf.d/dpi.conf
        sudo cp -f ./cfg/environment/environment /etc/
        echo -e "XCURSOR_SIZE=36" | sudo tee -a /etc/environment
        # notify end
        echo -e " \n${TEXT_GREEN}Set system scaling factor: 150%.${TEXT_RESET} \n"
        ;;
  * )   # Diskplay and Monitor > Display Configuration > Global scale: 100%
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScaleFactor "1"
        kwriteconfig5 --file ~/.config/kdeglobals --group KScreen --key ScreenScaleFactors "eDP-1=1;HDMI-1=1;DP-1=1;DP-2=1;DP3=1;DP4=1;"
        kwriteconfig5 --file ~/.config/kcmfonts --group 'General' --key forceFontDPI "0"
        # Right click on Taskbar, change height to 44
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness "44"
        kwriteconfig5 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Horizontal3840' --key thickness "44"
        # System Settings > Appearance > Cursors > Size > 24
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorSize "24"
        # Overview button size: 30, 6, 6
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key fontSize "30"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingLeft "6"
        kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '2' --group 'Applets' --group '25' --group 'Configuration' --group 'Appearance' --key paddingRight "6"
        # SDDM DPI
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 96" | sudo tee /etc/sddm.conf.d/dpi.conf
        sudo cp -f ./cfg/environment/environment /etc/
        echo -e "XCURSOR_SIZE=24" | sudo tee -a /etc/environment
        # notify end
        echo -e " \n${TEXT_GREEN}Set system scaling factor: 100%.${TEXT_RESET} \n"
        ;;
esac

# wechat scaling
if [ -d ~/.deepinwine/Deepin-WeChat/ ] 
then
        # configure scaling
        echo -e " \n${TEXT_YELLOW}In the popup window, please navigate to [Graphics] tab.${TEXT_RESET} \n"
        echo -e "${TEXT_YELLOW}Set [Screen resolution] to a comfortable dpi value, such as 240dpi (250%), 192dpi (200%), 144dpi (150%), or default 96dpi (100%), then click [OK] to exit and continue.${TEXT_RESET} \n"
        env WINEPREFIX="$HOME/.deepinwine/Deepin-WeChat" /usr/bin/deepin-wine winecfg 
fi

# grub menu scaling
sudo echo ""
echo -e "${TEXT_YELLOW}Configuring Grub scaling...${TEXT_RESET} \n" && sleep 1
if grep -q "#GRUB_GFXMODE=640x480" /etc/default/grub ; then sudo sed -i 's+#GRUB_GFXMODE=640x480+GRUB_GFXMODE=1024x768+g' /etc/default/grub && sudo update-grub ; fi
# If grub timeout is 0, press Shift+Esc only once at startup to enter grub menu

# language
#kwriteconfig --file kdeglobals --group 'Translations' --key 'LANGUAGE' 'en_US' #https://github.com/nbeaver/config-kde5/blob/master/config-kde.sh

# mark setup.sh
sed -i 's+bash ./cfg/4_sysdsp.sh+#bash ./cfg/4_sysdsp.sh+g' ~/.setup_cache/setup.sh
