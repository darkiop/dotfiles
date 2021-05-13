#!/bin/bash
#
# vaultwarden install script

vaultwardenUser=vaultwarden
vaultwardenVersion="1.21.0"
bwWebVersion="2.19.0d"

# first check if root, when not define a alias with sudo
if [ "${EUID}" -ne 0 ]; then
  apt='sudo '$(which apt)
else
  apt=$(which apt)
fi

# colors - https://bashcolors.com
blue_color="\e[38;5;39m"
light_blue_color="\e[38;5;81m"
red_color="\e[38;5;196m"
green_color_bold="\e[1;38;5;119m"
yellow_color="\e[38;5;227m"
white_color="\e[37m"
close_color="$(tput sgr0)"

# ask function
function ask() {
  local color="$1"
  case $color in
    green)
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$red_color
    ;;
  esac
  while true; do
    echo -e "$color"
    read -p "$2 ([y]/n) " -r
    echo -e "$close_color"
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
    color=$green_color
    ;;
    blue)
    color=$blue_color
    ;;
    lightblue)
    color=$light_blue_color
    ;;
    yellow)
    color=$yellow_color
    ;;
    red)
    color=$red_color
    ;;
  esac
  echo -e "$color"
  echo "$2"
  echo -e "$close_color"
}

# check if vaultwarden is installed
if [ -d /opt/vaultwarden/vaultvarden-$vaultwardenVersion ]; then
  # TODO: check if installed and ask
  ask yellow "vaultwarden installion found, delete and reinstall?"
  case $REPLY in
    y|Y)
      message yellow "Delete old files ..."
      rm -r /opt/vaultwarden/vaultvarden-$vaultwardenVersion
      rm -r /etc/systemd/system/vaultwarden.service
      rm -r /etc/vaultwarden.env
    ;;
    n|N|*)
      message yellow "Do nothing and exit."
      exit
    ;;
  esac
fi

# install dependencys
apt update
apt install -y git wget curl nodejs npm build-essential pkg-config

# create system user for vaultwarden
if [ ! `id -u $vaultwardenUser 2>/dev/null || echo -1` -ge 0 ]; then 
  adduser --system --no-create-home --group vaultwarden
fi

# vaultvarden main directory
if [ ! -d /opt/vaultwarden ]; then
  mkdir /opt/vaultwarden
fi

# vaultvarden lib directory
if [ ! -d /var/lib/vaultwarden ]; then
  mkdir /var/lib/vaultwarden
fi

# vaultvarden data directory
if [ ! -d /var/lib/vaultwarden/data ]; then
  mkdir /var/lib/vaultwarden/data
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
cd /opt/vaultwarden/vaultwarden-$vaultwardenVersion
wget https://github.com/dani-garcia/bw_web_builds/releases/download/v$bwWebVersion/bw_web_v$bwWebVersion.tar.gz
tar xf bw_web_v$bwWebVersion.tar.gz
rm bw_web_v$bwWebVersion.tar.gz

# create systemd service file
cat <<'EOF' > /etc/systemd/system/vaultwarden.service
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
sed -i 's/VERSION/'$vaultwardenVersion'/g' /etc/systemd/system/vaultwarden.service

# create vaultwarden env file
cat <<'EOF' > /etc/vaultwarden.env
WEB_VAULT_FOLDER=/opt/vaultwarden/vaultwarden-VERSION/target/release/web-vault
WEB_VAULT_ENABLED=true
SIGNUPS_ALLOWED=false
EOF
sed -i 's/VERSION/'$vaultwardenVersion'/g' /etc/vaultwarden.env

# set owner rights
chown -R vaultwarden:vaultwarden /opt/vaultwarden
chown -R vaultwarden:vaultwarden /var/lib/vaultwarden
chown vaultwarden:vaultwarden /etc/vaultwarden.env
chown vaultwarden:vaultwarden /etc/systemd/system/vaultwarden.service

# EOF