#!/bin/bash

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/

chmod u+x ~/.setup_cache/src/snapgene.sh
bash ~/.setup_cache/src/snapgene.sh
