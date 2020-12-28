#!/bin/bash
#
# install dotfies from github
# curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-from-git.sh | bash -

# check for curl + git and install if necessary
if [!dpkg -s git >/dev/null 2>&1]; then
  sudo apt update
  sudo apt install git -y
fi

if [!dpkg -s curl >/dev/null 2>&1]; then
  sudo apt update
  sudo apt install curl -y
fi

# git clone
git clone https://github.com/darkiop/dotfiles $HOME/dotfiles

# install
bash $HOME/dotfiles/install-applications.sh
bash $HOME/dotfiles/install-bashrc.sh

# EOF
