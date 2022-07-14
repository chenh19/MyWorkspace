#!/bin/bash
# This script installs Python developing environment

# set terminal font color
TEXT_YELLOW='\e[1;33m'
TEXT_GREEN='\e[1;32m'
TEXT_RESET='\e[0m'

# set working directory
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/



# mark setup.sh
sed -i 's+bash ./src/biodevpy.sh+#bash ./src/biodevpy.sh+g' ~/.setup_cache/setup.sh
