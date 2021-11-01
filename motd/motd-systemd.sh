#!/bin/bash

CHECKSYSDSSH="$(systemctl is-active sshd.service)"
if [ "${SYSDSSH}" = "active" ]; then
  SYSDSSH=${echo -e " "$COLOR_GREEN"SSH"$COLOR_CLOSE}
else
  SYSDSSH=${echo -e " "$COLOR_RED"SSH"$COLOR_CLOSE}
fi

echo -e " "$COLOR_BLUE"Services"$COLOR_CLOSE   `echo -e $COLOR_GREEN$SYSDSSH$COLOR_CLOSE`
