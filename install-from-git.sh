#!/bin/bash
#
# install dotfies from github
# curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-from-git.sh | bash -

# check for curl + git and install if necessary
pkgs='curl git'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt update
  sudo apt install $pkgs
fi

# create dotfiles dir
#if [ ! -d ~/dotfiles ]; then
#  mkdir ~/dotfiles
#fi
#cd ~/dotfiles

# clone from github
git clone https://github.com/darkiop/dotfiles $HOME/dotfiles

# install
bash $HOME/dotfiles/install-applications.sh
bash $HOME/dotfiles/install-bashrc.sh

# load the new bashrc
bash $HOME/.bashrc

# EOF
