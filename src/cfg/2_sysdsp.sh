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

# boot screen # to update
  ## config plymouth
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group boot-up --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group shutdown --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group reboot --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group updates --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group system-upgrade --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group firmware-upgrade --key UseFirmwareBackground --type bool "true"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group two-step --key WatermarkHorizontalAlignment --type string "10"
  sudo kwriteconfig6 --file /usr/share/plymouth/themes/spinner/spinner.plymouth --group two-step --key WatermarkVerticalAlignment --type string "10"
  if grep -q "Theme=emerald" /usr/share/plymouth/plymouthd.defaults ; then sudo sed -i 's+Theme=emerald+Theme=spinner+g' /usr/share/plymouth/plymouthd.defaults ; fi
  sudo plymouth-set-default-theme -R spinner
  ## config grub (If grub timeout is 0, press Shift+Esc only once at startup to enter grub menu)
  if grep -q "GRUB_TIMEOUT=5" /etc/default/grub ; then sudo sed -i 's+GRUB_TIMEOUT=5+GRUB_TIMEOUT=1+g' /etc/default/grub ; fi
  if grep -q "#GRUB_GFXMODE=640x480" /etc/default/grub ; then sudo sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1280x1024/' /etc/default/grub ; fi
  if ! grep -q "GRUB_BACKGROUND=" /etc/default/grub ; then sudo sed -i '/GRUB_CMDLINE_LINUX=""/a GRUB_BACKGROUND="/opt/grub/grub.png"' /etc/default/grub ; fi
  ## update
  sudo update-grub && echo ""

# desktop layout # to update
line="$(grep -wn "wallpaperplugin=org.kde.image" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | cut -d: -f1)"
line=$((line+2))
sed -i "$line,500d" ~/.config/plasma-org.kde.plasma.desktop-appletsrc
cat ~/.setup_cache/cfg/taskbar/plasma-org.kde.plasma.desktop-appletsrc-win >> ~/.config/plasma-org.kde.plasma.desktop-appletsrc
unset line
# Opacity > Translucent; no Floating
kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key panelOpacity --type string "1"
kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key floating --type string "0"

# global theme # to update
## System Settings > Appearance > Global Theme > Breeze
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like Light or Dark theme? [l/d/c]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  d|D ) # global theme
        plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        # app specific
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 2" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "editor_theme": "Tomorrow Night",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui-dark.conf ~/.config/fcitx5/conf/classicui.conf
        sed -i '/^icon=\/opt\/icon\/overview-/c\icon=/opt/icon/overview-dark.png' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        # notify end
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Dark${TEXT_RESET}\n" && sleep 1
        ;;
  * ) 	# global theme
        plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        # app specific
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 1" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui.conf ~/.config/fcitx5/conf/classicui.conf
        sed -i '/^icon=\/opt\/icon\/overview-/c\icon=/opt/icon/overview-light.png' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        # notify end
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Light (default)${TEXT_RESET}\n" && sleep 1
        ;;
esac

# scaling
## Krita
[ -f /usr/share/applications/org.kde.krita.desktop ] && sudo desktop-file-edit \
    --set-key 'Exec' --set-value 'env QT_AUTO_SCREEN_SCALE_FACTOR=1 krita %F' \
/usr/share/applications/org.kde.krita.desktop
[ ! -d /etc/sddm.conf.d/ ] && sudo mkdir /etc/sddm.conf.d/
echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment
read -n1 -s -r -p "$(echo -e '\n'$TEXT_YELLOW'How would you like to set to the system scaling factor, 250% (a), 200% (b), 150% (c) or default 100% (d)? [a/b/c/d]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  a|A ) # System Settings > Input & Output > Display & Monitor > Scale: 250%
        echo ""
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.2.5
        # SDDM DPI
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        sudo cp -f ./cfg/sddm.conf.d/dpi-2.5.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        [ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2.5 /usr/bin/zoom %U' \
        /usr/share/applications/Zoom.desktop
        ## TeamViewer
        [ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2.5 /opt/teamviewer/tv_bin/script/teamviewer' \
        /usr/share/applications/com.teamviewer.TeamViewer.desktop
        ## 4Kvideodownloader
        [ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2.5 4kvideodownloaderplus' \
        /usr/share/applications/4kvideodownloaderplus.desktop
        ## Eudic
        [ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2.5 /usr/share/eusoft-eudic/AppRun %F' \
        /usr/share/applications/eusoft-eudic.desktop
        ## WeChat
        [ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2.5 /usr/bin/wechat %U' \
        /usr/share/applications/wechat.desktop
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 250%.${TEXT_RESET}\n"
        ;;
  b|B ) # System Settings > Input & Output > Display & Monitor > Scale: 200%
        echo ""
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.2
        # SDDM DPI
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment
        sudo cp -f ./cfg/sddm.conf.d/dpi-2.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        [ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2 /usr/bin/zoom %U' \
        /usr/share/applications/Zoom.desktop
        ## TeamViewer
        [ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2 /opt/teamviewer/tv_bin/script/teamviewer' \
        /usr/share/applications/com.teamviewer.TeamViewer.desktop
        ## 4Kvideodownloader
        [ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2 4kvideodownloaderplus' \
        /usr/share/applications/4kvideodownloaderplus.desktop
        ## Eudic
        [ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=2 /usr/share/eusoft-eudic/AppRun %F' \
        /usr/share/applications/eusoft-eudic.desktop
        ## WeChat
        [ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2 /usr/bin/wechat %U' \
        /usr/share/applications/wechat.desktop
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 200%.${TEXT_RESET}\n"
        ;;
  c|C ) # System Settings > Input & Output > Display & Monitor > Scale: 150%
        echo ""
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.1.5
        # SDDM DPI
        echo -e "XCURSOR_SIZE=36" | sudo tee -a /etc/environment
        sudo cp -f ./cfg/sddm.conf.d/dpi-1.5.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        [ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1.5 /usr/bin/zoom %U' \
        /usr/share/applications/Zoom.desktop
        ## TeamViewer
        [ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1.5 /opt/teamviewer/tv_bin/script/teamviewer' \
        /usr/share/applications/com.teamviewer.TeamViewer.desktop
        ## 4Kvideodownloader
        [ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1.5 4kvideodownloaderplus' \
        /usr/share/applications/4kvideodownloaderplus.desktop
        ## Eudic
        [ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1.5 /usr/share/eusoft-eudic/AppRun %F' \
        /usr/share/applications/eusoft-eudic.desktop
        ## WeChat
        [ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1.5 /usr/bin/wechat %U' \
        /usr/share/applications/wechat.desktop
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 150%.${TEXT_RESET}\n"
        ;;
  * )   # System Settings > Input & Output > Display & Monitor > Scale: 100%
        echo ""
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.1
        # SDDM DPI
        echo -e "XCURSOR_SIZE=24" | sudo tee -a /etc/environment
        sudo cp -f ./cfg/sddm.conf.d/dpi-1.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        [ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1 /usr/bin/zoom %U' \
        /usr/share/applications/Zoom.desktop
        ## TeamViewer
        [ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1 /opt/teamviewer/tv_bin/script/teamviewer' \
        /usr/share/applications/com.teamviewer.TeamViewer.desktop
        ## 4Kvideodownloader
        [ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1 4kvideodownloaderplus' \
        /usr/share/applications/4kvideodownloaderplus.desktop
        ## Eudic
        [ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_SCALE_FACTOR=1 /usr/share/eusoft-eudic/AppRun %F' \
        /usr/share/applications/eusoft-eudic.desktop
        ## WeChat
        [ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit \
            --set-key 'Exec' --set-value 'env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1 /usr/bin/wechat %U' \
        /usr/share/applications/wechat.desktop
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 100%.${TEXT_RESET}\n"
        ;;
esac

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/2_sysdsp.sh+#bash ./cfg/2_sysdsp.sh+g' ~/.setup_cache/setup.sh
