#!/bin/bash
# /etc/systemd/system/getty.target.wants/restart-usbip-client-iobroker.service
#
# [Unit]
# After=systemd-user-sessions.service
# After=rc-local.service
# Before=getty.target
# IgnoreOnIsolate=yes
#
# [Service]
# ExecStart=/root/dotfiles/bin/iobroker/restart-usbip-client.sh
# ExecStop=
# Type=oneshot
# RemainAfterExit=true
#
# [Install]
# WantedBy=basic.target

ssh darkiop@pve-vm-iobroker bash -c "'sudo service usbip-client restart'"