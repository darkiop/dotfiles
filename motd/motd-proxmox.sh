#!/bin/bash

echo -e "$blue_color"Proxmox Version"$close_color   `echo -e "$green_color$(pveversion)$close_color"`"
echo
echo -e "$light_blue_color"List LXC Container"$close_color"
echo
echo -e $yellow_color"`pct list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $yellow_color)&$close_color," | sed "s,running,$(echo -e $green_color)&$close_color," | sed "s,stopped,$(echo -e $red_color)&$close_color,"`"$close_color | awk '{print $1,$3,$2}' | sed -e's/  */ /g'
echo
echo -e "$light_blue_color"List Virtual Machines"$close_color"
echo
echo -e $yellow_color"`qm list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $yellow_color)&$close_color," | sed "s,running,$(echo -e $green_color)&$close_color," | sed "s,stopped,$(echo -e $red_color)&$close_color,"`"$close_color | awk '{print $1,$2,$3}' | sed -e's/  */ /g'

#EOF