#!/bin/bash
#
# dotfiles install skript

# time=$(date +%Y-%m-%d_%T)

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# install
dir=~/dotfiles
files="bashrc vimrc gitconfig inputrc bash_profile dircolors"
folders="byobu vim"

echo

# delete old symlinks
echo -e $green_color"delete"$close_color$yellow_color" old "$green_color"symlinks ..."$close_color
for file in $files; do
  if [ -f ~/.$file ]; then
    echo "delete existing symlink (file):  ~/.$file"
    rm ~/.$file
  fi
done
for folder in $folders; do
  if [ -d ~/.$folder ]; then
    echo "delete existing symlink (folder): $folder";
    rm -r ~/.$folder
  fi
done

echo

# new symlinks for files and folders
echo -e $green_color"create"$close_color$yellow_color" new "$green_color"symlinks ..."$close_color
for file in $files; do
    echo "creating new symlink (file): ~/.$file"
    ln -s $dir/$file ~/.$file
done
for folder in $folders; do
    echo "creating new symlink (folder): ~/.$folder"
    ln -s $dir/$folder ~/.$folder
done

# lsd config file
if [ ! -L ~/.config/lsd/config.yaml ] ; then
  if [ ! -d ~/.config/lsd ]; then
    mkdir -p ~/.config/lsd
    ln -s ~/dotfiles/lsd.config.yaml ~/.config/lsd/config.yaml
  else
    ln -s ~/dotfiles/lsd.config.yaml ~/.config/lsd/config.yaml
  fi
fi

# load .bashrc
echo -e "$blue_color"
read -p "load ~/.bashrc?  (y/n):" instapp
echo -e "$close_color"
if [ $instapp == "y" ]; then
  bash ~/.bashrc
else
  echo -e $green_color"done. type"$close_color$yellow_color" source ~/.bashrc "$green_color"to load the dotfiles"$close_color
  echo
fi

# EOF
