#!/bin/bash
#
# install curl and execute
# -> curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/new-debian.sh | bash -

# system updates
apt update
apt upgrade -y

# install sudo & git
apt install -Y sudo git curl wget

# time & locales
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
dpkg-reconfigure locales

# add user darkiop
useradd -m -s /bin/bash darkiop
passwd darkiop

# add user darkiop to group sudo
usermod -a -G sudo darkiop

# install samba
apt install -y samba-common samba

cat <<EOF > /etc/samba/smb.conf
[global]
  log file = /var/log/samba/log.%m
  logging = file
  map to guest = Bad User
  max log size = 1000
  obey pam restrictions = Yes
  pam password change = Yes
  panic action = /usr/share/samba/panic-action %d
  passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
  passwd program = /usr/bin/passwd %u
  server role = standalone server
  unix password sync = Yes
  usershare allow guests = Yes
  idmap config * : backend = tdb

[homes]
  browseable = No
  comment = Home Directories
  create mask = 0700
  directory mask = 0700
  read only = No
  valid users = %S
EOF

# check samba config
testparm

# add samba user
smbpasswd -a darkiop

# restart smb service
systemctl restart smbd.service

# switch user
su darkiop

# install dotfiles
bash <(wget -qO- https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install/install.sh)
rm install.sh