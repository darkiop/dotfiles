#!/usr/bin/env bash
# auto update dotfiles

dotfiles_autoupdate() {
	local count_file="${HOME}/.dotfiles-update-count"
	local force=false

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-f | --force)
			force=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Usage: $0 [--force|-f]"
			return 1
			;;
		esac
	done

	# Initialize or read count (defensive: numeric only)
	local startup_count=0
	if [[ -f "${count_file}" ]]; then
		startup_count="$(<"${count_file}")"
		[[ "${startup_count}" =~ ^[0-9]+$ ]] || startup_count=0
	fi

	# Increment and save
	if ! ${force}; then
		echo $((startup_count + 1)) >"${count_file}"
	fi

	# Check whether to update
	if ${force} || [[ ${startup_count} -gt 20 ]]; then
		(
			if [[ ! -d "${HOME}/dotfiles/.git" ]]; then
				exit 0
			fi

			cd "${HOME}/dotfiles" || exit 0

			# Skip if working tree isn't clean.
			git diff --quiet || exit 0
			git diff --cached --quiet || exit 0

			echo "Updating dotfiles ..."
			git pull --ff-only
		) && echo "0" >"${count_file}"
	fi
}

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
	dotfiles_autoupdate "$@"
else
	dotfiles_autoupdate "$@"
	exit $?
fi
