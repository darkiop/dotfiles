#!/bin/bash
#
# manual install on synology dsm (no git)

dotfiles=/var/services/homes/darkiop/dotfiles

# install script
if [ -f $dotfiles/motd/motd.sh ]; then
  rm $dotfiles/install-on-synology.sh
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/install-synology.sh -O $dotfiles/install-on-synology.sh
fi

# motd
if [ ! -d $dotfiles/motd ]; then
  mkdir $dotfiles/motd
fi
if [ -f $dotfiles/motd/motd.sh ]; then
  rm $dotfiles/motd/motd.sh
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd.sh -O $dotfiles/motd/motd.sh
fi

# motd for odin
if [ -f $dotfiles/motd ]; then
  rm $dotfiles/motd/motd-odin.sh
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/motd/motd-odin.sh -O $dotfiles/motd/motd-odin.sh
fi

if [ ! -d $dotfiles/motd ]; then
  mkdir $dotfiles/shells
fi
if [ -f $dotfiles/motd ]; then
  rm $dotfiles/shells/alias
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias -O $dotfiles/shells/alias
fi
if [ -f $dotfiles/motd ]; then
  rm $dotfiles/shells/alias-docker
  wget --no-cache https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias-docker -O $dotfiles/shells/alias-docker
fi

# bin
if [ ! -d $dotfiles/bin ]; then
  mkdir $dotfiles/bin
fi

# EOF
