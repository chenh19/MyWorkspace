#!/usr/bin/env bash
# This script intsalls iOpenPod

# iOpenPod
[ ! -f iOpenPod-Linux.tar.gz ] && wget -q "https://www.dropbox.com/scl/fi/dik3xnklvjdooamhdvv72/iOpenPod-Linux.tar.gz?rlkey=o38bsfrq59pb8tlozfxyvmkiy" -O iOpenPod-Linux.tar.gz && sleep 1
[ ! -f ffmpeg.tar.xz ] && wget -q "https://www.dropbox.com/scl/fi/w37apnsoxbqxfl8cj96r9/ffmpeg.tar.xz?rlkey=ktgu63ye13rmq4o4kw5zeqo86" -O ffmpeg.tar.xz && sleep 1
[ ! -f fpcalc.tar.gz ] && wget -q "https://www.dropbox.com/scl/fi/6o7siid927tkh8rqowslh/fpcalc.tar.gz?rlkey=ekkx4unj1vwhhy23dq9urzyn7" -O fpcalc.tar.gz && sleep 1
tar -xzf iOpenPod-Linux.tar.gz && sleep 1 && rm -f iOpenPod-Linux.tar.gz && sleep 1
tar -xJf ffmpeg.tar.xz && sleep 1 && rm -f ffmpeg.tar.xz && sleep 1
mv ./ffmpeg-*/ ./ffmpeg/ && sleep 1
tar -xzf fpcalc.tar.gz && sleep 1 && rm -f fpcalc.tar.gz && sleep 1
mv ./chromaprint-fpcalc-*/ ./fpcalc/ && sleep 1
cp -f ./ffmpeg/bin/ffmpeg ./fpcalc/fpcalc ./iOpenPod/ && sleep 1
rm -rf ./ffmpeg/ ./fpcalc/ && sleep 1
sudo cp -f ./iOpenPod/_internal/assets/icons/icon-256.png /opt/icon/iopenpod.png && sleep 1
sudo cp -rf ./iOpenPod/ /opt/ && sleep 1
sudo rm -rf ./iOpenPod/

# config
mkdir -p ~/.config/iOpenPod/
echo -e '{\n  "ffmpeg_path": "/opt/iOpenPod/ffmpeg",\n  "fpcalc_path": "/opt/iOpenPod/fpcalc",\n  "lossy_quality": "high",\n  "backup_before_sync": false\n}' > ~/.config/iOpenPod/settings.json

# shortcut
[ ! -f /usr/share/applications/iopenpod.desktop ] && sudo touch /usr/share/applications/iopenpod.desktop
sudo desktop-file-edit \
    --set-name 'iOpenPod' --set-key 'Name[en_US]' --set-value 'iOpenPod' --set-key 'Name[zh_CN]' --set-value 'iOpenPod' \
    --set-comment 'Open-source iPod Sync Tool' --set-key 'Comment[en_US]' --set-value 'Open-source iPod Sync Tool' --set-key 'Comment[zh_CN]' --set-value '开源iPod同步工具' \
    --set-generic-name 'Manage your iPod without iTunes' --set-key 'GenericName[en_US]' --set-value 'Manage your iPod without iTunes' --set-key 'GenericName[zh_CN]' --set-value '告别 iTunes，重新掌控你的 iPod' \
    --set-key 'Exec' --set-value '/opt/iOpenPod/iOpenPod' \
    --set-icon '/opt/icon/iopenpod.png' \
    --set-key 'StartupNotify' --set-value 'true' \
    --set-key 'Terminal' --set-value 'false' \
    --set-key 'Type' --set-value 'Application' \
    --remove-key 'Categories' --add-category 'AudioVideo;' \
/usr/share/applications/iopenpod.desktop
