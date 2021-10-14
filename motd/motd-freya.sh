#!/bin/bash

glusterfs_brick1=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.50' | tail -n 1 | awk '{print $2}')
glusterfs_brick2=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.51' | tail -n 1 | awk '{print $2}')
glusterfs_arbiter=$(gluster volume heal glusterfs-1-volume info | grep -A 1 '192.168.1.40' | tail -n 1 | awk '{print $2}')

if [ $glusterfs_brick1 == "Connected" ]; then
  glusterfs_brick1_colored=$COLOR_GREEN$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_brick1_colored=$COLOR_RED$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
fi

if [ $glusterfs_brick2 == "Connected" ]; then
  glusterfs_brick2_colored=$COLOR_GREEN$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_brick2_colored=$COLOR_RED$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
fi

if [ $glusterfs_arbiter == "Connected" ]; then
  glusterfs_arbiter_colored=$COLOR_GREEN$glusterfs_arbiter$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_arbiter_colored=$COLOR_RED$glusterfs_arbiter$COLOR_CLOSE$COLOR_YELLOW
fi

echo -e "$COLOR_LIGHT_BLUE"GlusterFS"$COLOR_CLOSE"
echo
echo -e $COLOR_YELLOW"Brick-1: "$glusterfs_brick1_colored" Brick-2: "$glusterfs_brick2_colored" Arbiter: "$glusterfs_arbiter_colored$COLOR_CLOSE

#EOF