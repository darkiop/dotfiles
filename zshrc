#!/usr/bin/env zsh

# Guard: this file is meant to be sourced by zsh (sourcing it from bash will fail).
if [[ -z "${ZSH_VERSION:-}" ]]; then
  return 0
fi

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# load dotfiles.config (colors, settings)
source ~/dotfiles/config/dotfiles.config
source ~/dotfiles/components/zsh_defaults

# PATH handling (append; avoid duplicates)
ADD_TO_PATH() {
  if [[ -d "$1" ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    export PATH="${PATH:+${PATH}:}$1"
  fi
}
ADD_TO_PATH "$HOME/bin"
ADD_TO_PATH "$HOME/dotfiles/bin"
ADD_TO_PATH "$HOME/.local/bin"
ADD_TO_PATH "$HOME/.cargo/bin"
ADD_TO_PATH "/usr/local/bin"
ADD_TO_PATH "/usr/bin"
ADD_TO_PATH "/bin"

# platform + feature flags
source ~/dotfiles/components/platform
source ~/dotfiles/components/feature_flags

# Optional: oh-my-zsh
if dotfiles_flag_enabled DOTFILES_ENABLE_OH_MY_ZSH && [[ -d "$HOME/dotfiles/modules/oh-my-zsh" ]]; then
  export ZSH="$HOME/dotfiles/modules/oh-my-zsh"
  export ZSH_DISABLE_COMPFIX=true
  export DISABLE_AUTO_UPDATE=true
  plugins=()
  # shellcheck disable=SC1090
  source "$ZSH/oh-my-zsh.sh"
fi

# Let tmux inherit the shell you started it from (bash vs zsh).
# This is consumed by config/tmux.conf.local via $DOTFILES_TMUX_SHELL.
export DOTFILES_TMUX_SHELL="${commands[zsh]:-$(command -v zsh 2>/dev/null || true)}"

# components
if dotfiles_flag_enabled DOTFILES_ENABLE_PROMPT; then
  source ~/dotfiles/components/zsh_prompt
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_BASH_COMPLETION; then
  source ~/dotfiles/components/zsh_completion
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_FZF; then
  source ~/dotfiles/components/fzf
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_NAVI; then
  source ~/dotfiles/components/navi
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_ALIASES; then
  source ~/dotfiles/alias/alias
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_SSH_PICKER; then
  source ~/dotfiles/components/ssh_picker
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_GIT_FZF; then
  source ~/dotfiles/components/fzf_git
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_FZF_EXTRAS; then
  source ~/dotfiles/components/fzf_extras
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_HELPERS; then
  source ~/dotfiles/components/helpers
fi

# MOTD (opt-in)
if dotfiles_flag_enabled DOTFILES_ENABLE_MOTD && dotfiles_flag_enabled DOTFILES_ENABLE_MOTD_AUTO_RUN; then
  if [[ -s ~/dotfiles/motd/motd.sh ]]; then
    source ~/dotfiles/motd/motd.sh
  fi
fi

# Enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
  [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Autoupdate dotfiles after ~20 logins (runs via bash)
if dotfiles_flag_enabled DOTFILES_ENABLE_AUTOUPDATE && [[ -x ~/dotfiles/autoupdate.sh ]] && command -v bash >/dev/null 2>&1; then
  bash ~/dotfiles/autoupdate.sh
fi

# Run tmux session
if dotfiles_flag_enabled DOTFILES_ENABLE_TMUX_AUTOSTART && command -v tmux >/dev/null 2>&1 && [[ -n "${PS1}" ]] && [[ ! "${TERM}" =~ screen ]] && [[ ! "${TERM}" =~ tmux ]] && [[ -z "${TMUX}" ]]; then
  tmux -u attach -t default || tmux -u new -s default
fi

# Enable automatic renaming of tmux windows based on ssh connections
if dotfiles_flag_enabled DOTFILES_ENABLE_SSH_TMUX_RENAME && [[ -n "${TMUX}" ]]; then
  _dotfiles_ssh_extract_target() {
    local arg
    while [[ $# -gt 0 ]]; do
      arg="$1"
      shift

      case "$arg" in
        --)
          [[ $# -gt 0 ]] && print -r -- "$1"
          return 0
          ;;
        -*)
          case "$arg" in
            -b|-c|-D|-E|-F|-I|-i|-J|-L|-l|-m|-O|-o|-p|-Q|-R|-S|-W|-w)
              [[ $# -gt 0 ]] && shift
              ;;
          esac
          ;;
        *)
          print -r -- "$arg"
          return 0
          ;;
      esac
    done
    return 1
  }

  ssh() {
    local target
    target="$(_dotfiles_ssh_extract_target "$@")" || target=""
    if [[ -z "$target" ]]; then
      command ssh "$@"
      return $?
    fi

    target=${target##*@}
    target=${target%%:*}
    if [[ ! "$target" =~ '^[0-9]+(\.[0-9]+){3}$' ]]; then
      target=${target%%.*}
    fi

    tmux rename-window "$target"
    command ssh "$@"
    tmux set -w automatic-rename on
  }
fi

# ioBroker
if dotfiles_flag_enabled DOTFILES_ENABLE_IOBROKER && [[ -x /opt/iobroker/iobroker && $USER == "darkiop" ]]; then
  source ~/.iobroker/iobroker_completions
  source ~/.iobroker/npm_command_fix
fi
