#!/usr/bin/env bash
# https://github.com/darkiop/dotfiles

# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# load dotfiles.config
source $HOME/dotfiles/config/dotfiles.config

# define and load directorys for personal $PATH
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}
pathadd "/usr/local/bin"
pathadd "/usr/bin"
pathadd "/bin"
pathadd "$HOME/bin"
pathadd "$HOME/dotfiles/bin"
pathadd "$HOME/.local/bin"
pathadd "$HOME/.cargo/bin"

# load bash defaults
source $HOME/dotfiles/shells/defaults

# load bash prompt
source $HOME/dotfiles/shells/prompt

# load alias
source $HOME/dotfiles/alias/alias

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# fzf completion
if [ -f "$HOME"/dotfiles/modules/fzf-tab-completion/bash/fzf-bash-completion.sh ]; then
  source "$HOME"/dotfiles/modules/fzf-tab-completion/bash/fzf-bash-completion.sh
  bind -x '"\t": fzf_bash_completion'
fi

# load fzf key bindungs
if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# autoupdate dotfiles after 10 logins
if [ -x $HOME/dotfiles/autoupdate.sh ]; then
  bash $HOME/dotfiles/autoupdate.sh
fi

# run tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# EOF