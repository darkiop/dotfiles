# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# byobu
if [ -x "/usr/bin/byobu" ]; then
  _byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
fi