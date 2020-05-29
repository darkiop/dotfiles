#!/bin/bash

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# install software
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
nfs-common

# tmp: rcconf

# install lsd
echo
echo -e "$blue_color"
read -p "install lsd with cargo? (y/n):" instlsd
echo -e "$close_color"
if [ $instlsd == "y" ]; then
  sudo apt install -y cargo
  cargo install lsd
fi

# EOF
