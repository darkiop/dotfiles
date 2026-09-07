#!/bin/bash

# Catppuccin Mocha palette as raw escape bytes.
# https://catppuccin.com/palette
#
# Raw bytes, not "\e[..." strings, so consumers can print them with '%s'.
# Sourced by config/dotfiles.config (interactive shells, `dot help`) and by
# motd/palette.sh (MOTD render + systemd cache updaters), so every part of the
# dotfiles agrees on what "green" means.
#
# Assignments are conditional, so a caller that already set one wins.

: "${CAT_GREEN:=$'\x1b[38;2;166;227;161m'}"    # #a6e3a1
: "${CAT_RED:=$'\x1b[38;2;243;139;168m'}"      # #f38ba8
: "${CAT_YELLOW:=$'\x1b[38;2;249;226;175m'}"   # #f9e2af
: "${CAT_PEACH:=$'\x1b[38;2;250;179;135m'}"    # #fab387
: "${CAT_TEAL:=$'\x1b[38;2;148;226;213m'}"     # #94e2d5
: "${CAT_SKY:=$'\x1b[38;2;137;220;235m'}"      # #89dceb
: "${CAT_BLUE:=$'\x1b[38;2;137;180;250m'}"     # #89b4fa
: "${CAT_SUBTEXT1:=$'\x1b[38;2;186;194;222m'}" # #bac2de
: "${CAT_OVERLAY1:=$'\x1b[38;2;127;132;156m'}" # #7f849c
: "${CAT_RESET:=$'\x1b[0m'}"

export CAT_GREEN CAT_RED CAT_YELLOW CAT_PEACH CAT_TEAL CAT_SKY CAT_BLUE
export CAT_SUBTEXT1 CAT_OVERLAY1 CAT_RESET
