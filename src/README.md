# Bash Script Template

```
#!/usr/bin/env bash
# This script does xxx

# set terminal font color
TEXT_YELLOW="$(tput bold)$(tput setaf 3)"
TEXT_GREEN="$(tput bold)$(tput setaf 2)"
TEXT_RESET="$(tput sgr0)"

# set working directory
sudo echo ""
[ ! -d ~/.setup_cache/ ] && mkdir ~/.setup_cache/
cd ~/.setup_cache/


# notify start
echo -e "${TEXT_YELLOW}Starting...${TEXT_RESET}\n" && sleep 1

# install

# configure


# cleanup

# notify end
echo -e "\n${TEXT_GREEN}Done!${TEXT_RESET}\n" && sleep 5

# mark setup.sh
sed -i 's+bash ./src/template.sh+#bash ./src/template.sh+g' ~/.setup_cache/setup.sh
```
