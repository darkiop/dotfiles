#!/bin/bash

echo -e "$blue_color"Proxmox Version"$close_color   `echo -e "$green_color$(pveversion)$close_color"`"
echo
echo -e "$light_blue_color"List Proxmox Container"$close_color"
echo
echo -e $yellow_color"`pct list` "$close_color
echo
echo -e "$light_blue_color"List Proxmox Virtual Machines"$close_color"
echo
echo -e $yellow_color"`qm list | sed -e 's/^[ \t]*//'` "$close_color

#EOF