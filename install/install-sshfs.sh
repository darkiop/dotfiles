#!/bin/bash
#
# WORK IN PROGRESS

SSHFSDIR=$HOME'/sshfs'
SSHFSOPTIONS="uid=1000,gid=100,umask=0,IdentityFile=/home/darkiop/.ssh/id_rsa,nonempty"
#HOSTS=(pve01 pve-ct-adguard pve-ct-grafana pve-ct-checkmk pve-ct-mariadb pve-ct-wireguard pve-ct-bind9 pve-ct-heimdall pve-ct-bitwarden pve-ct-cockpit pve-vm-raspberyymatic pve-vm-iobroker pve-vm-pbs odin udmp)
HOSTS=(pve-ct-cockpit pve-ct-wireguard)

# install sshfs
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' sshfs|grep "install ok installed")" ]; then
  sudo apt install sshfs -y
fi

# create sshfs dir
if [ ! -d $SSHFSDIR ]; then
  mkdir $SSHFSDIR
fi

# create folder for sshfs
let i=1
for dir in "${HOSTS[@]}"; do
  if [ $dir != $HOSTNAME ]; then
    mkdir -p $SSHFSDIR/$dir
  fi
done

# create local ssh key
if [ ! -f $HOME/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096
fi

# copy public ssh key to remote hosts
for remotessh in "${HOSTS[@]}"; do
  if [ $remotessh != $HOSTNAME ]; then
    ssh-copy-id -i $HOME/.ssh/id_rsa.pub $remotessh
  fi
done

# mount
# wip
sshfs -o $SSHFSOPTIONS darkiop@pve-ct-wireguard:/home/darkiop/ /home/darkiop/sshfs/pve-ct-wireguard/home-darkiop
