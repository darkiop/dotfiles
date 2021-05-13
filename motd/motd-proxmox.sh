#!/bin/bash

echo -e "$blue_color"Proxmox Version"$close_color   `echo -e "$green_color$(pveversion)$close_color"`"
echo
echo -e "$light_blue_color"List Proxmox Container"$close_color"
echo
echo -e $yellow_color"`pct list | sed '1d'` "$close_color
echo
echo -e "$light_blue_color"List Proxmox Virtual Machines"$close_color"
echo
echo -e $yellow_color"`qm list | sed -e 's/^[ \t]*//' | sed '1d' | awk '{print $1,$2,$3}' | column -t | sed "s,.*,$(echo -e $yellow_color)&$close_color," | sed "s,running,$(echo -e $green_color)&$close_color," | sed "s,stopped,$(echo -e $red_color)&$close_color,"`"$close_color

#EOF