#!/bin/bash
# /volume1 usage widget for the Synology NAS "odin"
# Replaces the former motd/motd-odin.sh, which was never routed anywhere.
# Output format: label:value (required by motd_run_widgets)

set -euo pipefail

[[ -d /volume1 ]] || exit 1

read -r total used pct < <(df -h /volume1 2>/dev/null | awk '/\// {print $(NF-4), $(NF-3), $(NF-1)}') || true

[[ -z ${used} || -z ${total} ]] && exit 1

printf "volume1:%s of %s (%s)" "${used}" "${total}" "${pct}"
