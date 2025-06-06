#!/bin/bash

function update_apt_info_files() {
	# trunk-ignore(shellcheck/SC2312)
	apt-get -s -o Debug::NoLocking=true upgrade | grep -c ^Inst >/usr/local/share/dotfiles/apt-updates-count
	#apt-get -s -o Debug::NoLocking=true upgrade | grep ^Inst | wc -l >/usr/local/share/dotfiles/apt-updates-count
	# trunk-ignore(shellcheck/SC2312)
	apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }' >/usr/local/share/dotfiles/apt-updates-packages
	chmod 777 /usr/local/share/dotfiles/apt-updates-count
	chmod 777 /usr/local/share/dotfiles/apt-updates-packages
}

if [[ -d /usr/local/share/dotfiles ]]; then
	update_apt_info_files
else
	mkdir /usr/local/share/dotfiles
	update_apt_info_files
fi

cat /usr/local/share/dotfiles/apt-updates-count
cat /usr/local/share/dotfiles/apt-updates-packages

# EOF
