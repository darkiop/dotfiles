#!/bin/bash

# gfs status
glusterfs_brick1=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.50' | tail -n 1 | awk '{print $2}')
glusterfs_brick2=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.51' | tail -n 1 | awk '{print $2}')
glusterfs_arbiter=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.40' | tail -n 1 | awk '{print $2}')

echo -e "$COLOR_BLUE"Proxmox Version"$COLOR_CLOSE   `echo -e "$COLOR_GREEN$(pveversion)$COLOR_CLOSE"`"
echo
echo -e "$COLOR_LIGHT_BLUE"LXC"$COLOR_CLOSE"
echo
echo -e $COLOR_YELLOW"Brick1: "$glusterfs_brick1"- Brick-2: "$glusterfs_brick2"- Arbiter:"$glusterfs_arbiter$COLOR_CLOSE
echo -e "$COLOR_LIGHT_BLUE"LXC"$COLOR_CLOSE"
echo
echo -e $COLOR_YELLOW"`pct list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$3,$2}' | sed -e's/  */ /g'
echo
echo -e "$COLOR_LIGHT_BLUE"VM"$COLOR_CLOSE"
echo
echo -e $COLOR_YELLOW"`qm list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$2,$3}' | sed -e's/  */ /g'

#EOF