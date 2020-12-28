#!/bin/bash
# install dotfies from github
# curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-from-git.sh | bash -

# git clone
echo
echo -e $green_color"clone"$close_color$yellow_color" dotfiles "$green_color"from github ..."$close_color
git clone https://github.com/darkiop/dotfiles $HOME/dotfiles

# install
bash $HOME/dotfiles/install-applications.sh
bash $HOME/dotfiles/install-bashrc.sh

# EOF
