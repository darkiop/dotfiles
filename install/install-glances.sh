#!/bin/bash
# https://github.com/nicolargo/glances
# https://glances.readthedocs.io/en/latest/index.html

function msg() {
  local TEXT="$1"
  echo
  echo -e "$TEXT"
  echo
}

function info() {
  local REASON="$1"
  local FLAG="\e[36m[INFO]\e[39m"
  msg "$FLAG $REASON"
}

function warn() {
  local REASON="\e[97m$1\e[39m"
  local FLAG="\e[93m[WARNING]\e[39m"
  msg "$FLAG $REASON"
}

# check if root
if [ "${EUID}" -ne 0 ]; then
  warn "You need to run this as root." >&2;
  exit 1
fi

# install glances
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' glances|grep "install ok installed")" ]; then
  info "glanes is not installed, run installation ..."
  apt install -y glances
else
  info "glanes is installed, nothing todo."
fi

# create systemd unit file for glances-web
info "create a systemd unit file for glances-web"
cat <<'EOF' > /etc/systemd/system/glances-web.service
[Unit]
Description = Glances in Web Server Mode
After = network.target
[Service]
ExecStart = /usr/bin/glances  -w  -t  5
[Install]
WantedBy = multi-user.target
EOF

# reload systemd daemon
systemctl daemon-reload

# enable glances-web.service
systemctl enable glances-web.service

# enable glances-web.service
systemctl start glances-web.service

# show status of glances-web.service
info "systemd status:"
systemctl status glances-web.service

STATUS="$(systemctl is-active glances-web.service)"
if [ "${STATUS}" = "active" ]; then
  info "done. glanes-web runs on:"
  echo -e "http://"$HOSTNAME":61208"
else
  warn "glances-web is not running!"
fi