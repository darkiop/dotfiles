#!/bin/bash


#1
# gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.50' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g'
# gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.51' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g'
# gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.40' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g'

# gfs status
#glusterfs_brick1=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.50' | tail -n 1 | awk '{print $2}')
#glusterfs_brick2=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.51' | tail -n 1 | awk '{print $2}')
#glusterfs_arbiter=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.40' | tail -n 1 | awk '{print $2}')
#
#if [ $glusterfs_brick1 == "Connected" ]; then
#  glusterfs_brick1_colored=$COLOR_GREEN$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
#else
#  glusterfs_brick1_colored=$COLOR_RED$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
#fi
#
#if [ $glusterfs_brick2 == "Connected" ]; then
#  glusterfs_brick2_colored=$COLOR_GREEN$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
#else
#  glusterfs_brick2_colored=$COLOR_RED$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
#fi
#
#if [ $glusterfs_arbiter == "Connected" ]; then
#  glusterfs_arbiter_colored=$COLOR_GREEN$glusterfs_arbiter$COLOR_CLOSE$COLOR_YELLOW
#else
#  glusterfs_arbiter_colored=$COLOR_RED$glusterfs_arbiter$COLOR_CLOSE$COLOR_YELLOW
#fi

echo -e " "$COLOR_BLUE"Proxmox  "$COLOR_CLOSE`echo -e "$COLOR_GREEN$(pveversion)$COLOR_CLOSE"`
echo
echo -e " "$COLOR_LIGHT_BLUE"GlusterFS"$COLOR_CLOSE
echo
echo -e " "$COLOR_YELLOW"Brick-1: "$glusterfs_brick1_colored" Brick-2: "$glusterfs_brick2_colored" Arbiter: "$glusterfs_arbiter_colored$COLOR_CLOSE
echo
echo -e " "$COLOR_LIGHT_BLUE"LXC"$COLOR_CLOSE
echo
echo -e " "$COLOR_YELLOW"`pct list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$3,$2}' | sed -e's/  */ /g' | sed 's/^/ /'
echo
echo -e " "$COLOR_LIGHT_BLUE"VM"$COLOR_CLOSE
if [ $(qm list | sed '1d' | wc -l) -gt 0 ]; then
echo
echo -e " "$COLOR_YELLOW"`qm list | sed -e 's/^[ \t]*//' | sed '1d' | sed "s,.*,$(echo -e $COLOR_YELLOW)&$COLOR_CLOSE," | sed "s,running,$(echo -e $COLOR_GREEN)&$COLOR_CLOSE," | sed "s,stopped,$(echo -e $COLOR_RED)&$COLOR_CLOSE,"`"$COLOR_CLOSE | awk '{print $1,$2,$3}' | sed -e's/  */ /g' | sed 's/^/ /'
else
echo
echo -e " "$COLOR_YELLOW"No VM is running."$COLOR_CLOSE
fi

#EOF