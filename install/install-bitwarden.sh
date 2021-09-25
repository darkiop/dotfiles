#!/bin/bash
#
# vaultwarden install script

vaultwardenUser=vaultwarden

# https://github.com/dani-garcia/vaultwarden/releases/
vaultwardenVersion="1.22.1"

# https://github.com/dani-garcia/bw_web_builds/releases
bwWebVersion="2.20.4b"

# first check if root, when not define a alias with sudo
# TODO: test with sudo
if [ "${EUID}" -ne 0 ]; then
  apt='sudo '$(which apt)
  adduser='sudo '$(which adduser)
  cat='sudo '$(which cat)
  sed='sudo '$(which sed)
  chown='sudo '$(which chown)
  mkdir='sudo '$(which mkdir)
else
  apt=$(which apt)
  adduser=$(which adduser)
  cat=$(which cat)
  sed=$(which sed)
  chown=$(which chown)
  mkdir=$(which mkdir)
fi

# -------------------------------------------------------------
# load color vars
# https://bashcolors.com
# -------------------------------------------------------------
if [ ! -f $HOME/dotfiles/config/dotfiles.config ]; then
  source <(curl -s https://raw.githubusercontent.com/darkiop/dotfiles/master/config/dotfiles.config)
else 
  source $HOME/dotfiles/config/dotfiles.config
fi

# ask function
function ask() {
  local color="$1"
  case $color in
    green)
    color=$COLOR_GREEN
    ;;
    blue)
    color=$COLOR_BLUE
    ;;
    lightblue)
    color=$COLOR_LIGHT_BLUE
    ;;
    yellow)
    color=$COLOR_YELLOW
    ;;
    red)
    color=$COLOR_RED
    ;;
  esac
  while true; do
    echo -e "$color"
    read -p "$2 ([y]/n) " -r
    echo -e "$COLOR_CLOSE"
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

# message function (example: message color "text")
function message() {
  local color="$1"
  case $color in
    green)
    color=$COLOR_GREEN
    ;;
    blue)
    color=$COLOR_BLUE
    ;;
    lightblue)
    color=$COLOR_LIGHT_BLUE
    ;;
    yellow)
    color=$COLOR_YELLOW
    ;;
    red)
    color=$COLOR_RED
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$COLOR_CLOSE"
}

# check if vaultwarden is installed
if [ -d /opt/vaultwarden/vaultvarden-$vaultwardenVersion ]; then
  # TODO: check if installed and ask
  ask yellow "Vaultwarden installion found, delete and reinstall?"
  case $REPLY in
    y|Y)
      message yellow "Delete old files ..."
      rm -r /opt/vaultwarden/vaultvarden-$vaultwardenVersion
      rm -r /etc/systemd/system/vaultwarden.service
      rm -r /etc/vaultwarden.env
      rm -r /var/lib/vaultwarden
    ;;
    n|N|*)
      message yellow "Do nothing and exit."
      exit
    ;;
  esac
else
  message yellow "No Vaultwarden installation found, run installation ..."
fi

# install dependencys
$apt update
$apt install -y git wget curl nodejs npm build-essential pkg-config

# create system user for vaultwarden
if [ ! `id -u $vaultwardenUser 2>/dev/null || echo -1` -ge 0 ]; then 
  $adduser --system --no-create-home --group vaultwarden
fi

# vaultvarden main directory
if [ ! -d /opt/vaultwarden ]; then
  $mkdir /opt/vaultwarden
fi

# vaultvarden lib directory
if [ ! -d /var/lib/vaultwarden ]; then
  $mkdir /var/lib/vaultwarden
fi

# vaultvarden data directory
if [ ! -d /var/lib/vaultwarden/data ]; then
  $mkdir /var/lib/vaultwarden/data
fi

# download and install vaultvarden
curl https://sh.rustup.rs -sSf | sh
echo 'export PATH=~/.cargo/bin:$PATH' >> ~/.bashrc
export PATH=~/.cargo/bin:$PATH
cd /opt/vaultwarden
wget https://github.com/dani-garcia/vaultwarden/archive/refs/tags/$vaultwardenVersion.tar.gz
tar xf $vaultwardenVersion.tar.gz
rm $vaultwardenVersion.tar.gz
cd /opt/vaultwarden
pushd vaultwarden-$vaultwardenVersion
cargo clean
cargo build --features sqlite --release
pushd target/release

# download an install webvault
cd /opt/vaultwarden/vaultwarden-$vaultwardenVersion/target/release
wget https://github.com/dani-garcia/bw_web_builds/releases/download/v$bwWebVersion/bw_web_v$bwWebVersion.tar.gz
tar xf bw_web_v$bwWebVersion.tar.gz
rm bw_web_v$bwWebVersion.tar.gz

# create systemd service file
$cat <<'EOF' > /etc/systemd/system/vaultwarden.service
[Unit]
Description=Bitwarden Server (vaultwarden)
Documentation=https://github.com/dani-garcia/vaultwarden
After=network.target
[Service]
User=vaultwarden
Group=vaultwarden
EnvironmentFile=/etc/vaultwarden.env
ExecStart=/opt/vaultwarden/vaultwarden-VERSION/target/release/vaultwarden
WorkingDirectory=/var/lib/vaultwarden
ReadWriteDirectories=/var/lib/vaultwarden
AmbientCapabilities=CAP_NET_BIND_SERVICE
[Install]
WantedBy=multi-user.target
EOF
$sed -i 's/VERSION/'$vaultwardenVersion'/g' /etc/systemd/system/vaultwarden.service

# create vaultwarden env file
$cat <<'EOF' > /etc/vaultwarden.env
WEB_VAULT_FOLDER=/opt/vaultwarden/vaultwarden-VERSION/target/release/web-vault
WEB_VAULT_ENABLED=true
SIGNUPS_ALLOWED=false
EOF
$sed -i 's/VERSION/'$vaultwardenVersion'/g' /etc/vaultwarden.env

# set owner rights
$chown -R vaultwarden:vaultwarden /opt/vaultwarden
$chown -R vaultwarden:vaultwarden /var/lib/vaultwarden
$chown vaultwarden:vaultwarden /etc/vaultwarden.env
$chown vaultwarden:vaultwarden /etc/systemd/system/vaultwarden.service

# enable vaultwarden.service
systemctl enable vaultwarden.service

# reload systemd daemon
systemctl daemon-reload

# TODO
# cp Backup to /var/lib/vaultwarden/data
# msg reboot container

# EOF