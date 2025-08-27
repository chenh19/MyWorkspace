#!/usr/bin/env bash
# This script configures display options

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
echo -e "${TEXT_YELLOW}Setting display options...${TEXT_RESET}\n" && sleep 1

# boot screen
  ## config plymouth
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group boot-up --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group shutdown --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group reboot --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group updates --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group system-upgrade --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group firmware-upgrade --key UseFirmwareBackground "true"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group two-step --key WatermarkHorizontalAlignment "10"
  sudo kwriteconfig5 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group two-step --key WatermarkVerticalAlignment "10"
  if grep -q "Theme=emerald" /usr/share/plymouth/plymouthd.defaults ; then sudo sed -i 's+Theme=emerald+Theme=spinner+g' /usr/share/plymouth/plymouthd.defaults ; fi
  sudo plymouth-set-default-theme -R spinner
  ## config grub (If grub timeout is 0, press Shift+Esc only once at startup to enter grub menu)
  if grep -q "GRUB_TIMEOUT=5" /etc/default/grub ; then sudo sed -i 's+GRUB_TIMEOUT=5+GRUB_TIMEOUT=1+g' /etc/default/grub ; fi
  if grep -q "#GRUB_GFXMODE=640x480" /etc/default/grub ; then sudo sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1280x1024/' /etc/default/grub ; fi
  if ! grep -q "GRUB_BACKGROUND=" /etc/default/grub ; then sudo sed -i '/GRUB_CMDLINE_LINUX=""/a GRUB_BACKGROUND="/opt/grub/grub.png"' /etc/default/grub ; fi
  ## update
  sudo update-grub && echo ""

# global theme
## System Settings > Appearance > Global Theme > Breeze
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Light or Dark theme? [l/d/c]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  d|D ) plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 2" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "editor_theme": "Tomorrow Night",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui-dark.conf ~/.config/fcitx5/conf/classicui.conf
        sed -i '/^icon=\/opt\/icon\/overview-/c\icon=/opt/icon/overview-dark.png' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Dark${TEXT_RESET}\n" && sleep 1
        ;;
  * ) 	plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 1" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui.conf ~/.config/fcitx5/conf/classicui.conf
        sed -i '/^icon=\/opt\/icon\/overview-/c\icon=/opt/icon/overview-light.png' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Light (default)${TEXT_RESET}\n" && sleep 1
        ;;
esac

# scaling (take effect after rebooting; only for x11, will be removed for Wayland)
[ ! -d /etc/sddm.conf.d/ ] && sudo mkdir /etc/sddm.conf.d/
echo -e "[Wayland]\nEnableHiDPI=true\n\n[X11]\nEnableHiDPI=true" | sudo tee /etc/sddm.conf.d/hidpi.conf
echo ""
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'How would you like to set to the system scaling factor, 250% (a), 200% (b), 150% (c) or default 100% (d)? [a/b/c/d]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  a|A ) # Diskplay and Monitor > Display Configuration > Global scale: 250%
        echo ""
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
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 239" | sudo tee /etc/sddm.conf.d/dpi.conf
        echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 250%.${TEXT_RESET}\n"
        ;;
  b|B ) # Diskplay and Monitor > Display Configuration > Global scale: 200%
        echo ""
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
        echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 200%.${TEXT_RESET}\n"
        ;;
  c|C ) # Diskplay and Monitor > Display Configuration > Global scale: 150%
        echo ""
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
        echo -e "[X11]\nServerArguments=-nolisten tcp -dpi 143" | sudo tee /etc/sddm.conf.d/dpi.conf
        echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
        echo -e "XCURSOR_SIZE=36" | sudo tee -a /etc/environment
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 150%.${TEXT_RESET}\n"
        ;;
  * )   # Diskplay and Monitor > Display Configuration > Global scale: 100%
        echo ""
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
        echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
        echo -e "XCURSOR_SIZE=24" | sudo tee -a /etc/environment
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 100%.${TEXT_RESET}\n"
        ;;
esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/2_sysdsp.sh+#bash ./cfg/2_sysdsp.sh+g' ~/.setup_cache/setup.sh
