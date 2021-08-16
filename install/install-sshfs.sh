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

# create sshfs dir
if [ ! -d $SSHFSDIR ]; then
  mkdir $SSHFSDIR
fi

# create folder for sshfs
let i=1
for dir in "${FOLDERS[@]}"; do
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
    ssh-copy-id -i $HOME/.ssh/id_rsa.pub $remotessh &>/dev/null
  fi
done

# mount
function connectSSHFS() {
  # TODO validate parameters
  if [ "$#" -ne 3 ]; then
    echo "Usage: Parameter-1: user@host | Parameter-2: SOURCE-DIR, e.g. /home/darkiop | Parameter-3: TARGET-DIR, e.g. host/home-darkiop"
    exit 1
  fi
  sudo sshfs -o $SSHFSOPTIONS $1:$2/ $SSHFSDIR/$3
}

connectSSHFS darkiop@pve01 /home/darkiop pve01/home-darkiop
connectSSHFS darkiop@pve-vm-iobroker /home/darkiop pve-vm-iobroker/home-darkiop
connectSSHFS darkiop@pve-vm-iobroker /opt/iobroker pve-vm-iobroker/opt-iobroker

tree -L 3 $SSHFSDIR

#sshfs -o $SSHFSOPTIONS darkiop@pve-vm-iobroker:/opt/iobroker/ /home/darkiop/sshfs/pve-vm-iobroker/opt-iobroker