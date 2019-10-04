#!/bin/bash

# load colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

for ip in $(cat ~/dotfiles/bin/network-check-ips)
do
  fping $ip -c 1 -t 1 &> /dev/null
  if [ $? -ne 0 ]; then
    echo -e $red_color$ip "-" $(nslookup $ip | awk '/name/ {print $4}' | sed 's/.$//';)$close_color
    #sleep 1
  else
    echo -e $green_color$ip "-" $(nslookup $ip | awk '/name/ {print $4}' | sed 's/.$//';)$close_color
    #sleep 1
  fi
done

# EOF