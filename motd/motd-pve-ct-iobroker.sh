#!/bin/bash

IOB_BIN=$(command -v iobroker || true)
if [[ -n ${IOB_BIN} && -x ${IOB_BIN} ]]; then

	IOB_VERSION=$(iobroker version)
	NPM_VERSION=$(npm -v)
	NODE_VERSION=$(node -v)

	IOB_SERVICE="$(systemctl is-active iobroker.service)"
	if [[ ${IOB_SERVICE} == "active" ]]; then
		IOB_SERVICE=${COLOR_GREEN}'active'
	elif [[ ${IOB_SERVICE} == 'inactive' ]]; then
		IOB_SERVICE=${COLOR_RED}'inactive'
	elif [[ ${IOB_SERVICE} == 'failed' ]]; then
		IOB_SERVICE=${COLOR_RED}'failed'
	fi

	printf "\n"
	printf "%bjs-controller: %b%s%b / %b%b%b\n" \
		"${COLOR_LIGHT_BLUE}" \
		"${COLOR_GREEN}" "${IOB_VERSION}" "${COLOR_RESET}" \
		"${COLOR_GREEN}" "${IOB_SERVICE}" "${COLOR_RESET}"
	printf "%bnode:          %b%s%b\n" \
		"${COLOR_LIGHT_BLUE}" "${COLOR_GREEN}" "${NODE_VERSION}" "${COLOR_RESET}"
	printf "%bnpm:           %b%s%b\n\n" \
		"${COLOR_LIGHT_BLUE}" "${COLOR_GREEN}" "${NPM_VERSION}" "${COLOR_RESET}"

fi

#EOF
