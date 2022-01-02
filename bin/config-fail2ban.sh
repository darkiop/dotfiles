#!/bin/bash

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root." >&2;
  exit 1
fi

if [ -f /etc/fail2ban/jail.conf ]; then
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  sed -i 's/^bantime[[:blank:]]*= 10m/bantime = 24h/g' /etc/fail2ban/jail.local
  sed -i 's/^findtime[[:blank:]]*= 10m/findtime = 1h/g' /etc/fail2ban/jail.local
  sed -i 's/^maxretry[[:blank:]]*= 5/maxretry = 3/g' /etc/fail2ban/jail.local
  service fail2ban restart
fi

# EOF