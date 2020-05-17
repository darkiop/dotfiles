#!/bin/bash
#
# install manuell curl and execute
# -> curl -sL https://raw.githubusercontent.com/darkiop/dotfiles/master/bin/new-debian.sh | bash -

apt update

apt upgrade -y

apt install sudo git

adduser darkiop

usermod -a -G sudo darkiop

ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

dpkg-reconfigure -f noninteractive tzdata

dpkg-reconfigure locales

su darkiop

mkdir ~/dotfiles && cd ~/dotfiles && git clone https://github.com/darkiop/dotfiles.git . && ./install-applications.sh && ./install-bashrc.sh && source ~/.bashrc
