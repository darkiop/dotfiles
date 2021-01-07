#!/bin/bash

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