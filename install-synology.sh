#!/bin/bash

home=/var/services/homes/darkiop/dotfiles

wget -q https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias -O $home/shells/alias
wget -q https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/alias-docker -O $home/shells/alias-docker
