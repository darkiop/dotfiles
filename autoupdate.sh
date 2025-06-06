#!/bin/bash
# auto update dot files

COUNT=~/.dotfiles-update-count
STARTUP_COUNT=

if [[ -f "${COUNT}" ]]; then
  STARTUP_COUNT=$(cat "${COUNT}")
  # trunk-ignore(shellcheck/SC2004)
  echo $((${STARTUP_COUNT} + 1)) > "${COUNT}"
  if [[ ${STARTUP_COUNT} -gt 20 ]]
  then
      echo "Update dotfiles ..."
      cd ~/dotfiles || exit
      git pull
      echo "0" > "${COUNT}"
  fi
else 
  echo "0" > "${COUNT}"
fi

# EOF