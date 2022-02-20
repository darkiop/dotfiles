#!/bin/bash

if [ -x /usr/local/bin/gstatus ]; then
  glusterfs_brick1=$(gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.50' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g')
  glusterfs_brick2=$(gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.51' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g')
  glusterfs_brick3=$(gstatus -ab | grep -A3 'Group 1' | grep '192.168.1.40' | awk '{print $2}' | sed 's/(//g' | sed 's/)//g')
else
  glusterfs_brick1="gstatus not found"
  glusterfs_brick2="gstatus not found"
  glusterfs_brick3="gstatus not found"
fi

if [ -x /usr/sbin/gluster ]; then
  gluster_version=$(gluster --version | head -n1 | awk '{print $2}')
else
  gluster_version="GlusterFS not found."
fi

# set colors for status
if [[ $glusterfs_brick1 = "Online" ]]; then
  glusterfs_brick1_colored=$COLOR_GREEN$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_brick1_colored=$COLOR_RED$glusterfs_brick1$COLOR_CLOSE$COLOR_YELLOW
fi

if [[ $glusterfs_brick2 = "Online" ]]; then
  glusterfs_brick2_colored=$COLOR_GREEN$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_brick2_colored=$COLOR_RED$glusterfs_brick2$COLOR_CLOSE$COLOR_YELLOW
fi

if [[ $glusterfs_brick3 = "Online" ]]; then
  glusterfs_brick3_colored=$COLOR_GREEN$glusterfs_brick3$COLOR_CLOSE$COLOR_YELLOW
else
  glusterfs_brick3_colored=$COLOR_RED$glusterfs_brick3$COLOR_CLOSE$COLOR_YELLOW
fi

echo
echo -e " "$COLOR_LIGHT_BLUE"GlusterFS"$COLOR_CLOSE
echo
echo -e "" $COLOR_YELLOW"Brick-1: "$glusterfs_brick1_colored" Brick-2: "$glusterfs_brick2_colored" Brick-3: "$glusterfs_brick3_colored$COLOR_CLOSE
echo

#EOF