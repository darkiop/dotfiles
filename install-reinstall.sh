#!/bin/bash

echo -e "$blue_color"
read -p "Re-Install! Are you sure? ~/dotfiles will be deleted! (y/n):" reinstall
echo -e "$close_color"
if [ $reinstall == "y" ]; then
  cd ~
  echo -e $green_color"delete"$close_color$yellow_color" ~/dotfiles "$green_color"..."$close_color
  sudo rm -r ~/dotfiles
  echo
  echo -e $green_color"reinstall "$close_color$yellow_color" ~/dotfiles "$green_color"..."$close_color
  git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
  bash ~/dotfiles/install-bashrc.sh
else
  echo "n"
fi

# EOF