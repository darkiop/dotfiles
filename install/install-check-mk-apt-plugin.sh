#!/bin/bash

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root." >&2;
  exit 1
fi

if [ ! -f /usr/lib/check_mk_agent/plugins/mk_apt ]; then
  if [ -f $HOME/dotfiles/checkmk/plugins/mk_apt ]; then
    ln -s $HOME/dotfiles/checkmk/plugins/mk_apt /usr/lib/check_mk_agent/plugins/mk_apt
  fi
fi

# EOF