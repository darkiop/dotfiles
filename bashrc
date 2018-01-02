#!/usr/bin/env bash
#
# https://github.com/darkiop/dotfiles

# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# User Info
export USERNAME="Thorsten Walk"
export NICKNAME="darkiop"

# load default bashrc 
#source /etc/skel/.bashrc

# Distribute bashrc into smaller, more specific files
source ~/dotfiles/shells/defaults
source ~/dotfiles/shells/functions
source ~/dotfiles/shells/exports
source ~/dotfiles/shells/alias
source ~/dotfiles/shells/prompt-koljah-de
source ~/dotfiles/shells/git

# motd
source ~/dotfiles/motd/motd.sh

# EOF
