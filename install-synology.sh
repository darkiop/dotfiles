#!/bin/bash

home=/var/services/homes/darkiop/dotfiles

wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install-synology.sh -O install-synology.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd.sh -O $home/motd/motd.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd-odin.sh -O $home/motd/motd-odin.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias -O $home/shells/alias
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias-docker -O $home/shells/alias-docker