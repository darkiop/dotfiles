#!/usr/bin/env zsh

# Guard: this file is meant to be sourced by zsh.
if [[ -z "${ZSH_VERSION:-}" ]]; then
  return 0
fi

# Login shell setup (keeps behavior similar to bash_profile).
if [[ -f ~/.zshrc ]]; then
  source ~/.zshrc
fi
