#!/bin/bash

if [ -f /etc/fail2ban/jail.conf ]; then
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  sed -i 's/^bantime[[:blank:]]*= 10m/bantime = 24h/g' /etc/fail2ban/jail.local
  sed -i 's/^findtime[[:blank:]]*= 10m/findtime = 1h/g' /etc/fail2ban/jail.local
  sed -i 's/^maxretry[[:blank:]]*= 5/maxretry = 3/g' /etc/fail2ban/jail.local
  service fail2ban restart
fi

# EOF