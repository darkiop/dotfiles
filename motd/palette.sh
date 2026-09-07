#!/bin/bash

# Shared MOTD status colours (Catppuccin Mocha), as raw escape bytes.
#
# These are printed with '%s' by widgets.sh, the systemd cache updaters and the
# per-host widget scripts, so they must not be "\e[..." strings like the palette
# in motd-catppuccin-mocha.sh, which motd.sh resolves with '%b'.
#
# Assignments are conditional, so a caller that already set them wins.

: "${MOTD_COLOR_SUCCESS:=$'\x1b[38;2;166;227;161m'}" # green
: "${MOTD_COLOR_FAILURE:=$'\x1b[38;2;243;139;168m'}" # red
: "${MOTD_COLOR_RESET:=$'\x1b[m'}"

export MOTD_COLOR_SUCCESS MOTD_COLOR_FAILURE MOTD_COLOR_RESET
