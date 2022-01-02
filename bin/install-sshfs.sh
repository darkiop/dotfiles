#!/bin/bash
#
# WORK IN PROGRESS

SSHFSDIR=$HOME'/sshfs'
SSHFSOPTIONS="uid=1000,gid=1000,umask=0,IdentityFile=/home/darkiop/.ssh/id_rsa,nonempty"

#HOSTS=(pve01 pve-ct-adguard pve-ct-grafana pve-ct-checkmk pve-ct-mariadb pve-ct-wireguard pve-ct-bind9 pve-ct-heimdall pve-ct-bitwarden pve-ct-cockpit pve-vm-raspberyymatic pve-vm-iobroker pve-vm-pbs odin udmp)
HOSTS=(pve01 pve-vm-iobroker)
FOLDERS=(pve01 pve01/home-darkiop pve-vm-iobroker pve-vm-iobroker/home-darkiop pve-vm-iobroker/opt-iobroker)

# install sshfs
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' sshfs|grep "install ok installed")" ]; then
  sudo apt install sshfs -y
fi

# install mountpoint
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' mountpoint|grep "install ok installed")" ]; then
  sudo apt install mountpoint -y
fi

# create sshfs dir
if [ ! -d $SSHFSDIR ]; then
  mkdir $SSHFSDIR
fi

# create folders for sshfs
let i=1
for dir in "${FOLDERS[@]}"; do
  if [ $dir != $HOSTNAME ]; then
    mkdir -v -p $SSHFSDIR/$dir
  fi
done

# create a local ssh key
if [ ! -f $HOME/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096
fi

# copy public ssh key to remote hosts
for remotessh in "${HOSTS[@]}"; do
  if [ $remotessh != $HOSTNAME ]; then
    ssh-copy-id -i $HOME/.ssh/id_rsa.pub $remotessh &>/dev/null
  fi
done

# mount
function mountSSHFS() {
  # TODO check if already mounted
  # TODO $1: check if host is online
  # TODO $2: check if remote dir exists
  # TODO $3: check if local dir exists
  if [ "$#" -ne 3 ]; then
    echo "Usage: Parameter-1: host| Parameter-2: remote-dir, e.g. /home/darkiop | Parameter-3: TARGET-DIR, e.g. home-darkiop"
    exit 1
  fi

  if mountpoint -q $SSHFSDIR/$1/$3; then
    echo "mount exist, exit."
    exit 1
  fi

  sshfs -o $SSHFSOPTIONS $USER@$1:$2/ $SSHFSDIR/$1/$3
}

mountSSHFS pve01 /home/darkiop home-darkiop
mountSSHFS pve-vm-iobroker /home/darkiop home-darkiop
mountSSHFS pve-vm-iobroker /opt/iobroker opt-iobroker

# debug: show result
tree -L 3 $SSHFSDIR