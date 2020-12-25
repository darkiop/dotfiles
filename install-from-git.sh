#!/bin/bash
# install dotfies from github

# create dotfiles dir
if [ ! -d ~/dotfiles ]; then
  mkdir ~/dotfiles
fi
cd ~/dotfiles

# clone from github
git clone https://github.com/darkiop/dotfiles.git .

# install
bash ~/dotfiles/install-applications.sh
bash ~/dotfiles/install-bashrc.sh

# load the new bashrc
source ~/.bashrc

# EOF
