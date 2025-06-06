#!/bin/bash
# This script calculates the size of the root (/) and /home directories
# and stores the results in /usr/local/share/dotfiles/dir-sizes/dir-sizes.txt.

OUTPUT_DIR="/usr/local/share/dotfiles"
OUTPUT_FILE="${OUTPUT_DIR}/dir-sizes"

# Ensure the output directory exists
mkdir -p "${OUTPUT_DIR}" || {
	echo "Failed to create directory: ${OUTPUT_DIR}"
	exit 1
}

# Calculate and capture sizes (human-readable, suppressing errors)
SIZE_HOME=$(du -sh /home 2>/dev/null | awk '{print $1}')

# Write results to the output file
echo "${SIZE_HOME}" >"${OUTPUT_FILE}"

cat "${OUTPUT_FILE}"

# EOF
