#!/bin/bash
#
# WORK IN PROGRESS

SSHFSDIR=$HOME'/sshfs'

# install sshfs
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' sshfs|grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
  sudo apt install sshfs -y
fi

# create sshfs dir
if [ ! -d $SSHFSDIR ]; then
  mkdir $SSHFSDIR
fi

# create folder for sshfs
#hosts=(pve01 pve-ct-adguard pve-ct-grafana pve-ct-checkmk pve-ct-mariadb pve-ct-wireguard pve-ct-bind9 pve-ct-heimdall pve-ct-bitwarden pve-ct-cockpit pve-vm-raspberyymatic pve-vm-iobroker pve-vm-pbs)
hosts=(pve01 pve-ct-adguard)
let i=1
for dir in "${hosts[@]}"; do
  mkdir -p $SSHFSDIR/$dir
done

# create ssh key
if [ ! -f $HOME/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096
fi

# copy public ssh key to remote hosts
for remote in "${hosts[@]}"; do
  if [ $HOSTNAME != $dir ]; then
    ssh-copy-id -i $HOME/.ssh/id_rsa.pub $remote
  fi
done

# fstab
#$cat <<'EOF' >> /etc/fstab
#sshfs#darkiop@pve01:/home/darkiop/ /home/darkiop/sshfs/pve01/home-darkiop fuse uid=1000,gid=100,umask=0,allow_other,_netdev,IdentityFile=/home/darkiop/.ssh/id_rsa,nonempty 0 0
#EOF
#$sed -i 's/VERSION/'$vaultwardenVersion'/g' /etc/systemd/system/vaultwarden.service