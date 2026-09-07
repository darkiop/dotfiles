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
# Appends a fallback directory at the end of $PATH.
ADD_TO_PATH() {
  if [[ -d "$1" ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    PATH="${PATH:+${PATH}:}$1"
  fi
}

# Puts the given directories at the front of $PATH, in the order listed, so
# tools installed there shadow the system ones instead of being shadowed by
# them. Existing occurrences are removed first.
ADD_TO_PATH_FRONT() {
  local front="" rest="" dir entry
  for dir in "$@"; do
    [[ -d "${dir}" ]] || continue
    case ":${front}:" in *":${dir}:"*) continue ;; esac
    front="${front:+${front}:}${dir}"
  done
  [[ -n ${front} ]] || return 0

  local IFS=:
  for entry in ${PATH}; do
    [[ -z ${entry} ]] && continue
    case ":${front}:" in *":${entry}:"*) continue ;; esac
    rest="${rest:+${rest}:}${entry}"
  done
  PATH="${front}${rest:+:${rest}}"
}

ADD_TO_PATH_FRONT "$HOME/bin" "$HOME/dotfiles/bin" "$HOME/.local/bin" "$HOME/.cargo/bin"
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

# Components that must be loaded eagerly (have keybindings or are always needed)
if [[ "${DOTFILES_ENABLE_PROMPT}" == true ]]; then
  source ~/dotfiles/components/bash_prompt_catppuccin_mocha
fi
if [[ "${DOTFILES_ENABLE_BASH_COMPLETION}" == true ]]; then
  source ~/dotfiles/components/bash_completion
fi
if [[ "${DOTFILES_ENABLE_FZF}" == true ]]; then
  source ~/dotfiles/components/fzf
fi
if [[ "${DOTFILES_ENABLE_NAVI}" == true ]]; then
  source ~/dotfiles/components/navi
fi
if [[ "${DOTFILES_ENABLE_GIT_FZF}" == true ]]; then
  source ~/dotfiles/components/fzf_git
fi
if [[ "${DOTFILES_ENABLE_FZF_EXTRAS}" == true ]]; then
  source ~/dotfiles/components/fzf_extras
fi
if [[ "${DOTFILES_ENABLE_BREW}" == true ]]; then
  source ~/dotfiles/components/brew
fi
if [[ "${DOTFILES_ENABLE_TMUX_FZF}" == true ]]; then
  source ~/dotfiles/components/fzf_tmux
fi
if [[ "${DOTFILES_ENABLE_DOT_HELP}" == true ]]; then
  source ~/dotfiles/components/dot_help
fi

# Lazy-loadable components (loaded on first use to reduce startup time)
if [[ "${DOTFILES_ENABLE_LAZY_LOADING}" == true ]]; then
  source ~/dotfiles/components/lazy_loader
  [[ "${DOTFILES_ENABLE_SSH_PICKER}" == true ]] && \
    dotfiles_lazy_register sshp ssh_picker
  [[ "${DOTFILES_ENABLE_JOURNALCTL_PICKER}" == true ]] && \
    dotfiles_lazy_register jctl journalctl_picker
  [[ "${DOTFILES_ENABLE_LOG_PICKER}" == true ]] && \
    dotfiles_lazy_register lctl log_picker
  [[ "${DOTFILES_ENABLE_HELPERS}" == true ]] && \
    dotfiles_lazy_register dcheat helpers cheat helpme
  [[ "${DOTFILES_ENABLE_DOCKER_FZF}" == true ]] && \
    dotfiles_lazy_register dps fzf_docker dexec dlogs
  [[ "${DOTFILES_ENABLE_SYSTEMCTL_FZF}" == true ]] && \
    dotfiles_lazy_register sctl fzf_systemctl
  [[ "${DOTFILES_ENABLE_DOT_DOCTOR}" == true ]] && \
    dotfiles_lazy_register dot_doctor dot_doctor
else
  # Fallback: eager loading when lazy loading is disabled
  if [[ "${DOTFILES_ENABLE_SSH_PICKER}" == true ]]; then
    source ~/dotfiles/components/ssh_picker
  fi
  if [[ "${DOTFILES_ENABLE_JOURNALCTL_PICKER}" == true ]]; then
    source ~/dotfiles/components/journalctl_picker
  fi
  if [[ "${DOTFILES_ENABLE_LOG_PICKER}" == true ]]; then
    source ~/dotfiles/components/log_picker
  fi
  if [[ "${DOTFILES_ENABLE_HELPERS}" == true ]]; then
    source ~/dotfiles/components/helpers
  fi
  if [[ "${DOTFILES_ENABLE_DOCKER_FZF}" == true ]]; then
    source ~/dotfiles/components/fzf_docker
  fi
  if [[ "${DOTFILES_ENABLE_SYSTEMCTL_FZF}" == true ]]; then
    source ~/dotfiles/components/fzf_systemctl
  fi
  if [[ "${DOTFILES_ENABLE_DOT_DOCTOR}" == true ]]; then
    source ~/dotfiles/components/dot_doctor
  fi
fi

# load aliases
if [[ "${DOTFILES_ENABLE_ALIASES}" == true ]]; then
  source ~/dotfiles/alias/alias
fi

# MOTD (opt-in)
if [[ "${DOTFILES_ENABLE_MOTD}" == true ]] && [[ "${DOTFILES_ENABLE_MOTD_AUTO_RUN}" == true ]]; then
  if [[ -s ~/dotfiles/motd/motd-catppuccin-mocha.sh ]]; then
    source ~/dotfiles/motd/motd-catppuccin-mocha.sh
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
if command -v dircolors >/dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
elif command -v gdircolors >/dev/null 2>&1; then
  test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
fi

# Autoupdate dotfiles after 20 logins
if [[ "${DOTFILES_ENABLE_AUTOUPDATE}" == true ]] && [[ -x ~/dotfiles/autoupdate.sh ]]; then
  source ~/dotfiles/autoupdate.sh
fi

# Run tmux session
if [[ "${DOTFILES_ENABLE_TMUX_AUTOSTART}" == true ]] && command -v tmux &> /dev/null && [[ -n "${PS1}" ]] && [[ ! "${TERM}" =~ screen ]] && [[ ! "${TERM}" =~ tmux ]] && [[ -z "${TMUX}" ]]; then
  tmux -u attach -t default || tmux -u new -s default
fi

# Enable automatic renaming of tmux windows based on ssh connections
if [[ "${DOTFILES_ENABLE_SSH_TMUX_RENAME}" == true ]] && [[ -n $TMUX ]]; then # only inside tmux
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

    if [[ $target == *:*:* ]]; then
      : # IPv6 address (2+ colons), keep full
    else
      target=${target%%:*}
      if [[ $target =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
        : # IPv4 address, keep full
      else
        target=${target%%.*}
      fi
    fi

    tmux rename-window "$target"      # rename before we connect
    command ssh "$@"                  # run the real ssh
    tmux set -w automatic-rename on   # restore when we exit
  }
fi

# ioBroker
if [[ "${DOTFILES_ENABLE_IOBROKER}" == true ]] && [[ -x /opt/iobroker/iobroker ]]; then
  # Enable ioBroker command auto-completion
  if [[ -f ~/.iobroker/iobroker_completions ]]; then
    source ~/.iobroker/iobroker_completions
  fi
  # Forces npm to run as iobroker when inside the iobroker installation dir
  if [[ -f ~/.iobroker/npm_command_fix ]]; then
    source ~/.iobroker/npm_command_fix
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
