#!/bin/bash
# auto update dot files

COUNT_FILE="$HOME/.dotfiles-update-count"
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
		-f|--force)
			FORCE=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Usage: $0 [--force|-f]"
			exit 1
			;;
	esac
done

# Initialize or read count
if [[ -f "$COUNT_FILE" ]]; then
	STARTUP_COUNT=$(<"$COUNT_FILE")
else
	STARTUP_COUNT=0
fi

# Increment and save
if ! $FORCE; then
	echo $((STARTUP_COUNT + 1)) >"$COUNT_FILE"
fi

# Check whether to update
if $FORCE || [[ $STARTUP_COUNT -gt 20 ]]; then
	echo "Updating dotfiles ..."
	cd "$HOME/dotfiles" || exit 1
	git pull
	echo "0" >"$COUNT_FILE"
fi

# EOF
