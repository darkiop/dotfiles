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
# config: ~/.config/lsd/config.yaml
# github: https://github.com/Peltoche/lsd
#         https://github.com/Peltoche/lsd/releases
# dpkg --print-architecture = amd64 & deb
instlsdarch=$(dpkg --print-architecture)
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

# install navi
# https://github.com/denisidoro/navi
echo
echo -e "$blue_color"
read -p "Install navi with cargo? (y/n):" instnavi
echo -e "$close_color"
if [ $instnavi == "y" ]; then
  sudo apt install -y build-essential
  sudo apt install -y fzf
  sudo apt install -y cargo
  
  # install navi
  cargo install navi
  
  # set PATH
  PATH=$PATH:~/.cargo/bin
fi

# install cheat.sh
# https://github.com/chubin/cheat.sh#installation
# https://github.com/chubin/cheat.sh#command-line-client-chtsh
# config: ~/.cht.sh/cht.sh.conf
echo -e "$blue_color"
read -p "Install cheat.sh? (y/n):" instcheatsh
echo -e "$close_color"
if [ $instcheatsh == "y" ]; then
  curl https://cht.sh/:cht.sh > $HOME/dotfiles/bin/cht.sh

  chmod +x $HOME/dotfiles/bin/cht.sh
  if [ ! -d $HOME/.cht.sh ]; then
    mkdir $HOME/.cht.sh
  fi
  ln -s $HOME/dotfiles/cht.sh.conf $HOME/.cht.sh/cht.sh.conf

fi

# EOF