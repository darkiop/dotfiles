#!/bin/bash
# Catppuccin Mocha theme wrapper for motd.sh - Variant 3 (cool: teal/sky/blue)
# https://catppuccin.com/palette

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"

_CAT_TEAL="\e[38;2;148;226;213m"
_CAT_SKY="\e[38;2;137;220;235m"
_CAT_SAPPHIRE="\e[38;2;116;199;236m"
_CAT_BLUE="\e[38;2;137;180;250m"
_CAT_RED="\e[38;2;243;139;168m"
_CAT_GREEN="\e[38;2;166;227;161m"
_CAT_SUBTEXT1="\e[38;2;186;194;222m"

COLOR_BLUE="${_CAT_SKY}"
COLOR_LIGHT_BLUE="${_CAT_TEAL}"
COLOR_GREEN="${_CAT_SUBTEXT1}"
COLOR_YELLOW="${_CAT_BLUE}"
COLOR_RED="${_CAT_RED}"
COLOR_RESET="\033[m"

# The COLOR_* vars above are consumed by motd.sh with printf '%b', so they stay
# "\e"-escaped. The widgets in widgets.sh print their own colors with '%s', so
# these two carry real escape bytes, shared with the systemd cache updaters and
# the per-host widget scripts via motd/palette.sh.
# shellcheck source=palette.sh
source "${DOTFILES_DIR:-${HOME}/dotfiles}/motd/palette.sh"
COLOR_SUCCESS="${MOTD_COLOR_SUCCESS}"
COLOR_FAILURE="${MOTD_COLOR_FAILURE}"

export COLOR_BLUE COLOR_LIGHT_BLUE COLOR_GREEN COLOR_YELLOW COLOR_RED COLOR_RESET
export COLOR_SUCCESS COLOR_FAILURE

# shellcheck source=motd.sh
source "${DOTFILES_DIR}/motd/motd.sh"
