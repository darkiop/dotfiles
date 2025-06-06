#!/usr/bin/env bash

# -------------------------------------------------------------
# always exit on error
# -------------------------------------------------------------
set -e

# -------------------------------------------------------------
# check root function
# https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
# -------------------------------------------------------------
function is_user_root() {
	[[ "$(id -u)" -eq 0 ]]
}

# -------------------------------------------------------------
# check if user is root and if not exit
# -------------------------------------------------------------
function if_user_root_msg() {
	if [[ is_user_root ]]; then
		message red "You need to run this as root. Exit."
		exit 1
	fi
}

# -------------------------------------------------------------
# first check if root, when not define a alias with sudo
# -------------------------------------------------------------
if [[ is_user_root ]]; then
	apt=$(whereis apt)
else
	apt='sudo '$(whereis apt)
fi

# -------------------------------------------------------------
# load color vars
# https://bashcolors.com
# -------------------------------------------------------------
function loadColors() {
	if [[ ! -f "${HOME}/dotfiles/config/dotfiles.config" ]]; then
		source <(curl -s https://raw.githubusercontent.com/darkiop/dotfiles/master/config/dotfiles.config)
	else
		source "${HOME}/dotfiles/config/dotfiles.config"
	fi
}

# -------------------------------------------------------------
# check if sudo is installed
# -------------------------------------------------------------
function check_if_sudo_is_installed() {
	#if [[ ! -n "$(whereis sudo)" ]]; then
  if [[ -z "$(whereis sudo || true )" ]]; then
		message red "sudo not found. install it ..."
		${apt} install sudo -y
	fi
}

# -------------------------------------------------------------
# check if curl is installed
# -------------------------------------------------------------
function check_if_curl_is_installed() {
	if [[ ! "$(whereis curl)" ]]; then
		message red "curl not found. install it ..."
		${apt} install curl -y
	fi
}

# -------------------------------------------------------------
# check if git is installed
# -------------------------------------------------------------
function check_if_git_is_installed() {
	if [[ ! "$(whereis git)" ]]; then
		message red "git not found. install it ..."
		${apt} install git -y
	fi
}

# -------------------------------------------------------------
# Ask
# example:
#   ask blue "Question?"
#   if [ $REPLY == "y" ]; then
#     do something ...
#   fi
# -------------------------------------------------------------
function ask() {
	local color="$1"
	case ${color} in
	green)
		color=${COLOR_GREEN}
		;;
	blue)
		color=${COLOR_BLUE}
		;;
	lightblue)
		color=${COLOR_LIGHT_BLUE}
		;;
	yellow)
		color=${COLOR_YELLOW}
		;;
	red)
		color=${COLOR_RED}
		;;
	*)
		color=${COLOR_DEFAULT}
		;;
	esac
	while true; do
		echo -e "${color}"
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
# Message
# example: message color "text"
# -------------------------------------------------------------
function message() {
	local color="$1"
	case ${color} in
	green)
		color=${COLOR_GREEN}
		;;
	blue)
		color=${COLOR_BLUE}
		;;
	lightblue)
		color=${COLOR_LIGHT_BLUE}
		;;
	yellow)
		color=${COLOR_YELLOW}
		;;
	red)
		color=${COLOR_RED}
		;;
	*)
		color=${COLOR_DEFAULT}
		;;
	esac
	echo -e "${color}"
	echo "$2"
	echo -e "${COLOR_CLOSE}"
}

# -------------------------------------------------------------
# main menu
# -------------------------------------------------------------
function show_main_menu() {
	unset opt_main_menu
	echo
	# Use printf '%b' to expand backslash escapes in the variable:
	printf '%b[ darkiop/dotfiles ]%b\n\n' \
		"${COLOR_GREEN}" "${COLOR_CLOSE}"

	# Now use %b for colors, then literal “1)”, then %b to close color:
	printf '%b1)%b Install dotfiles (all)\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	printf '%b2)%b Install git submodules\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	printf '%b5)%b Install .bashrc\n' \
		"${COLOR_YELLOW}" "${COLOR_CLOSE}"

	echo

	# Prompt line, again using %b for red “x” and reset:
	printf 'Please choose an option or %bx%b to exit: ' \
		"${COLOR_RED}" "${COLOR_CLOSE}"

	read -r opt_main_menu
}

# -------------------------------------------------------------
# clone repo from github
# -------------------------------------------------------------
function cloneREPO() {
	if [[ ! -d "${HOME}/dotfiles" ]]; then
		message blue "[ clone dotfiles repo from github ]"
		git clone --recurse-submodules https://github.com/darkiop/dotfiles "${HOME}/dotfiles"
		cd "${HOME}/dotfiles"
		git config pull.rebase false
	else
		message yellow "dotfiles directory already exist."
	fi
}

# -------------------------------------------------------------
# Install bash_completition.d
# -------------------------------------------------------------
#function instBASHCOMPLE() {
#  message blue "[ Install bash_completitions ]"
#  if [ -L "$HOME/.bash_completion.d" ] ; then
#    if [ ! -e "$HOME/.bash_completion.d" ] ; then
#        # remove > broken
#        rm "$HOME/.bash_completion.d"
#        echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
#        ln -s "$HOME"/dotfiles/bash_completion.d ~/.bash_completion.d
#    fi
#  else
#    # link not exist
#    echo -e "$COLOR_GREEN""create""$COLOR_CLOSE""$COLOR_YELLOW"" bash_completion.d ""$COLOR_GREEN""symlink ...""$COLOR_CLOSE"
#    ln -s "$HOME"/dotfiles/bash_completion.d ~/.bash_completion.d
#  fi
#
#  # argcomplete
#  # https://github.com/kislyuk/argcomplete
#  if [ ! is_user_root ]; then
#    if [[ ! -x /usr/local/bin/activate-global-python-argcomplete ]]; then
#      pip3 install argcomplete
#      if [ -f "$HOME"/.local/bin/activate-global-python-argcomplete ]; then
#        "$HOME"/.local/bin/activate-global-python-argcomplete --dest="$HOME"/dotfiles/bash_completion.d
#      fi
#    else
#      if [ -f "$HOME"/.local/bin/activate-global-python-argcomplete ]; then
#        "$HOME"/.local/bin/activate-global-python-argcomplete --dest="$HOME"/dotfiles/bash_completion.d
#      fi
#    fi
#  fi
#}

# -------------------------------------------------------------
# install: vimrc-amix
# -------------------------------------------------------------
function instVIMRC() {
	VIMRC_INSTALL="${HOME}/dotfiles/modules/vimrc/install_awesome_parameterized.sh"
	message blue "[ Install vimrc ]"
  message lightblue "Creating symlink for vimrc runtime directory from ${HOME}/dotfiles/modules/vimrc to ${HOME}/.vim_runtime"
  ln -sf -- "${HOME}"/dotfiles/modules/vimrc "${HOME}/.vim_runtime"
  message lightblue "Creating symlink for vimrc configuration file from ${HOME}/dotfiles/config/vimrc/my_configs.vim to ${HOME}/.vim_runtime/my_configs.vim"
  ln -sf -- "${HOME}"/dotfiles/config/vimrc/my_configs.vim "${HOME}/.vim_runtime/my_configs.vim"
  echo
	bash "${VIMRC_INSTALL}" "${HOME}"/dotfiles/modules/vimrc "${USER}"
	echo
}

# -------------------------------------------------------------
# install: oh-my-tmux
# -------------------------------------------------------------
function instTMUX() {
	message blue "[ Install oh-my-tmux and tmux plugin manager ]"
	if [[ ! -d "${HOME}"/.tmux/plugins ]]; then
		mkdir -p "${HOME}"/.tmux/plugins
	fi
  message lightblue "Creating symlink for .tmux.conf from dotfiles/modules/oh-my-tmux/.tmux.conf to ~/.tmux.conf"
  ln -sf -- "${HOME}"/dotfiles/modules/oh-my-tmux/.tmux.conf "${HOME}"/.tmux.conf

  message lightblue "Creating symlink for tmux plugin manager (tpm) from dotfiles/modules/tpm to ~/.tmux/plugins/tpm"
  ln -sf -- "${HOME}"/dotfiles/modules/tpm "${HOME}"/.tmux/plugins/tpm

  message lightblue "Creating symlink for .tmux.conf.local from dotfiles/config/tmux.conf.local to ~/.tmux.conf.local"
  ln -sf -- "${HOME}"/dotfiles/config/tmux.conf.local "${HOME}"/.tmux.conf.local
	echo
}

# -------------------------------------------------------------
# Install .bashrc
# -------------------------------------------------------------
function instBASHRC() {
	message blue "[ Install .bashrc ]"

	# install
	dir="${HOME}"/dotfiles
	files="bashrc gitconfig inputrc bash_profile dircolors"

	# delete old symlinks
	echo -e "${COLOR_GREEN}""Delete""${COLOR_CLOSE}""${COLOR_YELLOW}"" old ""${COLOR_GREEN}""symlinks ...""${COLOR_CLOSE}"
	for file in ${files}; do
		if [[ -f "${HOME}"/."${file}" ]]; then
      echo "Deleting existing symlink for configuration file ~/.${file} to prepare for a fresh installation."
			rm "${HOME}"/."${file}"
		fi
	done
	echo
	# new symlinks for files
	echo -e "${COLOR_GREEN}""Create""${COLOR_CLOSE}""${COLOR_YELLOW}"" new ""${COLOR_GREEN}""symlinks ...""${COLOR_CLOSE}"
  for file in ${files}; do
    echo "Creating symlink for ${dir}/${file} to ~/.${file}"
    ln -s "${dir}/${file}" ~/."${file}"
  done
	echo
}

# -------------------------------------------------------------
# load .bashrc
# -------------------------------------------------------------
function loadBASHRC() {
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
		message yellow "Do nothing and exit."
		exit
		;;
	esac
}

# -------------------------------------------------------------
# install: dotfiles (all)
# -------------------------------------------------------------
function instDOTF() {
	message yellow "+++ Install dotfiles (all) +++"
	check_if_sudo_is_installed
	check_if_curl_is_installed
	loadColors
	check_if_git_is_installed
	cloneREPO
	#instBASHCOMPLE
	instVIMRC
	instTMUX
	instBASHRC
}

# -------------------------------------------------------------
# RUN THE SCRIPT
# -------------------------------------------------------------
if [[ $1 == 'all' ]]; then
	# skip menu and install all
	instDOTF
	if [[ $2 == 'load-bashrc' ]]; then
		loadBASHRC
	fi
else
	show_main_menu
	if [[ ${opt_main_menu} == '' ]]; then
		exit
	else
		case ${opt_main_menu} in
		1) # install dotfiles
			instDOTF
			exit
			;;
		2) # install .bashrc
			instBASHRC
			;;
		x | X) # exit
			exit
			;;
		* | \n) # typo - show main menu again
			show_main_menu
			;;
		x | X) # exit
			exit
			;;
		* | \n) # typo - show main menu again
			show_main_menu
			;;
		esac
	fi
fi

# EOF
