#!/bin/bash
#
# TODO: install checkmk agent + plugins
# TODO: install all without apps
# TODO: fail2ban
# TODO: sshd config

# always exit on error
set -e

# first check if root, when not define a alias with sudo
if [ "${EUID}" -ne 0 ]; then
  dpkg='sudo '$(which dpkg)
  apt='sudo '$(which apt)
else
  dpkg=$(which dpkg)
  apt=$(which apt)
fi

# -------------------------------------------------------------
# check if curl is installed and install it if not
# -------------------------------------------------------------
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' curl|grep "install ok installed")" ]; then
  $apt install curl -y
fi

# -------------------------------------------------------------
# load color vars
# https://bashcolors.com
# -------------------------------------------------------------
if [ ! -f $HOME/dotfiles/shells/colors ]; then
  source <(curl -s https://raw.githubusercontent.com/darkiop/dotfiles/master/shells/colors)
else 
  source $HOME/dotfiles/shells/colors
fi

# -------------------------------------------------------------
# check if user is root and if not exit
# -------------------------------------------------------------
function check_if_user_is_root() {
  if [ "${EUID}" -ne 0 ]; then
    message red "You need to run this as root. Exit."
    exit 1
  fi
}

# -------------------------------------------------------------
# check if sudo is installed
# -------------------------------------------------------------
function check_if_sudo_is_installed() {
  if [ ! $(which sudo) ]; then
    message red "sudo not found. install it ..."
    $apt install sudo -y
  fi
}

# -------------------------------------------------------------
# check if git is installed
# -------------------------------------------------------------
function check_if_git_is_installed() {
  if [ ! $(which git) ]; then
    message red "git not found. install it ..."
    $apt install git -y
  fi
}

# -------------------------------------------------------------
# Ask
# example: 
#   ask blue "Question?"
#   if [ $REPLY == "y" ]; then
#     do something ...
#   fi
# -------------------------------------------------------------
function ask() {
  local color="$1"
  case $color in
    green)
    color=$COLOR_GREEN
    ;;
    blue)
    color=$COLOR_BLUE
    ;;
    lightblue)
    color=$COLOR_LIGHT_BLUE
    ;;
    yellow)
    color=$COLOR_YELLOW
    ;;
    red)
    color=$COLOR_RED
    ;;
  esac
  while true; do
    echo -e "$color"
    read -p "$2 ([y]/n) " -r
    echo -e "$COLOR_CLOSE"
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
# example: message color "text"
# -------------------------------------------------------------
function message() {
  local color="$1"
  case $color in
    green)
    color=$COLOR_GREEN
    ;;
    blue)
    color=$COLOR_BLUE
    ;;
    lightblue)
    color=$COLOR_LIGHT_BLUE
    ;;
    yellow)
    color=$COLOR_YELLOW
    ;;
    red)
    color=$COLOR_RED
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$COLOR_CLOSE"
}

# -------------------------------------------------------------
# main menu
# -------------------------------------------------------------
function show_main_menu(){
  unset opt_main_menu
  echo
  echo -e $COLOR_GREEN"[ darkiop/dotfiles ]"$COLOR_CLOSE
  echo
  printf "${COLOR_YELLOW}1)${COLOR_CLOSE} Install dotfiles\n"
  printf "${COLOR_YELLOW}2)${COLOR_CLOSE} Re-Install dotfiles \n"
  printf "${COLOR_YELLOW}3)${COLOR_CLOSE} Update from github\n"
  printf "${COLOR_YELLOW}4)${COLOR_CLOSE} Setup a new System\n"
  echo
  printf "Please choose an option or ${COLOR_RED}x${COLOR_CLOSE} to exit: "
  read opt_main_menu
}

# -------------------------------------------------------------
# submenu dotfiles
# -------------------------------------------------------------
function show_submenu_dotfiles(){
  echo
  echo -e $COLOR_GREEN"[ Install dotfiles ]"$COLOR_CLOSE
  echo
  printf "${COLOR_YELLOW}1)${COLOR_CLOSE} Install all\n"
  printf "${COLOR_YELLOW}2)${COLOR_CLOSE} Install Apps \n"
  printf "${COLOR_YELLOW}3)${COLOR_CLOSE} Install lsd\n"
  printf "${COLOR_YELLOW}4)${COLOR_CLOSE} Install git submodules\n"
  printf "${COLOR_YELLOW}5)${COLOR_CLOSE} Install vimrc\n"
  printf "${COLOR_YELLOW}6)${COLOR_CLOSE} Install navi\n"
  printf "${COLOR_YELLOW}7)${COLOR_CLOSE} Install cheat.sh\n"
  printf "${COLOR_YELLOW}8)${COLOR_CLOSE} Install bat\n"
  printf "${COLOR_YELLOW}9)${COLOR_CLOSE} Install dategrep\n"
  printf "${COLOR_YELLOW}10)${COLOR_CLOSE} Install .bashrc\n"
  echo
  printf "Please choose an option or ${COLOR_RED}x${COLOR_CLOSE} to exit: "
  read opt_sub_menu_dotfiles
}

# -------------------------------------------------------------
# submenu system-setup
# -------------------------------------------------------------
function show_submenu_system_setup(){
  echo
  echo -e $COLOR_GREEN"[ initial System Setup ]"$COLOR_CLOSE
  echo
  printf "${COLOR_YELLOW}1)${COLOR_CLOSE} all (updates, timezone & locales, add new user, install samba) \n"
  printf "${COLOR_YELLOW}2)${COLOR_CLOSE} System Updates \n"
  printf "${COLOR_YELLOW}3)${COLOR_CLOSE} Setup timezone & locales\n"
  printf "${COLOR_YELLOW}4)${COLOR_CLOSE} Add a new User\n"
  printf "${COLOR_YELLOW}5)${COLOR_CLOSE} Install Samba\n"
  echo
  printf "Please choose an option or ${COLOR_RED}x${COLOR_CLOSE} to exit: "
  read opt_sub_menu_system_setup
}

# -------------------------------------------------------------
# clone repo from github
# -------------------------------------------------------------
function cloneREPO() {
  if [ ! -d $HOME/dotfiles ]; then
    message blue "[ clone dotfiles repo from github ]"
    git clone https://github.com/darkiop/dotfiles $HOME/dotfiles
  else
    message yellow "dotfiles directory already exist. Do nothing and exit."
  fi
}

# -------------------------------------------------------------
# Install dotfiles (all)
# -------------------------------------------------------------
function instDOTF() {
  check_if_sudo_is_installed
  check_if_git_is_installed
  message yellow "+++ Install complete dotfiles +++"
  cloneREPO
  instAPP
  instLSD
  instGITSUBM
  instVIMRC
  instNAVI
  instCHEATSH
  instBAT
  instDATEGREP
  instBASHRC
}

# -------------------------------------------------------------
# Re-Install: dotfiles
# -------------------------------------------------------------
function reinstall() {
  ask red "Re-Install! Are you sure? ~/dotfiles will be deleted. (y/n):"
  case $REPLY in
    y|Y)
      cd $HOME
      message red "delete ~/dotfiles"
      sudo rm -r $HOME/dotfiles
      echo
      message green "reinstall ~/dotfiles"
      cloneREPO
      bash $HOME/dotfiles/install/install.sh all
    ;;
    n|N|*)
      show_main_menu
    ;;
  esac
}

# -------------------------------------------------------------
# Install essential Apps
# -------------------------------------------------------------
function instAPP() {
  message blue "[ Install essential Apps ]"
  $apt update
  $apt install --ignore-missing -y \
  sudo \
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
  tree \
  sshfs
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
      release="0.20.1"
      version="lsd-0.20.1-x86_64-unknown-linux-gnu"
      downloadurl="https://github.com/Peltoche/lsd/releases/download/$release/$version.tar.gz"
      cd $HOME
      wget -O $HOME/lsd.tar.gz $downloadurl
      tar xzf $HOME/lsd.tar.gz
      cp $version/lsd $HOME/dotfiles/bin
      rm $HOME/lsd.tar.gz
      rm -r $HOME/$version
    ;;
    (armhf)
      release="0.20.1"
      version="lsd-0.20.1-arm-unknown-linux-gnueabihf"
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
      ln -s ~/dotfiles/config/lsd.config.yaml ~/.config/lsd/config.yaml
    else
      ln -s ~/dotfiles/config/lsd.config.yaml ~/.config/lsd/config.yaml
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
# Install: dategrep
# https://github.com/mdom/dategrep
# -------------------------------------------------------------
function instDATEGREP() {
  message blue "[ Install dategrep]"
  if [ -f $HOME/dotfiles/modules/dategrep/build-standalone ]; then
    cd $HOME/dotfiles/modules/dategrep
    ./build-standalone
    if [ -f $HOME/dotfiles/modules/dategrep/dategrep ]; then
      cp $HOME/dotfiles/modules/dategrep/dategrep $HOME/dotfiles/bin/dategrep
    else 
      message red "dategrep not installed"
    fi
    cd $HOME
  else
    instGITSUBM
    cd $HOME/dotfiles/modules/dategrep
    ./build-standalone
    if [ -f $HOME/dotfiles/modules/dategrep/dategrep ]; then
      cp $HOME/dotfiles/modules/dategrep/dategrep $HOME/dotfiles/bin/dategrep
    else 
      message red "dategrep not installed"
    fi
    cd $HOME
  fi
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
    message yellow "create directory ~/.cht.sh"
    mkdir $HOME/.cht.sh
  fi
  if [ ! -L $HOME/.cht.sh/cht.sh.conf ] ; then
    message yellow "create symlink ~/.cht.sh/cht.sh.conf"
    ln -s $HOME/dotfiles/config/cht.sh.conf $HOME/.cht.sh/cht.sh.conf
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
      echo -e $COLOR_RED"No changes to the dotfiles were found. Update ..."$COLOR_CLOSE
      echo
      cd ~/dotfiles
      git pull
      cd ~
      #bash ~/.bashrc
      su - $USER
    else
      # changes
      echo
      echo -e $COLOR_RED"Local changes to the dotfiles were found. Check and commit these or run install-reinstall.sh."$COLOR_CLOSE
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
  echo -e $COLOR_GREEN"delete"$COLOR_CLOSE$COLOR_YELLOW" old "$COLOR_GREEN"symlinks ..."$COLOR_CLOSE
  echo
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
  echo -e $COLOR_GREEN"create"$COLOR_CLOSE$COLOR_YELLOW" new "$COLOR_GREEN"symlinks ..."$COLOR_CLOSE
  echo
  for file in $files; do
      echo "create: ~/.$file"
      ln -s $dir/$file ~/.$file
  done
  for folder in $folders; do
      echo "create: ~/.$folder"
      ln -s $dir/$folder ~/.$folder
  done

  # load dotfiles
  echo
  echo -e "$COLOR_YELLOW[ dotfiles installed ]$COLOR_CLOSE"
  echo -e "$COLOR_RED"
  read -p "Relogin to load dotfiles? (y/n):" relogin
  echo -e "$COLOR_CLOSE"
  case $relogin in
    y|Y)
      #bash $HOME/.bashrc
      su - $USER
    ;;
    n|N|*)
      message yellow "Do nothing and exit."
      exit
    ;;
  esac
}

# -------------------------------------------------------------
# install system updates
# -------------------------------------------------------------
function instSYSUPDATES() {
  $apt update
  $apt upgrade -y
  $apt install unattended-upgrades -y
}

# -------------------------------------------------------------
# setup timezone & locales
# -------------------------------------------------------------
function instTIMEZONELOCALES() {
  check_if_user_is_root
  message blue "[ setup timezone & locales ]"
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

# -------------------------------------------------------------
# create a user
# -------------------------------------------------------------
function createUSER() {
  check_if_user_is_root
  message blue "[ create a new user ]"
  read -p 'Username: ';
  useradd -m -s /bin/bash $REPLY
  passwd $REPLY
  usermod -a -G sudo $REPLY
}

# -------------------------------------------------------------
# install samba and create home share
# -------------------------------------------------------------
function instSAMBA() {
  check_if_user_is_root
  message blue "[ install samba and create shares ]"

  # https://unix.stackexchange.com/questions/546470/skip-prompt-when-installing-samba
  echo "samba-common samba-common/workgroup string WORKGROUP" | debconf-set-selections
  echo "samba-common samba-common/dhcp boolean true" | debconf-set-selections
  echo "samba-common samba-common/do_debconf boolean true" | debconf-set-selections
  
  apt install -yq samba-common samba
  
  cp /etc/samba/smb.conf /etc/samba/smb.conf.bak  
  
  if [ -d $HOME/dotfiles ]; then
    cp $HOME/dotfiles/config/smb.conf /etc/samba/smb.conf
  else
    ask yellow "dotfiles not found, install?"
    case $REPLY in
      y|Y)
        check_if_git_is_installed
        cloneREPO
        cp $HOME/dotfiles/config/smb.conf /etc/samba/smb.conf
      ;;
      n|N|*)
        message yellow "Do nothing and exit."
        exit
      ;;
    esac
  fi

  # add samba user
  message blue "Create a user for samba:"
  read -p 'User: ';
  if getent passwd $REPLY > /dev/null 2>&1; then
    smbpasswd -a $REPLY
  else
    message yellow "[ user $REPLY does not exist in passwd. Please create it first ]"
    createUSER
    instSAMBA
  fi

  # restart smb service
  systemctl restart smbd.service
}

# -------------------------------------------------------------
# RUN THE SCRIPT
# -------------------------------------------------------------
if [[ $1 == 'all' ]]; then
  # skip menu and install all
  instDOTF
else
  show_main_menu
  if [ $opt_main_menu = '' ]; then
    exit;
  else
    case $opt_main_menu in
      1) # show sub menu dotfiles
        show_submenu_dotfiles
        case $opt_sub_menu_dotfiles in
          1) # install dotfiles
            instDOTF
            exit
          ;;
          2) # install apps
            instAPP
            show_main_menu
          ;;
          3) # install lsd
            instLSD
            show_main_menu
          ;;
          4) # install git submodules
            instGITSUBM
            show_main_menu
          ;;
          5) # install vimrc
            instVIMRC
            show_main_menu
          ;;
          6) # install navi
            instNAVI
            show_main_menu
          ;;
          7) # install cheat.sh
            instCHEATSH
            show_main_menu
          ;;
          8) # install bat
            instBAT
            show_main_menu
          ;;
          9) # install dategrep
            instDATEGREP
            show_main_menu
          ;;
          10) # install .bashrc
            instBASHRC
          ;;
          x|X) # exit
            exit
          ;;
          *|\n) # typo - show main menu again
            show_main_menu
          ;;
        esac
      ;;
      2) # reinstall
        reinstall
        show_main_menu
      ;;
      3) # update from git
        instUPDATEFROMGIT
        show_main_menu
      ;;
      4) # show sub menu setup a new system
        show_submenu_system_setup
        case $opt_sub_menu_system_setup in
          1) # install all
            instSYSUPDATES
            instTIMEZONELOCALES
            createUSER
            instSAMBA
            exit
          ;;
          2) # system udates
            instSYSUPDATES
            show_main_menu
          ;;
          3) # setup timezone & locales
            instTIMEZONELOCALES
            show_main_menu
          ;;
          4) # add a new user
            createUSER
            show_main_menu
          ;;
          5) # install samba
            instSAMBA
            show_main_menu
          ;;
          x|X) # exit
            exit
          ;;
          *|\n) # typo - show main menu again
            show_main_menu
          ;;
        esac
      ;;
      x|X) # exit
        exit
      ;;
      *|\n) # typo - show main menu again
        show_main_menu
      ;;
    esac
  fi
fi

# EOF