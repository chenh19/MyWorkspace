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
echo -e "${TEXT_YELLOW}Configuring display settings...${TEXT_RESET}\n" && sleep 1

# desktop layout
[ -f ~/Desktop/Dolphin.desktop ] && rm -f ~/Desktop/Dolphin.desktop
[ -f ~/Desktop/Chrome.desktop ] && rm -f ~/Desktop/Chrome.desktop
[ -f ~/Desktop/Trash.desktop ] && rm -f ~/Desktop/Trash.desktop
read -n1 -s -r -p "$(echo -e $TEXT_YELLOW'Would you like a Windows-style (default) or Mac-style layout? [w/m]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  m|M ) # desktop layout (mac)
        line="$(grep -wn "wallpaperplugin=org.kde.image" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | cut -d: -f1)"
        line=$((line+2))
        sed -i "$line,500d" ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        cat ~/.setup_cache/cfg/taskbar/plasma-org.kde.plasma.desktop-appletsrc-mac >> ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        unset line
        # Show Panel Configuration > Opacity > Translucent; no Floating
        [ -f ~/.config/plasmashellrc ] && rm -f ~/.config/plasmashellrc
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key panelOpacity --type string "2"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key floating --type string "0"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness --type string "28"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 3' --key panelOpacity --type string "2"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 3' --key floating --type string "0"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 3' --key panelLengthMode --type string "1"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 3' --group 'Defaults' --key thickness --type string "56"
        # System Settings > Colors & Themes > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
        kwriteconfig6 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft --type string "XIA"
        kwriteconfig6 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight --type string ""
        # wallpaper
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key Image --type string "file://$HOME/.config/background/13-14inch.png"
        # System Settings > App & Windows > Window Management > Desktop Effects > Appearance > select "Magic Lamp"
        kwriteconfig6 --file ~/.config/kwinrc --group Plugins --key magiclampEnabled --type bool "true"
        kwriteconfig6 --file ~/.config/kwinrc --group Plugins --key squashEnabled --type bool "false"
        # restart kwin
        kwin_wayland --replace >/dev/null 2>&1 & disown
        sleep 3
        # wallpaper (cont.)
        sudo bash ~/.config/background/sddm.sh ~/Pictures/System/13-14inch.png >/dev/null 2>&1
        bash ~/.config/background/wallpaper.sh ~/Pictures/System/13-14inch.png >/dev/null 2>&1
        # restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set desktop layout: Mac-style${TEXT_RESET}\n" && sleep 1
        ;;
  * ) 	# desktop layout (win)
        line="$(grep -wn "wallpaperplugin=org.kde.image" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | cut -d: -f1)"
        line=$((line+2))
        sed -i "$line,500d" ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        cat ~/.setup_cache/cfg/taskbar/plasma-org.kde.plasma.desktop-appletsrc-win >> ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        unset line
        # Show Panel Configuration > Opacity > Translucent; no Floating
        [ -f ~/.config/plasmashellrc ] && rm -f ~/.config/plasmashellrc
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key panelOpacity --type string "2"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --key floating --type string "0"
        kwriteconfig6 --file ~/.config/plasmashellrc --group 'PlasmaViews' --group 'Panel 2' --group 'Defaults' --key thickness --type string "44"
        # System Settings > Colors & Themes > Window Decorations > Titlebar Buttons > drag and remove "On all desktops"
        kwriteconfig6 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft --type string "M"
        kwriteconfig6 --file ~/.config/kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight --type string "IAX"
        # wallpaper
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'Wallpaper' --group 'org.kde.image' --group 'General' --key Image --type string "file://$HOME/.config/background/13-14inch.png"
        # System Settings > App & Windows > Window Management > Desktop Effects > Appearance > select "Squash"
        if grep -q "^magiclampEnabled" ~/.config/kwinrc ; then sed -i '/^magiclampEnabled/d' ~/.config/kwinrc ; fi
        if grep -q "^squashEnabled" ~/.config/kwinrc ; then sed -i '/^squashEnabled/d' ~/.config/kwinrc ; fi
        # restart kwin
        kwin_wayland --replace >/dev/null 2>&1 & disown
        sleep 3
        # wallpaper (cont.)
        sudo bash ~/.config/background/sddm.sh ~/Pictures/System/13-14inch.png >/dev/null 2>&1
        bash ~/.config/background/wallpaper.sh ~/Pictures/System/13-14inch.png >/dev/null 2>&1
        # restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set desktop layout: Windows-style (default)${TEXT_RESET}\n" && sleep 1
        ;;
esac

# global theme
## System Settings > Appearance > Global Theme > Breeze
read -n1 -s -r -p "$(echo -e '\n'$TEXT_YELLOW'Would you like Light or Dark (default) theme? [l/d/c]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  l|L ) # global theme
        plasma-apply-lookandfeel --apply org.kde.breeze.desktop
        # app specific
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 1" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui.conf ~/.config/fcitx5/conf/classicui.conf
        # restart plasma shell again
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Light${TEXT_RESET}\n" && sleep 1
        ;;
  * ) 	# global theme
        plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
        # app specific
        echo -e "TeamViewer User Settings\n# It is not recommended to edit this file manually\n\n\n[int32] MainWindowSize = 888 526 510 1032\n[int32] OnboardingTaskState = 1 1 1\n[int32] PilotTabWasEnabled = 1\n[int32] Remote_RemoveWallpaper = 0\n[int32] ColorScheme = 2" > ~/.config/teamviewer/client.conf
        [ -f ~/.config/rstudio/rstudio-prefs.json ] && echo -e '{\n    "initial_working_directory": "~",\n    "posix_terminal_shell": "bash",\n    "editor_theme": "Tomorrow Night",\n    "pdf_previewer": "none"\n}' > ~/.config/rstudio/rstudio-prefs.json
        cp -rf ~/.setup_cache/cfg/fcitx5/conf/classicui-dark.conf ~/.config/fcitx5/conf/classicui.conf
        # restart plasma shell again
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set global theme: Breeze Dark (default)${TEXT_RESET}\n" && sleep 1
        ;;
esac

# scaling
## Krita
[ -f /usr/share/applications/org.kde.krita.desktop ] && sudo desktop-file-edit --set-key 'Exec' --set-value 'env QT_AUTO_SCREEN_SCALE_FACTOR=1 krita %F' /usr/share/applications/org.kde.krita.desktop >/dev/null 2>&1
echo '#!/usr/bin/env bash' > ~/.scale.sh
[ ! -d /etc/sddm.conf.d/ ] && sudo mkdir /etc/sddm.conf.d/
echo -e 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"\nXMODIFIERS=@im=fcitx' | sudo tee /etc/environment > /dev/null
#xrandr | grep " connected primary" to update
read -n1 -s -r -p "$(echo -e '\n'$TEXT_YELLOW'How would you like to set to the system scaling factor, 250% (a), 200% (b), 150% (c) or default 100% (d)? [a/b/c/d]'$TEXT_RESET)"$'\n' choice
case "$choice" in
  a|A ) # System Settings > Input & Output > Display & Monitor > Scale: 250%
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.2.5
        # SDDM DPI
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment > /dev/null
        sudo cp -f ./cfg/sddm.conf.d/dpi-2.5.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        echo '[ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2.5 /usr/bin/zoom %U" /usr/share/applications/Zoom.desktop' >> ~/.scale.sh
        ## TeamViewer
        echo '[ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2.5 /opt/teamviewer/tv_bin/script/teamviewer" /usr/share/applications/com.teamviewer.TeamViewer.desktop' >> ~/.scale.sh
        ## 4Kvideodownloader
        echo '[ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2.5 4kvideodownloaderplus" /usr/share/applications/4kvideodownloaderplus.desktop' >> ~/.scale.sh
        ## Eudic
        echo '[ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2.5 /usr/share/eusoft-eudic/AppRun %F" /usr/share/applications/eusoft-eudic.desktop' >> ~/.scale.sh
        ## WeChat
        echo '[ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2.5 /usr/bin/wechat %U" /usr/share/applications/wechat.desktop' >> ~/.scale.sh
        ## FastQC
        echo '[ -f /usr/share/applications/fastqc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env GDK_SCALE=2.5 fastqc" /usr/share/applications/fastqc.desktop' >> ~/.scale.sh
        ## Enpass
        echo '[ -f /usr/share/applications/enpass.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=2.5 /opt/enpass/Enpass %U" /usr/share/applications/enpass.desktop' >> ~/.scale.sh
        ## VLC
        echo '[ -f /usr/share/applications/vlc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=2.5 /usr/bin/vlc --started-from-file %U" /usr/share/applications/vlc.desktop' >> ~/.scale.sh
        # desktop icon size
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --key 'formfactor' --type string "0"
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'General' --key 'iconSize' --type string "2"
        ## restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 250%${TEXT_RESET}\n" && sleep 1
        ;;
  b|B ) # System Settings > Input & Output > Display & Monitor > Scale: 200%
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.2
        # SDDM DPI
        echo -e "XCURSOR_SIZE=48" | sudo tee -a /etc/environment > /dev/null
        sudo cp -f ./cfg/sddm.conf.d/dpi-2.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        echo '[ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2 /usr/bin/zoom %U" /usr/share/applications/Zoom.desktop' >> ~/.scale.sh
        ## TeamViewer
        echo '[ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2 /opt/teamviewer/tv_bin/script/teamviewer" /usr/share/applications/com.teamviewer.TeamViewer.desktop' >> ~/.scale.sh
        ## 4Kvideodownloader
        echo '[ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=2 4kvideodownloaderplus" /usr/share/applications/4kvideodownloaderplus.desktop' >> ~/.scale.sh
        ## Eudic
        echo '[ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2 /usr/share/eusoft-eudic/AppRun %F" /usr/share/applications/eusoft-eudic.desktop' >> ~/.scale.sh
        ## WeChat
        echo '[ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=2 /usr/bin/wechat %U" /usr/share/applications/wechat.desktop' >> ~/.scale.sh
        ## FastQC
        echo '[ -f /usr/share/applications/fastqc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env GDK_SCALE=2 fastqc" /usr/share/applications/fastqc.desktop' >> ~/.scale.sh
        ## Enpass
        echo '[ -f /usr/share/applications/enpass.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=2 /opt/enpass/Enpass %U" /usr/share/applications/enpass.desktop' >> ~/.scale.sh
        ## VLC
        echo '[ -f /usr/share/applications/vlc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=2 /usr/bin/vlc --started-from-file %U" /usr/share/applications/vlc.desktop' >> ~/.scale.sh
        # desktop icon size
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --key 'formfactor' --type string "0"
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'General' --key 'iconSize' --type string "2"
        ## restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 200%${TEXT_RESET}\n" && sleep 1
        ;;
  c|C ) # System Settings > Input & Output > Display & Monitor > Scale: 150%
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.1.5
        # SDDM DPI
        echo -e "XCURSOR_SIZE=36" | sudo tee -a /etc/environment > /dev/null
        sudo cp -f ./cfg/sddm.conf.d/dpi-1.5.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        echo '[ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1.5 /usr/bin/zoom %U" /usr/share/applications/Zoom.desktop' >> ~/.scale.sh
        ## TeamViewer
        echo '[ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1.5 /opt/teamviewer/tv_bin/script/teamviewer" /usr/share/applications/com.teamviewer.TeamViewer.desktop' >> ~/.scale.sh
        ## 4Kvideodownloader
        echo '[ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1.5 4kvideodownloaderplus" /usr/share/applications/4kvideodownloaderplus.desktop' >> ~/.scale.sh
        ## Eudic
        echo '[ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1.5 /usr/share/eusoft-eudic/AppRun %F" /usr/share/applications/eusoft-eudic.desktop' >> ~/.scale.sh
        ## WeChat
        echo '[ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1.5 /usr/bin/wechat %U" /usr/share/applications/wechat.desktop' >> ~/.scale.sh
        ## FastQC
        echo '[ -f /usr/share/applications/fastqc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env GDK_SCALE=1.5 fastqc" /usr/share/applications/fastqc.desktop' >> ~/.scale.sh
        ## Enpass
        echo '[ -f /usr/share/applications/enpass.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=1.5 /opt/enpass/Enpass %U" /usr/share/applications/enpass.desktop' >> ~/.scale.sh
        ## VLC
        echo '[ -f /usr/share/applications/vlc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=1.5 /usr/bin/vlc --started-from-file %U" /usr/share/applications/vlc.desktop' >> ~/.scale.sh
        # desktop icon size
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --key 'formfactor' --type string "0"
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'General' --key 'iconSize' --type string "2"
        ## restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 150%${TEXT_RESET}\n" && sleep 1
        ;;
  * )   # System Settings > Input & Output > Display & Monitor > Scale: 100%
        kscreen-doctor output.$(kscreen-doctor -o | grep -m1 "Output:" | cut -d' ' -f3).scale.1
        # SDDM DPI
        echo -e "XCURSOR_SIZE=24" | sudo tee -a /etc/environment > /dev/null
        sudo cp -f ./cfg/sddm.conf.d/dpi-1.conf /etc/sddm.conf.d/dpi.conf
        # app specific
        ## Zoom
        echo '[ -f /usr/share/applications/Zoom.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1 /usr/bin/zoom %U" /usr/share/applications/Zoom.desktop' >> ~/.scale.sh
        ## TeamViewer
        echo '[ -f /usr/share/applications/com.teamviewer.TeamViewer.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1 /opt/teamviewer/tv_bin/script/teamviewer" /usr/share/applications/com.teamviewer.TeamViewer.desktop' >> ~/.scale.sh
        ## 4Kvideodownloader
        echo '[ -f /usr/share/applications/4kvideodownloaderplus.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_SCALE_FACTOR=1 4kvideodownloaderplus" /usr/share/applications/4kvideodownloaderplus.desktop' >> ~/.scale.sh
        ## Eudic
        echo '[ -f /usr/share/applications/eusoft-eudic.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1 /usr/share/eusoft-eudic/AppRun %F" /usr/share/applications/eusoft-eudic.desktop' >> ~/.scale.sh
        ## WeChat
        echo '[ -f /usr/share/applications/wechat.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_IM_MODULE=fcitx QT_SCALE_FACTOR=1 /usr/bin/wechat %U" /usr/share/applications/wechat.desktop' >> ~/.scale.sh
        ## FastQC
        echo '[ -f /usr/share/applications/fastqc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env GDK_SCALE=1 fastqc" /usr/share/applications/fastqc.desktop' >> ~/.scale.sh
        ## Enpass
        echo '[ -f /usr/share/applications/enpass.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=1 /opt/enpass/Enpass %U" /usr/share/applications/enpass.desktop' >> ~/.scale.sh
        ## VLC
        echo '[ -f /usr/share/applications/vlc.desktop ] && sudo desktop-file-edit --set-key Exec --set-value "env QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCREEN_SCALE_FACTORS=1 /usr/bin/vlc --started-from-file %U" /usr/share/applications/vlc.desktop' >> ~/.scale.sh
        # desktop icon size
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --key 'formfactor' --type string "0"
        kwriteconfig6 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc --group 'Containments' --group '1' --group 'General' --key 'iconSize' --type string "2"
        ## restart plasma shell
        plasmashell --replace >/dev/null 2>&1 & disown
        sleep 3
        # notify end
        echo -e "\n${TEXT_GREEN}Set system scaling factor: 100% (default)${TEXT_RESET}\n" && sleep 1
        ;;
esac

# finalize
echo -e "\n${TEXT_YELLOW}Finalizing...${TEXT_RESET}\n" && sleep 1
[ -f ~/.scale.sh ] && bash ~/.scale.sh >/dev/null 2>&1
[ -f ~/.shortcut.sh ] && bash ~/.shortcut.sh >/dev/null 2>&1
[ -f ~/.size-restore.sh ] && bash ~/.size-restore.sh >/dev/null 2>&1
if grep -q "plugin=org.kde.plasma.showdesktop" ~/.config/plasma-org.kde.plasma.desktop-appletsrc; then
    cp -f /usr/share/applications/org.kde.dolphin.desktop ~/Desktop/Dolphin.desktop && chmod +x ~/Desktop/Dolphin.desktop && sleep 1
    cp -f /usr/share/applications/google-chrome.desktop ~/Desktop/Chrome.desktop && chmod +x ~/Desktop/Chrome.desktop && sleep 1
    echo -e "[Desktop Entry]\nEmptyIcon=user-trash\nIcon=user-trash-full\nName=Trash\nType=Link\nURL[\$e]=trash:/" > ~/Desktop/Trash.desktop && sleep 1
fi

# mark setup.sh
[ -f ~/.setup_cache/setup.sh ] && sed -i 's+bash ./cfg/2_sysdsp.sh+#bash ./cfg/2_sysdsp.sh+g' ~/.setup_cache/setup.sh
