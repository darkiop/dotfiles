#!/bin/bash

# Shared MOTD status colours (Catppuccin Mocha), as raw escape bytes.
#
# These are printed with '%s' by widgets.sh, the systemd cache updaters and the
# per-host widget scripts, so they must not be "\e[..." strings like the palette
# in motd-catppuccin-mocha.sh, which motd.sh resolves with '%b'.
#
# Assignments are conditional, so a caller that already set them wins.

# shellcheck source=../config/catppuccin.sh
source "${HOME}/dotfiles/config/catppuccin.sh"

: "${MOTD_COLOR_SUCCESS:=${CAT_GREEN}}"
: "${MOTD_COLOR_FAILURE:=${CAT_RED}}"
: "${MOTD_COLOR_RESET:=${CAT_RESET}}"

export MOTD_COLOR_SUCCESS MOTD_COLOR_FAILURE MOTD_COLOR_RESET
