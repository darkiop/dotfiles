#!/bin/bash

# set colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# help
help() {
  cat << EOF

usage: $0 [PARAMETERS]

    --help     Show this message
    --all      Install with all Options: 1. Essential Apps, 2. LSD, 3. git submodules , 4. vimrc-amix, 5. navi, 6. cheat.sh
    --apps     
    --lsd
    --gitsubm
    --vimrc
    --navi
    --cheatsh

Without a parameter, the script will ask you what you want to install.

EOF
}

# parameters
instAPP=0
instLSD=0
instGITSUBM=0
instVIMRC=0
instNAVI=0
instCHEATSH=0
for para in "$@"; do
  case $para in
    --help)
      help
      exit 0
      ;;
    --all)
      instAPP=1
      instLSD=1
      instGITSUBM=1
      instVIMRC=1
      instNAVI=1
      instCHEATSH=1
      ;;
    --apps)
      instAPP=1
      instLSD=0
      instGITSUBM=0
      instVIMRC=0
      instNAVI=0
      instCHEATSH=0
      ;;
    --lsd)
      instLSD=1
      ;;
    --gitsubm)
      instGITSUBM=1
      ;;
    --vimrc)
      instVIMRC=1
      ;;
    --navi)
      instNAVI=1
      ;;
    --cheatsh)
      instCHEATSH=1
      ;;
    *)
      echo "unknown parameter: $para"
      help
      exit 1
      ;;
  esac
done

# TODO if not root, alias sudo apt
# check if root, when not define alias with sudo
if [[ $EUID -ne 0 ]]; then
  dpkg='sudo '$(which dpkg)
  apt='sudo '$(which apt)
else
  dpkg=$(which dpkg)
  apt=$(which apt)
fi

# ask functions
function ask() {
  local color="$1"
  case $color in
    green)
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$yellow_color
    ;;
  esac
  while true; do
    echo -e "$color"
    read -p "$2 ([y]/n) " -r
    echo -e "$close_color"
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

# info function
function message() {
  local color="$1"
  case $color in
    green)
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$yellow_color
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$close_color"
}

# check last apt update and run if necessary (7 days)
if [ -z "$(find -H /var/lib/apt/lists -maxdepth 0 -mtime -7)" ]; then
  $apt update
fi

# check if git is installed
if [ ! $(which git) ]; then
  echo -e $red_color"git not found. install it ..."$close_color
  $apt install git -y
fi

# check if dotfiles dir exist
if [ ! -d $HOME/dotfiles ]; then
  git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
else
  echo
  echo -e $green_color"dotfiles found. continue with the installation process."$close_color
fi

# -------------------------------------------------------------
# install essential apps
# -------------------------------------------------------------
function instAPP() {
  $apt update
  $apt install --ignore-missing -y \
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
  # tmp: rcconf, sensors
}
if [ $instAPP -eq 1 ]; then
  instAPP
else
  ask blue "Install essential apps?"
  if [ $REPLY == "y" ]; then
    instAPP
  fi
fi

# -------------------------------------------------------------
# TODO
# Install: BAT
# https://ostechnix.com/bat-a-cat-clone-with-syntax-highlighting-and-git-integration/
# -------------------------------------------------------------


# -------------------------------------------------------------
# Install: LSD
# config: ~/.config/lsd/config.yaml
# github: https://github.com/Peltoche/lsd
#         https://github.com/Peltoche/lsd/releases
# dpkg --print-architecture = amd64 & deb
# -------------------------------------------------------------
function instLSD() {
  local arch=$1
  if [ $arch == "deb" ]; then
    wget -O ~/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb
    $dpkg -i ~/lsd.deb
    rm ~/lsd.deb
  elif [ $arch == "cargo" ]; then
    $apt install -y cargo
    cargo install lsd
  fi
}
if [ $instLSD -eq 1 ]; then
  instlsdarch=$(dpkg --print-architecture)
  if [ $instlsdarch == "amd64" ]; then
    instLSD "deb"
  else
    ask blue "No .deb file to install. Install LSD with cargo?"
    if [ $REPLY == "y" ]; then
      instLSD "cargo"
    fi
  fi
else
  ask blue "Install lsd.deb from Github?"
  if [ $REPLY == "y" ]; then
    instlsdarch=$(dpkg --print-architecture)
    if [ $instlsdarch == "amd64" ]; then
      instLSD "deb"
    else
      ask blue "No .deb file to install. Install LSD with cargo?"
      if [ $REPLY == "y" ]; then
        instLSD "cargo"
      fi
    fi
  fi
fi

# -------------------------------------------------------------
# Install: GIT SUBMODULES
# see: .gitmodules
# -------------------------------------------------------------
function instGITSUBM() {
  cd $HOME/dotfiles
  git submodule update --init --recursive
}
if [ $instGITSUBM -eq 1 ]; then
  instGITSUBM
else
  ask blue "Install git submodules?"
  if [ $REPLY == "y" ]; then
    instGITSUBM
  fi
fi

# -------------------------------------------------------------
# Install: vimrc-amix
# -------------------------------------------------------------
function instVIMRC() {
  bash $HOME/dotfiles/modules/vimrc-amix/install_awesome_parameterized.sh $HOME/dotfiles/modules/vimrc-amix $USER
}
if [ $instVIMRC -eq 1 ]; then
  instVIMRC
else
  ask blue "Install vimrc-amix?"
  if [ $REPLY == "y" ]; then
    instVIMRC
  fi
fi

# -------------------------------------------------------------
# Install: NAVI
# https://github.com/denisidoro/navi
# -------------------------------------------------------------
function instNAVI() {
  # first check/install fzf
  if [ -f /home/darkiop/dotfiles/modules/fzf/README.md ]; then
    # inst fzf (git submodule)
    #bash $HOME/dotfiles/modules/fzf/install --key-bindings --completion --no-update-rc
    bash $HOME/dotfiles/modules/fzf/install --bin
  else
    cd $HOME/dotfiles
    git submodule update --init --recursive
    bash $HOME/dotfiles/modules/fzf/install --bin
  fi
  # install navi by downloading bin
  instlsdarch=$(dpkg --print-architecture)
  case $instlsdarch in
    (amd64)
      cd $HOME/dotfiles/bin
      wget -q https://github.com/denisidoro/navi/releases/download/v2.13.1/navi-v2.13.1-x86_64-unknown-linux-musl.tar.gz -O navi.tar.gz
      sleep 2
      tar xzf navi.tar.gz
      rm navi.tar.gz
      PATH=$PATH:$HOME/dotfiles/bin
    ;;
    (armhf)
      cd $HOME/dotfiles/bin
      wget -q https://github.com/denisidoro/navi/releases/download/v2.13.1/navi-v2.13.1-armv7-unknown-linux-musleabihf.tar.gz -O navi.tar.gz
      sleep 2
      tar xzf navi.tar.gz
      rm navi.tar.gz
      PATH=$PATH:$HOME/dotfiles/bin
    ;;
  esac
  # bash widget (STRG + G)
  eval "$(navi widget bash)"
}
if [ $instNAVI -eq 1 ]; then
  instNAVI
else
  ask blue "Install navi?"
  if [ $REPLY == "y" ]; then
    instNAVI
  fi
fi

# -------------------------------------------------------------
# install cheat.sh
# https://github.com/chubin/cheat.sh#installation
# https://github.com/chubin/cheat.sh#command-line-client-chtsh
# config: ~/.cht.sh/cht.sh.conf
# -------------------------------------------------------------
function instCHEATSH() {
  curl --silent https://cht.sh/:cht.sh > $HOME/dotfiles/bin/cht.sh
  chmod +x $HOME/dotfiles/bin/cht.sh
  if [ ! -d $HOME/.cht.sh ]; then
    mkdir $HOME/.cht.sh
  fi
  if [ ! -L $HOME/.cht.sh/cht.sh.conf ] ; then
    ln -s $HOME/dotfiles/cht.sh.conf $HOME/.cht.sh/cht.sh.conf
  fi
}
if [ $instCHEATSH -eq 1 ]; then
  instCHEATSH
else
  ask blue "Install cheat.sh?"
  if [ $REPLY == "y" ]; then
    instCHEATSH
  fi
fi

# -------------------------------------------------------------
# next step, install bashrc
# -------------------------------------------------------------
ask green "done. run install-bashrc.sh?"
if [ $REPLY == "y" ]; then
  source $HOME/dotfiles/install/install-bashrc.sh
else
  exit
fi

# EOF