# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# load dotfiles.config
source ~/dotfiles/config/dotfiles.config

# define and load directorys for personal $PATH
ADD_TO_PATH() {
  if [[ -d "$1" ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":${PATH}"}"
  fi
}
ADD_TO_PATH "/usr/local/bin"
ADD_TO_PATH "/usr/bin"
ADD_TO_PATH "/bin"
ADD_TO_PATH "~/bin"
ADD_TO_PATH "~/dotfiles/bin"
ADD_TO_PATH "~/.local/bin"
ADD_TO_PATH "~/.cargo/bin"

# load dotfiles components
source ~/dotfiles/components/defaults
source ~/dotfiles/components/prompt
source ~/dotfiles/components/bash_completion
source ~/dotfiles/components/fzf
source ~/dotfiles/components/navi

# load aliases
source ~/dotfiles/alias/alias

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Autoupdate dotfiles after 20 logins
if [[ -x ~/dotfiles/autoupdate.sh ]]; then
  source ~/dotfiles/autoupdate.sh
fi

# Run tmux session
if command -v tmux &> /dev/null && [[ -n "${PS1}" ]] && [[ ! "${TERM}" =~ screen ]] && [[ ! "${TERM}" =~ tmux ]] && [[ -z "${TMUX}" ]]; then
  tmux -u attach -t default || tmux -u new -s default
fi

# Enable automatic renaming of tmux windows based on ssh connections
if [[ -n $TMUX ]]; then # only inside tmux
  ssh() {
    # extract the host part and strip user@ / port
    # keep full IPv4 addresses, otherwise strip domain to first label
    local target=$1
    target=${target##*@}
    target=${target%%:*}

    if [[ $target =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
      : # IPv4 address, keep full
    else
      target=${target%%.*}
    fi

    tmux rename-window "$target"      # rename before we connect
    command ssh "$@"                  # run the real ssh
    tmux set -w automatic-rename on   # restore when we exit
  }
fi

# ioBroker
if [[ -x /opt/iobroker/iobroker && $USER == "darkiop" ]]; then
  source ~/.iobroker/iobroker_completions   # Enable ioBroker command auto-completion
  source ~/.iobroker/npm_command_fix        # Forces npm to run as iobroker when inside the iobroker installation dir
fi
