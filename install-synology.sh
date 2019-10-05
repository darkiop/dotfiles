#!/bin/bash

dotfiles=/var/services/homes/darkiop/dotfiles

wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install-synology.sh -O $dotfiles/install-synology.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd.sh -O $dotfiles/motd/motd.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd-odin.sh -O $dotfiles/motd/motd-odin.sh
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias -O $dotfiles/shells/alias
wget -q --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias-docker -O $dotfiles/shells/alias-docker

# EOF