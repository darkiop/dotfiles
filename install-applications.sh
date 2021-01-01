#!/bin/bash

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# install software
echo -e "$blue_color"
read -p "Install essential apps? (y/n):" instapp
echo -e "$close_color"
if [ $instapp == "y" ]; then
  sudo apt update
  sudo apt install -y \
  build-essential \
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
  parted \
  bat 
  # tmp: rcconf, sensors
fi

#
# TODO: batcat nicht aus repo
#

# install lsd
# config: ~/.config/lsd/config.yaml
# github: https://github.com/Peltoche/lsd
#         https://github.com/Peltoche/lsd/releases
# dpkg --print-architecture = amd64 & deb
instlsdarch=$(dpkg --print-architecture)
if [ $instlsdarch == "amd64" ]; then
  echo -e "$blue_color"
  read -p "Install lsd.deb from Github? (y/n):" instlsd
  echo -e "$close_color"
  if [ $instlsd == "y" ]; then
    wget -O ~/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb
    sudo dpkg -i ~/lsd.deb
    rm ~/lsd.deb
  fi
else 
  echo -e "$blue_color"
  read -p "Install lsd with cargo? (y/n):" instlsd
  echo -e "$close_color"
  if [ $instlsd == "y" ]; then
    sudo apt install -y cargo
    cargo install lsd
  fi
fi

# install git submodules
echo -e "$blue_color"
read -p "Install git submodules? (y/n):" instsub
echo -e "$close_color"
if [ $instsub == "y" ]; then
  cd $HOME/dotfiles
  git submodule update --init --recursive
fi

# install vimrc-amix
echo -e "$blue_color"
read -p "Install vimrc-amix? (y/n):" instvimrcamix
echo -e "$close_color"
if [ $instvimrcamix == "y" ]; then
  bash $HOME/dotfiles/modules/vimrc-amix/install_awesome_parameterized.sh $HOME/dotfiles/modules/vimrc-amix $USER
fi

# install navi
# https://github.com/denisidoro/navi
echo -e "$blue_color"
read -p "Install navi with cargo? (prerequisite: installation of git submodules) (y/n):" instnavi
echo -e "$close_color"
if [ $instnavi == "y" ]; then
  if [ -f /home/darkiop/dotfiles/modules/fzf/README.md ]; then
    # inst dependencies, fzf = git submodule
    #bash $HOME/dotfiles/modules/fzf/install --key-bindings --completion --no-update-rc
    bash $HOME/dotfiles/modules/fzf/install --bin
    apt install -y build-essential cargo
    # install navi
    cargo install navi
    # set PATH
    PATH=$PATH:~/.cargo/bin
    # bash widget (STRG + G)
    eval "$(navi widget bash)"
  else
    echo "Submodule fzf not found, try to install it."
    git submodule update --init --recursive
    if [ -f /home/darkiop/dotfiles/modules/fzf/README.md ]; then
      bash $HOME/dotfiles/modules/fzf/install --bin
      apt install -y build-essential cargo
      # install navi
      cargo install navi
      # set PATH
      PATH=$PATH:~/.cargo/bin
      # bash widget (STRG + G)
      eval "$(navi widget bash)"
    else
      echo "Installation of fzf not successful"
    fi
  fi
fi

# install cheat.sh
# https://github.com/chubin/cheat.sh#installation
# https://github.com/chubin/cheat.sh#command-line-client-chtsh
# config: ~/.cht.sh/cht.sh.conf
echo -e "$blue_color"
read -p "Install cheat.sh? (y/n):" instcheatsh
echo -e "$close_color"
if [ $instcheatsh == "y" ]; then
  curl --silent https://cht.sh/:cht.sh > $HOME/dotfiles/bin/cht.sh
  chmod +x $HOME/dotfiles/bin/cht.sh
  if [ ! -d $HOME/.cht.sh ]; then
    mkdir $HOME/.cht.sh
  fi 
  if [ ! -L $HOME/.cht.sh/cht.sh.conf ] ; then
    ln -s $HOME/dotfiles/cht.sh.conf $HOME/.cht.sh/cht.sh.conf
  fi
fi

# EOF