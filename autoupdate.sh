#!/bin/bash
# auto update dot files

COUNT=~/.dotfiles-update-count
if [ -f "$COUNT" ]; then
  typeset -i startup_count=$(cat $COUNT)
  echo $(($startup_count + 1)) > $COUNT
  if [ $startup_count -gt 10 ]
  then
      echo "Update dotfiles ..."
      cd $HOME/dotfiles
      git pull
      echo "0" > $COUNT
  fi
else 
  echo "0" > $COUNT
fi

# EOF