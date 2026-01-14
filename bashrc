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
    PATH="${PATH:+${PATH}:}$1"
  fi
}
ADD_TO_PATH "$HOME/bin"
ADD_TO_PATH "$HOME/dotfiles/bin"
ADD_TO_PATH "$HOME/.local/bin"
ADD_TO_PATH "$HOME/.cargo/bin"
ADD_TO_PATH "/usr/local/bin"
ADD_TO_PATH "/usr/bin"
ADD_TO_PATH "/bin"

# load dotfiles components
source ~/dotfiles/components/bash_defaults
source ~/dotfiles/components/platform
source ~/dotfiles/components/feature_flags

# Let tmux inherit the shell you started it from (bash vs zsh).
# This is consumed by config/tmux.conf.local via $DOTFILES_TMUX_SHELL.
export DOTFILES_TMUX_SHELL="${BASH:-$(command -v bash 2>/dev/null || true)}"

if dotfiles_flag_enabled DOTFILES_ENABLE_PROMPT; then
  source ~/dotfiles/components/bash_prompt
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_BASH_COMPLETION; then
  source ~/dotfiles/components/bash_completion
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_FZF; then
  source ~/dotfiles/components/fzf
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_NAVI; then
  source ~/dotfiles/components/navi
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
if dotfiles_flag_enabled DOTFILES_ENABLE_TMUX_FZF; then
  source ~/dotfiles/components/tmux_fzf
fi
if dotfiles_flag_enabled DOTFILES_ENABLE_JOURNALCTL_PICKER; then
  source ~/dotfiles/components/journalctl_picker
fi

# load aliases
if dotfiles_flag_enabled DOTFILES_ENABLE_ALIASES; then
  source ~/dotfiles/alias/alias
fi

# MOTD (opt-in)
if dotfiles_flag_enabled DOTFILES_ENABLE_MOTD && dotfiles_flag_enabled DOTFILES_ENABLE_MOTD_AUTO_RUN; then
  if [[ -s ~/dotfiles/motd/motd.sh ]]; then
    source ~/dotfiles/motd/motd.sh
  fi
fi

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
if dotfiles_flag_enabled DOTFILES_ENABLE_AUTOUPDATE && [[ -x ~/dotfiles/autoupdate.sh ]]; then
  source ~/dotfiles/autoupdate.sh
fi

# Run tmux session
if dotfiles_flag_enabled DOTFILES_ENABLE_TMUX_AUTOSTART && command -v tmux &> /dev/null && [[ -n "${PS1}" ]] && [[ ! "${TERM}" =~ screen ]] && [[ ! "${TERM}" =~ tmux ]] && [[ -z "${TMUX}" ]]; then
  tmux -u attach -t default || tmux -u new -s default
fi

# Enable automatic renaming of tmux windows based on ssh connections
if dotfiles_flag_enabled DOTFILES_ENABLE_SSH_TMUX_RENAME && [[ -n $TMUX ]]; then # only inside tmux
  _dotfiles_ssh_extract_target() {
    local arg
    while [[ $# -gt 0 ]]; do
      arg="$1"
      shift

      case "$arg" in
        --)
          # end of options; next arg (if any) is the destination
          [[ $# -gt 0 ]] && printf '%s' "$1"
          return 0
          ;;
        -*)
          # options with separate argument
          case "$arg" in
            -b|-c|-D|-E|-F|-I|-i|-J|-L|-l|-m|-O|-o|-p|-Q|-R|-S|-W|-w)
              [[ $# -gt 0 ]] && shift
              ;;
          esac
          ;;
        *)
          # first non-option is destination (remaining args are remote command)
          printf '%s' "$arg"
          return 0
          ;;
      esac
    done
    return 1
  }

  ssh() {
    # extract the host part and strip user@ / port
    # keep full IPv4 addresses, otherwise strip domain to first label
    local target
    target="$(_dotfiles_ssh_extract_target "$@")" || target=""
    if [[ -z "$target" ]]; then
      command ssh "$@"
      return $?
    fi
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
if dotfiles_flag_enabled DOTFILES_ENABLE_IOBROKER && [[ -x /opt/iobroker/iobroker && $USER == "darkiop" ]]; then
  source ~/.iobroker/iobroker_completions   # Enable ioBroker command auto-completion
  source ~/.iobroker/npm_command_fix        # Forces npm to run as iobroker when inside the iobroker installation dir
fi
