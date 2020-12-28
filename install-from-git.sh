#!/bin/bash
# install dotfies from github
# curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/install-from-git.sh | bash -

if [ -d $HOME/dotfiles ]; then
  # dotfiles dir exist
  echo -e "$red_color"
  read -p "dotfiles exists - Re-Install! Are you sure? ~/dotfiles will be deleted! (y/n):" reinstall
  echo -e "$close_color"
  if [ $reinstall == "y" ]; then
    cd $HOME
    echo -e $green_color"delete"$close_color$yellow_color" ~/dotfiles "$green_color"..."$close_color
    sudo rm -r $HOME/dotfiles
    echo
    echo -e $green_color"reinstall "$close_color$yellow_color" ~/dotfiles "$green_color"..."$close_color
    git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
    bash $HOME/dotfiles/install-bashrc.sh
  else
    echo -e $red_color"exit ..."$close_color
    exit
  fi
else
  # dotfiles dir do not exist
  # clone from git
  echo -e $green_color"clone"$close_color$yellow_color" dotfiles "$green_color"from github ..."$close_color
  git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
  # install
  bash $HOME/dotfiles/install-applications.sh
  bash $HOME/dotfiles/install-bashrc.sh
fi

# EOF