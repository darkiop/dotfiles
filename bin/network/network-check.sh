#!/bin/bash

# load colors
COLOR_BLUE="\e[38;5;33m"
COLOR_LIGHT_BLUE="\e[38;5;39m"
COLOR_RED="\e[38;5;196m"
COLOR_GREEN="\e[38;5;42m"
COLOR_GREEN_BOLD="\e[1;38;5;42m"
COLOR_YELLOW="\e[38;5;227m"
COLOR_CLOSE="$(tput sgr0)"

for ip in $(cat ~/dotfiles/bin/network/network-check-ip-list)
do
  fping $ip -c 1 -t 1000 &> /dev/null
  if [ $? -ne 0 ]; then
    echo -e $COLOR_RED$ip "-" $(nslookup $ip | awk '/name/ {print $4}' | sed 's/.$//';)$COLOR_CLOSE
  else
    echo -e $COLOR_GREEN$ip "-" $(nslookup $ip | awk '/name/ {print $4}' | sed 's/.$//';)$COLOR_CLOSE
  fi
done

# EOF
