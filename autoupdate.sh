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
		local update_rc=0
		(
			if [[ ! -d "${HOME}/dotfiles/.git" ]]; then
				exit 0
			fi

			cd "${HOME}/dotfiles" || exit 0

			# Skip if working tree isn't clean.
			git diff --quiet || exit 0
			git diff --cached --quiet || exit 0

			echo "Updating dotfiles ..."
			# Do not recurse into submodules even if user has `submodule.recurse=true`
			# (common in global gitconfig) to avoid SSH-only submodule fetch failures.
			# Cap the runtime so an unreachable remote cannot stall the shell start.
			local timeout_bin=""
			if command -v timeout >/dev/null 2>&1; then
				timeout_bin="timeout"
			elif command -v gtimeout >/dev/null 2>&1; then
				timeout_bin="gtimeout"
			fi
			if [[ -n ${timeout_bin} ]]; then
				"${timeout_bin}" 30 git -c submodule.recurse=false pull --ff-only
			else
				git -c submodule.recurse=false pull --ff-only
			fi
		) || update_rc=$?

		# Reset the counter regardless of the outcome. Resetting only on success
		# left the count above the threshold after a failed pull, so every later
		# shell start hit the network again.
		echo "0" >"${count_file}"

		if [[ ${update_rc} -ne 0 ]]; then
			echo "dotfiles auto-update failed (exit ${update_rc}); retrying later." >&2
		fi
	fi
}

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
	dotfiles_autoupdate "$@"
else
	dotfiles_autoupdate "$@"
	exit $?
fi
