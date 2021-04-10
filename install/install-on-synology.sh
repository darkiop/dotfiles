#!/bin/bash
#
# WORK IN PROGRESS
#
# manual install on synology dsm (no git)

dotfiles=/var/services/homes/darkiop/dotfiles

# dotfiles dir
if [ ! -d $HOME/dotfiles ]; then
  mkdir $HOME/dotfiles
fi

# download install script
if [ -f $dotfiles/install/install-on-synology.sh ]; then
  rm $dotfiles/install-on-synology.sh
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install/install-on-synology.sh -O $dotfiles/install/install-on-synology.sh
else
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install/install-on-synology.sh -O $dotfiles/install/install-on-synology.sh
fi


# EOF
