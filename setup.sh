#!/bin/bash

# create cache directory
cd ~
[ ! -d .setup_cache ] && mkdir .setup_cache

# download setup scripts
cd ./.setup_cache
[ ! -d master ] && wget https://codeload.github.com/chenh19/myworkspace/zip/refs/heads/main && unzip -o -q main && rm main
cd ./myworkspace-main && rm LICENSE README.md setup.sh && cd ./scripts

# run
bash 0_run.sh

# cleanup
#cd ../../../ && rm -rf ./.setup_cache
