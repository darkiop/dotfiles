#!/bin/bash
# install dotfies from github
# curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-from-git.sh | bash -

if [ -d $HOME/dotfiles ]; then
  echo -e "$red_color"
  read -p "dotfiles exists - Re-Install! Are you sure? ~/dotfiles will be deleted! (y/n):" reinstall
  echo -e "$close_color"
  if [ $reinstall == "y" ]; then
    curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-reinstall.sh | bash -
  else
    exit
  fi
else
  # git clone
  echo
  echo -e $green_color"clone"$close_color$yellow_color" dotfiles "$green_color"from github ..."$close_color
  git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
fi

# install
bash $HOME/dotfiles/install-applications.sh
bash $HOME/dotfiles/install-bashrc.sh

# EOF
