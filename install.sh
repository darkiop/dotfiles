#!/usr/bin/env bash

# Always exit immediately if a command exits with a non-zero status
set -e

# check root function
function IS_USER_ROOT() {
	local uid
	uid=$(id -u) || return 1
	[[ ${uid} -eq 0 ]]
}

# -------------------------------------------------------------
# first check if root, when not define a alias with sudo
# -------------------------------------------------------------
# trunk-ignore(shellcheck/SC2310)
if IS_USER_ROOT; then
	APT='apt'
else
	APT='sudo apt'
fi

# -------------------------------------------------------------
# load COLOR vars
# https://bashCOLORs.com
# -------------------------------------------------------------
function LOAD_COLORS() {
	if [[ ! -f "${HOME}/dotfiles/config/dotfiles.config" ]]; then
		# shellcheck source=/dev/null
		config_url='https://raw.githubusercontent.com/darkiop/dotfiles/master/config/dotfiles.config'
		# trunk-ignore(shellcheck/SC1090)
		# trunk-ignore(shellcheck/SC2312)
		source <(curl -s "${config_url}")
	else
		# shellcheck source=/dev/null
		source ~/dotfiles/config/dotfiles.config
	fi
}

# -------------------------------------------------------------
# check if sudo is installedq
# -------------------------------------------------------------
function CHECK_IF_SUDO_IS_INSTALLED() {
	if command -v sudo >/dev/null 2>&1; then
		return 0
	fi

	if IS_USER_ROOT; then
		MESSAGE red "sudo not found. install it ..."
		${APT} install sudo -y
		return 0
	fi

	MESSAGE red "sudo not found. Please run as root (or install sudo first). Exit."
	exit 1
}

# -------------------------------------------------------------
# check if curl is installed
# -------------------------------------------------------------
function CHECK_IF_CURL_IS_INSTALLED() {
	if ! command -v curl >/dev/null 2>&1; then
		MESSAGE red "curl not found. install it ..."
		${APT} install curl -y
	fi
}

# -------------------------------------------------------------
# check if git is installed
# -------------------------------------------------------------
function CHECK_IF_GIT_IS_INSTALLED() {
	if ! command -v git >/dev/null 2>&1; then
		MESSAGE red "git not found. install it ..."
		${APT} install git -y
	fi
}

# -------------------------------------------------------------
# ASK
# example:
#   ASK blue "Question?"
#   if [ $REPLY == "y" ]; then
#     do something ...
#   fi
# -------------------------------------------------------------
function ASK() {
	local COLOR="$1"
	case ${COLOR} in
	green)
		COLOR=${COLOR_GREEN}
		;;
	blue)
		COLOR=${COLOR_BLUE}
		;;
	lightblue)
		COLOR=${COLOR_LIGHT_BLUE}
		;;
	yellow)
		COLOR=${COLOR_YELLOW}
		;;
	red)
		COLOR=${COLOR_RED}
		;;
	*)
		COLOR=${COLOR_DEFAULT}
		;;
	esac
	while true; do
		echo -e "${COLOR}"
		read -p "$2 ([y]/n) " -r
		echo -e "${COLOR_CLOSE}"
		REPLY=${REPLY:-"y"}
		if [[ ${REPLY} =~ ^[Yy]$ ]]; then
			return 1
		elif [[ ${REPLY} =~ ^[Nn]$ ]]; then
			return 0
		fi
	done
}

# -------------------------------------------------------------
# MESSAGE
# example: MESSAGE COLOR "text"
# -------------------------------------------------------------
function MESSAGE() {
	local COLOR="$1"
	case ${COLOR} in
	green)
		COLOR=${COLOR_GREEN}
		;;
	blue)
		COLOR=${COLOR_BLUE}
		;;
	lightblue)
		COLOR=${COLOR_LIGHT_BLUE}
		;;
	yellow)
		COLOR=${COLOR_YELLOW}
		;;
	red)
		COLOR=${COLOR_RED}
		;;
	*)
		COLOR=${COLOR_DEFAULT}
		;;
	esac
	echo -e "${COLOR}$2${COLOR_CLOSE}"
}

# -------------------------------------------------------------
# Print Main-Menu
# -------------------------------------------------------------
function SHOW_MAIN_MENU() {
	unset opt_main_menu
	echo
	# Use printf '%b' to expand backslash escapes in the variable:
	printf '%b[ darkiop/dotfiles ]%b\n\n' \
		"${COLOR_GREEN}" "${COLOR_CLOSE}"

	# Now use %b for COLORs, then literal “1)”, then %b to close COLOR:
	printf '%b1)%b Install dotfiles (all)\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	printf '%b2)%b Install git submodules\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	printf '%b3)%b Install shell config\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	printf '%b4)%b Install MOTD systemd timers\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	echo

	# Prompt line, again using %b for red “x” and reset:
	printf 'Please choose an option or %bx%b to exit: ' \
		"${COLOR_RED}" "${COLOR_CLOSE}"

	read -r opt_main_menu
}

# -------------------------------------------------------------
# Clone repo from github
# -------------------------------------------------------------
function CLONE_REPO() {
	if [[ ! -d "${HOME}/dotfiles" ]]; then
		MESSAGE blue "[ Clone dotfiles repository from github ]"
		git clone --recurse-submodules --shallow-submodules https://github.com/darkiop/dotfiles "${HOME}/dotfiles"
		cd "${HOME}/dotfiles"
		git config pull.rebase false
	else
		MESSAGE lightblue "Dotfiles directory already exist. Do not clone again."
	fi
}

# -------------------------------------------------------------
# Install bash_completition.d
# -------------------------------------------------------------
#function instBASHCOMPLE() {
#  MESSAGE blue "[ Install bash_completitions ]"
#  if [ -L "~/.bash_completion.d" ] ; then
#    if [ ! -e "~/.bash_completion.d" ] ; then
#        # remove > broken
#        rm "~/.bash_completion.d"
#        echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
#        ln -s "~"/dotfiles/bash_completion.d ~/.bash_completion.d
#    fi
#  else
#    # link not exist
#    echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
#    ln -s "~"/dotfiles/bash_completion.d ~/.bash_completion.d
#  fi
#
#  # argcomplete
#  # https://github.com/kislyuk/argcomplete
#  if [ ! IS_USER_ROOT ]; then
#    if [[ ! -x /usr/local/bin/activate-global-python-argcomplete ]]; then
#      pip3 install argcomplete
#      if [ -f "~"/.local/bin/activate-global-python-argcomplete ]; then
#        "~"/.local/bin/activate-global-python-argcomplete --dest="~"/dotfiles/bash_completion.d
#      fi
#    else
#      if [ -f "~"/.local/bin/activate-global-python-argcomplete ]; then
#        "~"/.local/bin/activate-global-python-argcomplete --dest="~"/dotfiles/bash_completion.d
#      fi
#    fi
#  fi
#}

# -------------------------------------------------------------
# Install: vimrc-amix
# -------------------------------------------------------------
function INSTALL_VIMRC() {
	echo
	VIMRC_DIR="${HOME}/dotfiles/modules/vimrc"
	VIMRC_INSTALL="${VIMRC_DIR}/install_awesome_vimrc.sh"
	MESSAGE blue "[ Install vimrc ]"

	# Ensure the vimrc submodule is available (install_awesome_vimrc.sh lives inside it).
	if [[ ! -x "${VIMRC_INSTALL}" && -d "${HOME}/dotfiles/.git" ]]; then
		MESSAGE lightblue "Initializing vimrc submodule..."
		(
			cd "${HOME}/dotfiles" || exit 1
			git submodule update --init --recursive --depth 1 modules/vimrc
		)
	fi

	if [[ ! -x "${VIMRC_INSTALL}" ]]; then
		MESSAGE red "vimrc installer not found at ${VIMRC_INSTALL}. Did submodules download correctly?"
		return 1
	fi

	MESSAGE lightblue "Creating symlink for vimrc runtime directory from ${HOME}/dotfiles/modules/vimrc to ${HOME}/.vim_runtime"
	ln -sf -- "${VIMRC_DIR}" "${HOME}/.vim_runtime"
	MESSAGE lightblue "Creating symlink for vimrc configuration file from ${HOME}/dotfiles/config/vimrc/my_configs.vim to ${HOME}/.vim_runtime/my_configs.vim"
	ln -sf -- "${HOME}"/dotfiles/config/vimrc/my_configs.vim "${HOME}/.vim_runtime/my_configs.vim"
	echo -e "${COLOR_LIGHT_BLUE}"
	bash "${VIMRC_INSTALL}" "${VIMRC_DIR}" "${USER}"
	echo -e "${COLOR_CLOSE}"
}

# -------------------------------------------------------------
# Install: oh-my-tmux
# -------------------------------------------------------------
function INSTALL_TMUX() {
	MESSAGE blue "[ Install oh-my-tmux and tmux plugin manager ]"
	if [[ ! -d "${HOME}"/.tmux/plugins ]]; then
		mkdir -p "${HOME}"/.tmux/plugins
	fi
	MESSAGE lightblue "Creating symlink for .tmux.conf from dotfiles/modules/oh-my-tmux/.tmux.conf to ~/.tmux.conf"
	ln -sf -- "${HOME}"/dotfiles/modules/oh-my-tmux/.tmux.conf "${HOME}"/.tmux.conf
	MESSAGE lightblue "Creating symlink for tmux plugin manager (tpm) from dotfiles/modules/tpm to ~/.tmux/plugins/tpm"
	ln -sf -- "${HOME}"/dotfiles/modules/tpm "${HOME}"/.tmux/plugins/tpm
	MESSAGE lightblue "Creating symlink for .tmux.conf.local from dotfiles/config/tmux.conf.local to ~/.tmux.conf.local"
	ln -sf -- "${HOME}"/dotfiles/config/tmux.conf.local "${HOME}"/.tmux.conf.local
}

# -------------------------------------------------------------
# Install: helix
# -------------------------------------------------------------
function INSTALL_HELIX() {
	MESSAGE blue "[ Install helix configuration ]"
	if [[ ! -d "${HOME}"/.config/helix ]]; then
		mkdir -p "${HOME}"/.config/helix
	fi
	MESSAGE lightblue "Creating symlink for .config.toml from dotfiles/config/helix/config.toml to ~/.config/helix/config.toml"
	ln -sf -- "${HOME}"/dotfiles/config/helix/config.toml "${HOME}"/.config/helix/config.toml
}

# -------------------------------------------------------------
# Install gut submodules
# -------------------------------------------------------------
function INSTALL_GIT_SUBMODULES() {
	MESSAGE blue "[ Install git submodules ]"
	if [[ -d "${HOME}"/dotfiles ]]; then
		cd "${HOME}"/dotfiles || exit
		git submodule update --init --recursive --depth 1
	else
		MESSAGE red "Dotfiles directory not found. Please clone the repository first."
		exit 1
	fi
}

# -------------------------------------------------------------
# install fzf from submodule (never via apt)
# -------------------------------------------------------------
function INSTALL_FZF() {
	if ls ~/.fzf.* &>/dev/null; then
		rm ~/.fzf.*
	fi
	if [[ -e ~/.fzf ]]; then
		rm -rf ~/.fzf
	fi
	# trunk-ignore(shellcheck/SC2312)
	if dpkg -l | grep -qw fzf; then
		MESSAGE yellow "Removing existing apt fzf installation (fzf is managed via dotfiles submodule)"
		${APT} purge -y fzf
	fi
	MESSAGE blue "[ Install fzf ]"
	if [[ -x "${HOME}/dotfiles/modules/fzf/install" ]]; then
		"${HOME}/dotfiles/modules/fzf/install" --key-bindings --completion --no-update-rc
	else
		MESSAGE red "fzf directory not found. Please clone the repository first."
		exit 1
	fi
}

# -------------------------------------------------------------
# Install: MOTD systemd timers (optional)
# -------------------------------------------------------------
function INSTALL_MOTD_TIMERS() {
	MESSAGE blue "[ Install MOTD systemd timers ]"
	CHECK_IF_SUDO_IS_INSTALLED

	local DOTFILES_DIR="${HOME}/dotfiles"
	local SYSTEMD_DIR="/etc/systemd/system"
	local SUDO=""
	if ! IS_USER_ROOT; then
		SUDO="sudo"
	fi

	if [[ ! -d "${DOTFILES_DIR}/motd/systemd" ]]; then
		MESSAGE red "MOTD systemd directory not found at ${DOTFILES_DIR}/motd/systemd"
		return 1
	fi
	if [[ ! -d "${SYSTEMD_DIR}" ]]; then
		MESSAGE red "systemd system directory not found at ${SYSTEMD_DIR}"
		return 1
	fi
	if ! command -v systemctl >/dev/null 2>&1; then
		MESSAGE red "systemctl not found. Skipping systemd timer installation."
		return 1
	fi

	MESSAGE lightblue "Installing unit files to ${SYSTEMD_DIR} (ExecStart paths are templated to ${DOTFILES_DIR})"
	local unit_src unit_dst tmp
	for unit_src in "${DOTFILES_DIR}/motd/systemd/"*.service "${DOTFILES_DIR}/motd/systemd/"*.timer; do
		[[ -f "${unit_src}" ]] || continue
		unit_dst="${SYSTEMD_DIR}/$(basename "${unit_src}")"
		tmp="$(mktemp)"
		sed "s|/home/darkiop/dotfiles|${DOTFILES_DIR}|g" "${unit_src}" >"${tmp}"
		${SUDO} install -m 0644 "${tmp}" "${unit_dst}"
		rm -f "${tmp}"
	done

	${SUDO} systemctl daemon-reload

	local enable_now=""
	read -r -p "Enable and start MOTD timers now? (y/N): " enable_now
	case "${enable_now}" in
	y | Y)
		${SUDO} systemctl enable --now update-motd-apt-infos.timer calc-dir-size-homes.timer
		;;
	*)
		MESSAGE yellow "Timers installed but not enabled."
		;;
	esac
}

# -------------------------------------------------------------
# Install .bashrc
# -------------------------------------------------------------
function LINK_DOTFILES() {
	echo
	MESSAGE blue "[ Install shell config ]"

	# install
	dir="${HOME}"/dotfiles
	files="bashrc gitconfig inputrc bash_profile dircolors zshrc zprofile"
	timestamp="$(date +%Y%m%d-%H%M%S)"

	echo -e "${COLOR_GREEN}""Delete""${COLOR_CLOSE}""${COLOR_YELLOW}"" old ""${COLOR_GREEN}""symlinks / backup files ...""${COLOR_CLOSE}"
	for file in ${files}; do
		target="${HOME}/.${file}"

		if [[ -L "${target}" ]]; then
			MESSAGE lightblue "Removing existing symlink ${target}"
			rm -f -- "${target}"
		elif [[ -f "${target}" ]]; then
			MESSAGE lightblue "Backing up existing file ${target} -> ${target}.bak.${timestamp}"
			mv -- "${target}" "${target}.bak.${timestamp}"
		elif [[ -e "${target}" ]]; then
			MESSAGE yellow "Skipping ${target} (not a file/symlink)"
		fi
	done
	# new symlinks for files
	echo -e "${COLOR_GREEN}""Create""${COLOR_CLOSE}""${COLOR_YELLOW}"" new ""${COLOR_GREEN}""symlinks ...""${COLOR_CLOSE}"
	for file in ${files}; do
		MESSAGE lightblue "Creating symlink for ${dir}/${file} to ~/.${file}"
		ln -sf -- "${dir}/${file}" "${HOME}/.${file}"
	done
}

# -------------------------------------------------------------
# load .bashrc
# -------------------------------------------------------------
function LOAD_BASHRC() {
	echo
	echo -e "${COLOR_YELLOW}""[ dotfiles installed ]""${COLOR_CLOSE}"
	echo -e "${COLOR_RED}"
	read -rp "Relogin to load dotfiles? (y/n):" relogin
	echo -e "${COLOR_CLOSE}"
	case ${relogin} in
	y | Y)
		su - "${USER}"
		;;
	n | N | *)
		MESSAGE yellow "Do nothing and exit."
		exit
		;;
	esac
}

# -------------------------------------------------------------
# install: dotfiles (all)
# -------------------------------------------------------------
function INSTALL_DOTFILES() {
	MESSAGE yellow "+++ Install dotfiles (all) +++"
	CHECK_IF_SUDO_IS_INSTALLED
	CHECK_IF_CURL_IS_INSTALLED
	LOAD_COLORS
	CHECK_IF_GIT_IS_INSTALLED
	CLONE_REPO
	INSTALL_GIT_SUBMODULES
	#instBASHCOMPLE
	INSTALL_VIMRC
	INSTALL_HELIX
	INSTALL_TMUX
	INSTALL_FZF
	LINK_DOTFILES
}

# -------------------------------------------------------------
# RUN THE SCRIPT
# -------------------------------------------------------------
if [[ $1 == 'all' ]]; then
	# skip menu and install all
	INSTALL_DOTFILES
	if [[ $2 == 'load-bashrc' ]]; then
		LOAD_BASHRC
	fi
else
	SHOW_MAIN_MENU
	if [[ ${opt_main_menu} == '' ]]; then
		exit
	else
		case ${opt_main_menu} in
		1) # install dotfiles
			INSTALL_DOTFILES
			exit
			;;
		2) # install git submodules
			INSTALL_GIT_SUBMODULES
			exit
			;;
		3) # link dotfiles
			LINK_DOTFILES
			exit
			;;
		4) # install MOTD systemd timers
			INSTALL_MOTD_TIMERS
			exit
			;;
		x | X) # exit
			exit
			;;
		*) # typo - show main menu again
			SHOW_MAIN_MENU
			;;
		esac
	fi
fi

# EOF
