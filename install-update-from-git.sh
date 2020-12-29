#!/bin/bash

git status > /dev/null 2>&1 &

if git diff-index --quiet HEAD --; then
  # no changes
  cd ~/dotfiles
  git pull
  cd ~
  bash ~/.bashrc
else
  # changes
  echo
  echo -e $red_color"Local changes to the dotfiles were found. Check and commit these or run install-reinstall.sh. "$close_color
  echo
fi

# EOF 