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

dir=~/dotfiles
files="bashrc vimrc gitconfig inputrc bash_profile dircolors"
folders="byobu vim"

# delete old symlinks
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

# new symlinks for files and folders
for file in $files; do
    echo "creating new symlink (file): ~/.$file"
    ln -s $dir/$file ~/.$file
done
for folder in $folders; do
    echo "creating new symlink (folder): ~/.$folder"
    ln -s $dir/$folder ~/.$folder
done

# dircolors
ln -s $dir/dircolors ~/.dir_colors

echo -e $green_color"done. type"$close_color$yellow_color" source ~/.bashrc "$green_color"to load the dotfiles"$close_color

# EOF
