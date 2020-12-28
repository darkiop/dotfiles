#!/usr/bin/env bash
# https://github.com/darkiop/dotfiles

# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# User Info
export USERNAME="Thorsten Walk"
export NICKNAME="darkiop"

# load default bashrc 
#source /etc/skel/.bashrc

# expand $PATH
PATH=$PATH:~/dotfiles/bin

if [ -d ~/.cargo/bin ]; then
  PATH=$PATH:~/.cargo/bin
fi

if [ -d ~/.local/bin ]; then
  PATH=$PATH:~/.local/bin
fi

# Distribute bashrc into smaller, more specific files
source ~/dotfiles/shells/defaults
source ~/dotfiles/shells/functions
source ~/dotfiles/shells/exports
source ~/dotfiles/shells/alias
source ~/dotfiles/shells/alias-git
source ~/dotfiles/shells/alias-iobroker
source ~/dotfiles/shells/prompt

case $(hostname) in 
  (pve-vm-docker|pve-ct-docker)
    source ~/dotfiles/shells/alias-docker
  ;;
  (pve01)
    source ~/dotfiles/shells/alias-proxmox
  ;;
  (pve-ct-iobroker|iobroker-hwr|iobroker-master)
    source ~/dotfiles/shells/alias-iobroker
  ;;
esac

# create local settings file
if [ ! -f ~/dotfiles/.local_dotfiles_settings ]; then
  touch ~/dotfiles/.local_dotfiles_settings
  echo "# local settings for dotfiles, e.g. variables" > ~/dotfiles/.local_dotfiles_settings
else
  source ~/dotfiles/.local_dotfiles_settings
fi

# Forces npm to run as iobroker when inside the iobroker installation dir
if [ -f /opt/iobroker/log/iobroker.current.log ]; then
  source /root/.iobroker/npm_command_fix
fi

# clear screen & show motd
clear
source ~/dotfiles/motd/motd.sh

# EOF
