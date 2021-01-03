#!/bin/bash
#
# install curl and execute
# -> curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/new-debian.sh | bash -

# system updates
apt update
apt upgrade -y

# install sudo & git
apt install -Y sudo git curl

# add user darkiop
adduser darkiop

# add user darkiop to group sudo
usermod -a -G sudo darkiop

# time & locales
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
dpkg-reconfigure locales

# switch user
su darkiop

# install dotfiles
#bash -c "$(wget -qO - 'https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install/install.sh')"
#bash $HOME/dotfiles/install/install.sh

sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/darkiop/dotfiles/HEAD/install/install.sh)
rm install.sh