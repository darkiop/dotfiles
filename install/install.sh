#!/bin/bash

# set colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# check if root, when not define alias with sudo
if [[ $EUID -ne 0 ]]; then
  dpkg='sudo '$(which dpkg)
  apt='sudo '$(which apt)
else
  dpkg=$(which dpkg)
  apt=$(which apt)
fi

# -------------------------------------------------------------
# Check if git is installed
# -------------------------------------------------------------
function checkgit() {
  if [ ! $(which git) ]; then
    message red "git not found. install it ..."
    $apt install git -y
  fi
}

# -------------------------------------------------------------
# Ask
# ask blue "Question?"
# if [ $REPLY == "y" ]; then
#   do something ...
# fi
# -------------------------------------------------------------
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
    color=$red_color
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

# -------------------------------------------------------------
# Message
# -------------------------------------------------------------
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
    color=$red_color
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$close_color"
}

# -------------------------------------------------------------
# main menu
# -------------------------------------------------------------
function show_main_menu(){
  echo
  echo -e $green_color"[ darkiop/dotfiles ]"$close_color
  echo
  printf "${yellow_color}1)${close_color} Install dotfiles\n"
  printf "${yellow_color}2)${close_color} Re-Install dotfiles \n"
  printf "${yellow_color}3)${close_color} Update from github\n"
  printf "${yellow_color}4)${close_color} Setup a new System\n"
  echo
  printf "Please choose an option or ${red_color}x${close_color} to exit: "
  read opt_main_menu
}

# -------------------------------------------------------------
# sub menu dotfiles
# -------------------------------------------------------------
function show_sub_menu_dotfiles(){
  echo
  echo -e $green_color"[ Install dotfiles ]"$close_color
  echo
  printf "${yellow_color}1)${close_color} Install all\n"
  printf "${yellow_color}2)${close_color} Install Apps \n"
  printf "${yellow_color}3)${close_color} Install lsd\n"
  printf "${yellow_color}4)${close_color} Install git submodules\n"
  printf "${yellow_color}5)${close_color} Install vimrc\n"
  printf "${yellow_color}6)${close_color} Install navi\n"
  printf "${yellow_color}7)${close_color} Install cheat.sh\n"
  printf "${yellow_color}8)${close_color} Install bat\n"
  printf "${yellow_color}9)${close_color} Install .bashrc\n"
  echo
  printf "Please choose an opt_main_menuion or ${red_color}x${close_color} to exit: "
  read opt_sub_menu_dotfiles
}

# -------------------------------------------------------------
# Install dotfiles (all)
# -------------------------------------------------------------
function instDOTF() {
  checkgit
  message yellow "+++ Install complete dotfiles +++"
  if [ ! -d $HOME/dotfiles ]; then
    message blue "[ clone dotfiles repo from github ]"
    git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
  fi
  instAPP
  instLSD
  instGITSUBM
  instVIMRC
  instNAVI
  instCHEATSH
  instBAT
  instBASHRC
}

# -------------------------------------------------------------
# Re-Install: dotfiles
# -------------------------------------------------------------
function reinstall() {
  ask red "Re-Install! Are you sure? ~/dotfiles will be deleted. (y/n):"
  if [ $REPLY == "y" ]; then
    cd $HOME
    message red "delete ~/dotfiles"
    sudo rm -r $HOME/dotfiles
    echo
    message green "reinstall ~/dotfiles"
    git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
    bash $HOME/dotfiles/install/install-menu.sh all
  else
    exit
  fi
}

# -------------------------------------------------------------
# Install essential Apps
# -------------------------------------------------------------
function instAPP() {
  message blue "[ Install essential Apps ]"
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
  parted
  # tmp: rcconf, sensors
}

# -------------------------------------------------------------
# Install: lsd
# config: ~/.config/lsd/config.yaml
# github: https://github.com/Peltoche/lsd
# -------------------------------------------------------------
function instLSD() {
  message blue "[ Install lsd ]"
  # install lsd by downloading bin from github
  arch=$(dpkg --print-architecture)
  case $arch in
    (amd64)
      release="0.19.0"
      version="lsd-0.19.0-x86_64-unknown-linux-gnu"
      downloadurl="https://github.com/Peltoche/lsd/releases/download/$release/$version.tar.gz"
      cd $HOME
      wget -O $HOME/lsd.tar.gz $downloadurl
      tar xzf $HOME/lsd.tar.gz
      cp $version/lsd $HOME/dotfiles/bin
      rm $HOME/lsd.tar.gz
      rm -r $HOME/$version
    ;;
    (armhf)
      release="0.19.0"
      version="lsd-0.19.0-arm-unknown-linux-gnueabihf"
      downloadurl="https://github.com/Peltoche/lsd/releases/download/$release/$version.tar.gz"
      cd $HOME
      wget -O $HOME/lsd.tar.gz $downloadurl
      tar xzf $HOME/lsd.tar.gz
      cp $version/lsd $HOME/dotfiles/bin
      rm $HOME/lsd.tar.gz
      rm -r $HOME/$version
    ;;
  esac
  # config file
  if [ ! -L ~/.config/lsd/config.yaml ] ; then
    if [ ! -d ~/.config/lsd ]; then
      mkdir -p ~/.config/lsd
      ln -s ~/dotfiles/lsd.config.yaml ~/.config/lsd/config.yaml
    else
      ln -s ~/dotfiles/lsd.config.yaml ~/.config/lsd/config.yaml
    fi
  fi
}

# -------------------------------------------------------------
# Install: git submodules
# see: .gitmodules
# -------------------------------------------------------------
function instGITSUBM() {
  message blue "[ Install git submodules ]"
  cd $HOME/dotfiles
  git submodule--helper list | awk '{print $4}'
  git submodule update --init --recursive
  echo
}

# -------------------------------------------------------------
# Install: vimrc-amix
# -------------------------------------------------------------
function instVIMRC() {
  message blue "[ Install vimrc ]"
  bash $HOME/dotfiles/modules/vimrc-amix/install_awesome_parameterized.sh $HOME/dotfiles/modules/vimrc-amix $USER
  echo
}

# -------------------------------------------------------------
# Install: navi
# https://github.com/denisidoro/navi
# -------------------------------------------------------------
function instNAVI() {
  message blue "[ Install navi]"
  # first check/install fzf
  if [ -f /home/darkiop/dotfiles/modules/fzf/README.md ]; then
    # inst fzf (git submodule)
    #bash $HOME/dotfiles/modules/fzf/install --key-bindings --completion --no-update-rc
    bash $HOME/dotfiles/modules/fzf/install --bin
  else
    instGITSUBM
    cd $HOME/dotfiles
    bash $HOME/dotfiles/modules/fzf/install --bin
  fi
  # install navi by downloading bin from github
  arch=$(dpkg --print-architecture)
  case $arch in
    (amd64)
      release="v2.13.1"
      version="navi-v2.13.1-x86_64-unknown-linux-musl"
      downloadurl="https://github.com/denisidoro/navi/releases/download/$release/$version.tar.gz"
      cd $HOME/dotfiles/bin
      wget -O navi.tar.gz $downloadurl
      tar xzf navi.tar.gz
      rm navi.tar.gz
    ;;
    (armhf)
      release="v2.13.1"
      version="navi-v2.13.1-armv7-unknown-linux-musleabihf"
      downloadurl="https://github.com/denisidoro/navi/releases/download/$release/$version.tar.gz"
      cd $HOME/dotfiles/bin
      wget -O navi.tar.gz $downloadurl
      tar xzf navi.tar.gz
      rm navi.tar.gz
    ;;
  esac
  # bash widget (STRG + G)
  eval "$(navi widget bash)" 2>&1> /dev/null
}

# -------------------------------------------------------------
# Install cheat.sh
# https://github.com/chubin/cheat.sh#installation
# https://github.com/chubin/cheat.sh#command-line-client-chtsh
# config: ~/.cht.sh/cht.sh.conf
# -------------------------------------------------------------
function instCHEATSH() {
  message blue "[ Install cheat.sh]"
  curl https://cht.sh/:cht.sh > $HOME/dotfiles/bin/cht.sh
  chmod +x $HOME/dotfiles/bin/cht.sh
  echo
  if [ ! -d $HOME/.cht.sh ]; then
    message blue "create directory ~/.cht.sh"
    mkdir $HOME/.cht.sh
  fi
  if [ ! -L $HOME/.cht.sh/cht.sh.conf ] ; then
    message blue "create symlink ~/.cht.sh/cht.sh.conf"
    ln -s $HOME/dotfiles/cht.sh.conf $HOME/.cht.sh/cht.sh.conf
  fi
}

# -------------------------------------------------------------
# Install: bat
# https://github.com/sharkdp/bat
# https://ostechnix.com/bat-a-cat-clone-with-syntax-highlighting-and-git-integration/
# -------------------------------------------------------------
function instBAT() {
  message blue "[ Install bat ]"
  # install bat by downloading bin from github
  arch=$(dpkg --print-architecture)
  case $arch in
    (amd64)
      release="v0.17.1"
      version="bat-v0.17.1-x86_64-unknown-linux-gnu"
      downloadurl="https://github.com/sharkdp/bat/releases/download/$release/$version.tar.gz"
      cd $HOME
      wget -O $HOME/bat.tar.gz $downloadurl
      tar xzf $HOME/bat.tar.gz
      cp $version/bat $HOME/dotfiles/bin
      rm $HOME/bat.tar.gz
      rm -r $HOME/$version
    ;;
    (armhf)
      release="v0.17.1"
      version="bat-v0.17.1-arm-unknown-linux-gnueabihf"
      downloadurl="https://github.com/sharkdp/bat/releases/download/$release/$version.tar.gz"
      cd $HOME
      wget -O $HOME/bat.tar.gz $downloadurl
      tar xzf $HOME/bat.tar.gz
      cp $version/bat $HOME/dotfiles/bin
      rm $HOME/bat.tar.gz
      rm -r $HOME/$version
    ;;
  esac
}

# -------------------------------------------------------------
# Update from github (git pull)
# -------------------------------------------------------------
function instUPDATEFROMGIT() {
  if [ -d $HOME/dotfiles ]; then
    git status > /dev/null 2>&1 &
    if git diff-index --quiet HEAD --; then
      # no changes
      echo
      echo -e $red_color"No changes to the dotfiles were found. Update ..."$close_color
      echo
      cd ~/dotfiles
      git pull
      cd ~
      bash ~/.bashrc
    else
      # changes
      echo
      echo -e $red_color"Local changes to the dotfiles were found. Check and commit these or run install-reinstall.sh."$close_color
      echo
    fi
  fi
}

# -------------------------------------------------------------
# Install .bashrc
# -------------------------------------------------------------
function instBASHRC() {
  message blue "[ Install .bashrc ]"

  # install
  dir=~/dotfiles
  files="bashrc gitconfig inputrc bash_profile dircolors"
  folders="byobu"

  # delete old symlinks
  echo -e $green_color"delete"$close_color$yellow_color" old "$green_color"symlinks ..."$close_color
  for file in $files; do
    if [ -f ~/.$file ]; then
      echo "delete: ~/.$file"
      rm ~/.$file
    fi
  done
  for folder in $folders; do
    if [ -d ~/.$folder ]; then
      echo "delete: ~/.$folder";
      rm -r ~/.$folder
    fi
  done

  echo

  # new symlinks for files and folders
  echo -e $green_color"create"$close_color$yellow_color" new "$green_color"symlinks ..."$close_color
  for file in $files; do
      echo "create: ~/.$file"
      ln -s $dir/$file ~/.$file
  done
  for folder in $folders; do
      echo "create: ~/.$folder"
      ln -s $dir/$folder ~/.$folder
  done

  # load .bashrc
  echo -e "$yellow_color"
  echo "dotfiles installed. "
  echo
  read -p "load ~/.bashrc? (y/n):" loadbashrc
  echo -e "$close_color"
  case $loadbashrc in

  esac

  if [ $loadbashrc == "y" ]; then
    bash $HOME/.bashrc
  else
    echo -e $green_color"done. please "$close_color$yellow_color"relogin "$green_color"to load the dotfiles"$close_color
    echo
  fi
}

# -------------------------------------------------------------
# Setup new system
# add user
# install samba
# -------------------------------------------------------------
function setupNewSystem() {

  # check if root
	if [ "${EUID}" -ne 0 ]; then
		message red "You need to run 'Setup a new System' as root. Exit."
		exit 1
	fi

  # 
  # Install System Updates
  #
  function instSYSUPDATES() {
    apt update
    apt upgrade -y
  }
  ask blue "Install system updates?"
  if [ $REPLY == "y" ]; then
    instSYSUPDATES
  fi

  # 
  # Install sudo & git
  #
  ask blue "Install sudo, git, curl & wget?"
  if [ $REPLY == "y" ]; then
    apt install -y sudo git curl wget
  fi

  # 
  # timezone, locales
  #
  function instTIMEZONELOCALES() {
    # timezone
    apt install -y tzdata
    timezone="Europe/Berlin"
    ln -fs /usr/share/zoneinfo/$timezone /etc/localtime
    echo $timezone > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
    # locales
    locales="de_DE.UTF-8"
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
    echo 'LANG="de_DE.UTF-8"'>/etc/default/locale
    dpkg-reconfigure --frontend=noninteractive locales
    update-locale LANG=de_DE.UTF-8
  }
  ask blue "Setup timezone & locales?"
  if [ $REPLY == "y" ]; then
    instTIMEZONELOCALES
  fi

  #
  # adduser
  #
  function addNewUser() {
    # add user
    read -p 'Username: ';
    useradd -m -s /bin/bash $REPLY
    passwd $REPLY
    usermod -a -G sudo $REPLY
  }
  ask blue "Create a personal User?"
  if [ $REPLY == "y" ]; then
    addNewUser
  fi

  #
  # install samba and create shares
  #
  function instSAMBA() {

    # https://unix.stackexchange.com/questions/546470/skip-prompt-when-installing-samba
    echo "samba-common samba-common/workgroup string WORKGROUP" | debconf-set-selections
    echo "samba-common samba-common/dhcp boolean true" | debconf-set-selections
    echo "samba-common samba-common/do_debconf boolean true" | debconf-set-selections
    
    apt install -yq samba-common samba

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

    # add samba user
    message blue "Create a password for Samba User"
    read -p 'User: ';
    smbpasswd -a $REPLY

    # restart smb service
    systemctl restart smbd.service
  }
  ask blue "Install Samba?"
  if [ $REPLY == "y" ]; then
    instSAMBA
  fi
}

# -------------------------------------------------------------
# RUN THE SCRIPT
# -------------------------------------------------------------
if [[ $1 == 'all' ]]; then
  instDOTF
else
  show_main_menu
  if [ $opt_main_menu = '' ]; then
    exit;
  else
    case $opt_main_menu in
      1) # show sub menu dotfiles
        show_sub_menu_dotfiles
        case $opt_sub_menu_dotfiles in
          1) # install dotfiles
            clear
            instDOTF
            exit
          ;;
          2) # install apps
            clear
            instAPP
            show_main_menu
          ;;
          3) # install lsd
            clear
            instLSD
            clear
            show_main_menu
          ;;
          4) # install git submodules
            clear
            instGITSUBM
            show_main_menu
          ;;
          5) # install vimrc
            clear
            instVIMRC
            show_main_menu
          ;;
          6) # install navi
            clear
            instNAVI
            show_main_menu
          ;;
          7) # install cheat.sh
            clear
            instCHEATSH
            show_main_menu
          ;;
          8) # install bat
            clear
            instBAT
            show_main_menu
          ;;
          9) # install .bashrc
            clear
            instBASHRC
          ;;
          x) # exit
            exit
          ;;
          \n) # typo - show main menu again
            show_main_menu
          ;;
          *) # typo - show main menu again
            clear
            show_main_menu
          ;;
        esac
      ;;
      2) # reinstall
        clear
        reinstall
        show_main_menu
      ;;
      3) # update from git
        clear
        instUPDATEFROMGIT
        show_main_menu
      ;;
      4) # setup a new system
        clear
        setupNewSystem
        show_main_menu
      ;;
      x) # exit
        exit
      ;;
      \n) # typo - show main menu again
        show_main_menu
      ;;
      *) # typo - show main menu again
        clear
        show_main_menu
      ;;
    esac
  fi
fi

# EOF