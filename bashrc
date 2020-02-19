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

# path
PATH=$PATH:~/dotfiles/bin

# Distribute bashrc into smaller, more specific files
source ~/dotfiles/shells/defaults
source ~/dotfiles/shells/functions
source ~/dotfiles/shells/exports
source ~/dotfiles/shells/alias
source ~/dotfiles/shells/alias-git
source ~/dotfiles/shells/alias-docker
source ~/dotfiles/shells/prompt-koljah-de

# motd
clear
source ~/dotfiles/motd/motd.sh

# Forces npm to run as iobroker when inside the iobroker installation dir
source /root/.iobroker/npm_command_fix

# create link to current log
# deprecated, ioBroker do this:

#if [ -f /opt/iobroker/log/iobroker.current.log ]; then
#  rm /opt/iobroker/log/iobroker.current.log
#  ln -s /opt/iobroker/log/iobroker.$(date +"%F").log /opt/iobroker/log/iobroker.current.log
#else
#  ln -s /opt/iobroker/log/iobroker.$(date +"%F").log /opt/iobroker/log/iobroker.current.log
#fi

# EOF
