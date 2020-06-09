#!/bin/bash
#
# install curl and execute
# -> curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/new-debian.sh | bash -

# system updates
apt update
apt upgrade -y

# install sudo & git
apt install sudo git

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
if [ -d ~/dotfiles ]; then
  mkdir ~/dotfiles
fi
git clone https://github.com/darkiop/dotfiles.git ~/dotfiles
~/dotfiles/install-applications.sh
~/dotfiles/install-bashrc.sh
source ~/.bashrc
