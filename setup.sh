#!/bin/bash
# create cache directory and download setup scripts
cd ~
[ ! -d .setup_cache ] && mkdir .setup_cache
cd ./.setup_cache
[ ! -d master ] && wget https://codeload.github.com/chenh19/myworkspace/zip/refs/heads/main && unzip -o -q main && rm main
cd ./myworkspace-main && rm LICENSE README.md && cd ./scripts
# update
bash 1_update.sh
# cleanup
# cd ../../../ && rm -rf ./.setup_cache
