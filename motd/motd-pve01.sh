#!/bin/bash

# load colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

echo -e "$blue_color"Proxmox Version"$close_color   `echo -e "$green_color$(pveversion)$close_color"`"
echo

echo -e "$blue_color"List Proxmox Container"$close_color"
echo -e "$green_color"
sudo pct list
echo -e "$green_color"

echo -e "$blue_color"List Proxmox Virtual Machines"$close_color"
echo -e "$green_color"
# | sed -e 's/^[ \t]*//' = remove leading zeros
sudo qm list | sed -e 's/^[ \t]*//'
echo -e "$green_color"

#EOF