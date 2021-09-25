#!/bin/bash

# load dotfiles.config
source $HOME/dotfiles/config/dotfiles.config

# stop timesyncd
systemctl stop systemd-timesyncd.service

# change config
sed -i "s|#NTP=|NTP=$NTPD|g" /etc/systemd/timesyncd.conf

# start timesyncd
systemctl start systemd-timesyncd.service