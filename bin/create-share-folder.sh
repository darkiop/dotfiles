#!/bin/bash
#
#

# mkdirs if not exist (todo)
if [ -d mkdir ~/share ]; then
  mkdir ~/share
fi

mkdir ~/share/odin
mkdir ~/share/odin/home
mkdir ~/share/odin/backup
mkdir ~/share/odin/media
mkdir ~/share/odin/proxmox

mkdir ~/share/thor
mkdir ~/share/thor/downloads

mkdir ~/share/iobroker-hwr
mkdir ~/share/iobroker-hwr/home

mkdir ~/share/pve-ct-pihole
mkdir ~/share/pve-ct-pihole/home

mkdir ~/share/pve-ct-unifi
mkdir ~/share/pve-ct-unifi/home

# mounts (todo)
# mount -t cifs -o user=darkiop,domain=birkenweg.walk-steinweiler.de //192.168.1.43/backup ~/share/odin/backup
# ...

# ggf in bashrc touch > smbcredentials + chmod 600

# EOF
