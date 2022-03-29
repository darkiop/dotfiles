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

# systemd
GLUSTERD="$(/usr/bin/systemctl is-active glusterd.service)"
if [ "${GLUSTERD}" = "active" ]; then 
    systemctl_glusterd=$COLOR_GREEN"glusterd"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_glusterd=$COLOR_RED"glusterd"$COLOR_CLOSE$COLOR_YELLOW
fi
WATCHDOG="$(/usr/bin/systemctl is-active watchdog-mux.service)"
if [ "${WATCHDOG}" = "active" ]; then 
    systemctl_watchdog_mux=$COLOR_GREEN"watchdog-mux"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_watchdog_mux=$COLOR_RED"watchdog-mux"$COLOR_CLOSE$COLOR_YELLOW
fi
COROSYNC="$(/usr/bin/systemctl is-active corosync.service)"
if [ "${COROSYNC}" = "active" ]; then 
    systemctl_corosync=$COLOR_GREEN"corosync"$COLOR_CLOSE$COLOR_YELLOW
else 
    systemctl_corosync=$COLOR_RED"corosync"$COLOR_CLOSE$COLOR_YELLOW
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

# MOTD
echo -e " "$COLOR_BLUE"Proxmox   "$COLOR_CLOSE`echo -e "$COLOR_GREEN$(pveversion)$COLOR_CLOSE"`
echo
echo -e " "$COLOR_LIGHT_BLUE"GlusterFS ("$gluster_version")"$COLOR_CLOSE
echo
echo -e " "$COLOR_YELLOW"Brick-1: "$glusterfs_brick1_colored" Brick-2: "$glusterfs_brick2_colored" Brick-3: "$glusterfs_brick3_colored$COLOR_CLOSE
echo
echo -e " "$COLOR_LIGHT_BLUE"Systemctl"$COLOR_CLOSE
echo
echo -e " "$systemctl_glusterd" "$systemctl_watchdog_mux" "$systemctl_corosync
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