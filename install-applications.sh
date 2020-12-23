#!/bin/bash

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# install software
echo
echo -e "$blue_color"
read -p "Install applications?  (y/n):" instapp
echo -e "$close_color"
if [ $instapp == "y" ]; then
  sudo apt update

  sudo apt install -y \
  powerline \
  dnsutils \
  vim \
  byobu \
  ranger \
  htop \
  cifs-utils \
  net-tools \
  html2text \
  fping \
  curl \
  speedtest-cli \
  unzip \
  nmap \
  iperf3 \
  lnav \
  lsof \
  toilet \
  command-not-found \
  bash-completion \
  iproute2 \
  procps \
  tcpdump \
  man \
  wakeonlan \
  neofetch \
  mlocate \
  telnet \
  nfs-common \
  rsync \
  ncdu \
  needrestart \
  hddtemp \
  parted

  # tmp: rcconf, sensors

fi

# install lsd
# https://github.com/Peltoche/lsd/releases
#  dpkg-architecture -q DEB_BUILD_ARCH = amd64 & deb
instlsdarch=$(dpkg-architecture -q DEB_BUILD_ARCH)
if [ $instlsdarch == "amd64" ]; then
  echo
  echo -e "$blue_color"
  read -p "Download & Install lsd.deb from Github? (y/n):" instlsd
  echo -e "$close_color"
  if [ $instlsd == "y" ]; then
    echo "TODO"
    wget -O ~/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb
    sudo dpkg -i ~/lsd.deb
    rm ~/lsd.deb
  fi
else 
  echo
  echo -e "$blue_color"
  read -p "Install lsd with cargo? (y/n):" instlsd
  echo -e "$close_color"
  if [ $instlsd == "y" ]; then
    sudo apt install -y cargo
    cargo install lsd
  fi

fi

# EOF