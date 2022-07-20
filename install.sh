#!/usr/bin/env bash

# -------------------------------------------------------------
# always exit on error
# -------------------------------------------------------------
set -e

# -------------------------------------------------------------
# check root function
# https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
# -------------------------------------------------------------
function is_user_root () {
  [ "$(id -u)" -eq 0 ];
}

# -------------------------------------------------------------
# check if user is root and if not exit
# -------------------------------------------------------------
function if_user_root_msg() {
  if [ is_user_root ]; then
    message red "You need to run this as root. Exit."
    exit 1
  fi
}

# -------------------------------------------------------------
# first check if root, when not define a alias with sudo
# -------------------------------------------------------------
if [ is_user_root ]; then
  apt=$(whereis apt)
else
  apt='sudo '$(whereis apt)
fi

# -------------------------------------------------------------
# load color vars
# https://bashcolors.com
# -------------------------------------------------------------
function loadColors () {
  if [ ! -f "$HOME/dotfiles/config/dotfiles.config" ]; then
    source <(curl -s https://raw.githubusercontent.com/darkiop/dotfiles/master/config/dotfiles.config)
  else 
    source "$HOME/dotfiles/config/dotfiles.config"
  fi
}

# -------------------------------------------------------------
# check if sudo is installed
# -------------------------------------------------------------
function check_if_sudo_is_installed() {
  if [ ! "$(whereis sudo)" ]; then
    message red "sudo not found. install it ..."
    $apt install sudo -y
  fi
}

# -------------------------------------------------------------
# check if curl is installed
# -------------------------------------------------------------
function check_if_curl_is_installed() {
  if [ ! "$(whereis curl)" ]; then
    message red "curl not found. install it ..."
    $apt install curl -y
  fi
}

# -------------------------------------------------------------
# check if git is installed
# -------------------------------------------------------------
function check_if_git_is_installed() {
  if [ ! "$(whereis git)" ]; then
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
  echo -e "$COLOR_GREEN""[ darkiop/dotfiles ]""$COLOR_CLOSE"
  echo
  printf "${COLOR_YELLOW}1)${COLOR_CLOSE} Install dotfiles (all)\n"
  printf "${COLOR_YELLOW}2)${COLOR_CLOSE} Install git submodules\n"
  printf "${COLOR_YELLOW}5)${COLOR_CLOSE} Install .bashrc\n"
  echo
  printf "Please choose an option or ${COLOR_RED}x${COLOR_CLOSE} to exit: "
  read -r opt_main_menu
}

# -------------------------------------------------------------
# clone repo from github
# -------------------------------------------------------------
function cloneREPO() {
  if [ ! -d "$HOME/dotfiles" ]; then
    message blue "[ clone dotfiles repo from github ]"
    git clone --recurse-submodules https://github.com/darkiop/dotfiles "$HOME/dotfiles"
    cd "$HOME/dotfiles"
    git config pull.rebase false
  else
    message yellow "dotfiles directory already exist."
  fi
}

# -------------------------------------------------------------
# Install bash_completition.d
# -------------------------------------------------------------
function instBASHCOMPLE() {
  message blue "[ Install bash_completitions ]"
  if [ -L "$HOME/.bash_completion.d" ] ; then
    if [ ! -e "$HOME/.bash_completion.d" ] ; then
        # remove > broken
        rm "$HOME/.bash_completion.d"
        echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
        ln -s "$HOME"/dotfiles/bash_completion.d ~/.bash_completion.d
    fi
  else
    # link not exist
    echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
    ln -s "$HOME"/dotfiles/bash_completion.d ~/.bash_completion.d
  fi

  # argcomplete
  # https://github.com/kislyuk/argcomplete
  if [ ! is_user_root ]; then
    if [[ ! -x /usr/local/bin/activate-global-python-argcomplete ]]; then
      pip3 install argcomplete
      if [ -f "$HOME"/.local/bin/activate-global-python-argcomplete ]; then
        "$HOME"/.local/bin/activate-global-python-argcomplete --dest="$HOME"/dotfiles/bash_completion.d
      fi
    else
      if [ -f "$HOME"/.local/bin/activate-global-python-argcomplete ]; then
        "$HOME"/.local/bin/activate-global-python-argcomplete --dest="$HOME"/dotfiles/bash_completion.d
      fi
    fi
  fi
}

# -------------------------------------------------------------
# install: vimrc-amix
# -------------------------------------------------------------
function instVIMRC() {
  message blue "[ Install vimrc ]"
  if [ -L "$HOME"/dotfiles/modules/vimrc/my_configs.vim ] ; then
    rm "$HOME"/dotfiles/modules/vimrc/my_configs.vim
  fi
  bash "$HOME"/dotfiles/modules/vimrc/install_awesome_parameterized.sh "$HOME"/dotfiles/modules/vimrc "$USER"
  ln -s "$HOME"/dotfiles/config/my_configs.vim "$HOME"/dotfiles/modules/vimrc/my_configs.vim
  echo
}

# -------------------------------------------------------------
# install: oh-my-tmux
# -------------------------------------------------------------
function instTMUX() {
  message blue "[ Install oh-my-tmux and tmux plugin manager ]"
  if [ -L "$HOME"/.tmux.conf ] ; then
    rm "$HOME"/.tmux.conf
  fi
  if [ -L "$HOME"/.tmux.conf.local ] ; then
    rm "$HOME"/.tmux.conf.local
  fi
  ln -s "$HOME"/dotfiles/modules/oh-my-tmux/.tmux.conf "$HOME"/.tmux.conf
  ln -s "$HOME"/dotfiles/config/tmux.conf.local "$HOME"/.tmux.conf.local
  if [ ! -d "$HOME"/.tmux/plugins ] ; then
    mkdir -p "$HOME"/.tmux/plugins
  fi
  if [ ! -L "$HOME"/.tmux/plugins/tpm ] ; then
    ln -s "$HOME"/dotfiles/modules/tpm "$HOME"/.tmux/plugins/tpm
  fi
  echo
}

# -------------------------------------------------------------
# Install .bashrc
# -------------------------------------------------------------
function instBASHRC() {
  message blue "[ Install .bashrc ]"

  # install
  dir="$HOME"/dotfiles
  files="bashrc gitconfig inputrc bash_profile dircolors"

  # delete old symlinks
  echo -e "$COLOR_GREEN""delete""$COLOR_CLOSE""$COLOR_YELLOW"" old ""$COLOR_GREEN""symlinks ...""$COLOR_CLOSE"
  for file in $files; do
    if [ -f "$HOME"/."$file" ]; then
      echo "delete: ~/.$file"
      rm "$HOME"/."$file"
    fi
  done
  echo
  # new symlinks for files
  echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" new ""$COLOR_GREEN""symlinks ...""$COLOR_CLOSE"
  for file in $files; do
      echo "create: ~/.$file"
      ln -s "$dir/$file" ~/."$file"
  done
  echo
}

# -------------------------------------------------------------
# load .bashrc
# -------------------------------------------------------------
function loadBASHRC() {
  echo
  echo -e "$COLOR_YELLOW""[ dotfiles installed ]""$COLOR_CLOSE"
  echo -e "$COLOR_RED"
  read -rp "Relogin to load dotfiles? (y/n):" relogin
  echo -e "$COLOR_CLOSE"
  case $relogin in
    y|Y)
      su - "$USER"
    ;;
    n|N|*)
      message yellow "Do nothing and exit."
      exit
    ;;
  esac
}

# -------------------------------------------------------------
# install: dotfiles (all)
# -------------------------------------------------------------
function instDOTF() {
  message yellow "+++ Install dotfiles (all) +++"
  check_if_sudo_is_installed
  check_if_curl_is_installed
  loadColors
  check_if_git_is_installed
  cloneREPO
  instBASHCOMPLE
  instVIMRC
  instTMUX
  instBASHRC
}

# -------------------------------------------------------------
# RUN THE SCRIPT
# -------------------------------------------------------------
if [[ $1 == 'all' ]]; then
  # skip menu and install all
  instDOTF
  if [[ $2 == 'load-bashrc' ]]; then
    loadBASHRC
  fi
else
  show_main_menu
  if [ "$opt_main_menu" = '' ]; then
    exit;
  else
    case $opt_main_menu in
      1) # install dotfiles
        instDOTF
        exit
      ;;
      2) # install .bashrc
        instBASHRC
      ;;
      x|X) # exit
        exit
      ;;
      *|\n) # typo - show main menu again
        show_main_menu
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