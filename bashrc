#!/usr/bin/env bash
# https://github.com/darkiop/dotfiles

# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# load default bashrc
#source /etc/skel/.bashrc

# $PATH
source $HOME/shells/path

# Distribute bashrc into smaller, more specific files
source $HOME/dotfiles/shells/defaults
source $HOME/dotfiles/shells/exports
source $HOME/dotfiles/shells/alias
source $HOME/dotfiles/shells/prompt

# load git alias
if [ -x /usr/bin/git ]; then
  source $HOME/dotfiles/shells/alias-git
fi

# load navi alias if navi is installed
if [ -x $HOME/dotfiles/bin/navi ]; then
  source $HOME/dotfiles/shells/alias-navi
  # bash widget (STRG + G runs navi)
  eval "$(navi widget bash)"
fi

# load docker alias
if [[ -x $(which docker) ]]; then
  source ~/dotfiles/shells/alias-docker
fi

# load proxmox alias
if [[ -x $(which pveversion) ]]; then
  source ~/dotfiles/shells/alias-proxmox
fi

# load wireguard alias
if [[ -x $(which wg) ]]; then
  source ~/dotfiles/shells/alias-wireguard
fi

# load iobroker alias
if [ -d /opt/iobroker ]; then
  source ~/dotfiles/shells/alias-iobroker
  # Forces npm to run as iobroker when inside the iobroker installation dir
  if [ -f /root/.iobroker/npm_command_fix ]; then
    source /root/.iobroker/npm_command_fix
  fi
fi

# create local settings file
if [ ! -f ~/dotfiles/.local_dotfiles_settings ]; then
  touch ~/dotfiles/.local_dotfiles_settings
  echo "# local settings for dotfiles, e.g. variables" > ~/dotfiles/.local_dotfiles_settings
else
  source ~/dotfiles/.local_dotfiles_settings
fi

# clear screen & show motd
clear
source ~/dotfiles/motd/motd.sh

# EOF