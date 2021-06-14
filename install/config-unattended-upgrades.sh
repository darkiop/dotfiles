#!/bin/bash

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root." >&2;
  exit 1
fi

# create /etc/apt/apt.conf.d/20auto-upgrades > noninteractive
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections; dpkg-reconfigure -f noninteractive unattended-upgrades

# setup /etc/apt/apt.conf.d/20auto-upgrades
if [ -f /etc/apt/apt.conf.d/20auto-upgrades ]; then
  sed -i 's/^APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "always";/g' /etc/apt/apt.conf.d/20auto-upgrades
  sed -i 's/^APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "always";/g' /etc/apt/apt.conf.d/20auto-upgrades
fi