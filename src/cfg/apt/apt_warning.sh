#!/bin/bash
# This script helps transfer legacy gpg

# set variables
resilio_id=
fdm_id=
slack_id=

# resilio
sudo apt-key export $resilio_id | sudo gpg --dearmour -o /usr/share/keyrings/pgdg_resilio.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgdg_resilio.gpg] http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
sudo apt-key del $resilio_id

# fdm
sudo apt-key export $fdm_id | sudo gpg --dearmour -o /usr/share/keyrings/pgdg_fdm.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgdg_fdm.gpg] https://debrepo.freedownloadmanager.org/ bionic main" | sudo tee /etc/apt/sources.list.d/freedownloadmanager.list
sudo apt-key del $fdm_id

# slack
sudo apt-key export $slack_id | sudo gpg --dearmour -o /usr/share/keyrings/pgdg_slack.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgdg_slack.gpg] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee /etc/apt/sources.list.d/slack.list
sudo apt-key del $slack_id

# unset variables
unset resilio_id
unset fdm_id
unset slack_id

# check apt
sudo apt update




