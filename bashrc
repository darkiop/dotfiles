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
pathadd() {
  if [[ -d "$1" ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":${PATH}"}"
  fi
}
pathadd "/usr/local/bin"
pathadd "/usr/bin"
pathadd "/bin"
pathadd "~/bin"
pathadd "~/dotfiles/bin"
pathadd "~/.local/bin"
pathadd "~/.cargo/bin"

# load dotfiles components
source ~/dotfiles/components/defaults
source ~/dotfiles/components/prompt
source ~/dotfiles/components/bash_completion
source ~/dotfiles/components/fzf
source ~/dotfiles/components/navi

# load aliases
source ~/dotfiles/alias/alias

# set variable identifying the chroot you work in (used in the prompt below)
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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# autoupdate dotfiles after 20 logins
if [[ -x ${HOME}/dotfiles/autoupdate.sh ]]; then
  source ~/dotfiles/autoupdate.sh
fi

# run tmux
if command -v tmux &> /dev/null && [[ -n "${PS1}" ]] && [[ ! "${TERM}" =~ screen ]] && [[ ! "${TERM}" =~ tmux ]] && [[ -z "${TMUX}" ]]; then
  tmux -u attach -t default || tmux -u new -s default
fi
