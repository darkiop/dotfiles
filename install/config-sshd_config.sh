#!/bin/bash
# setup sshd_cnfig
#
# argument 1 = user
# argument 2 = port
#
# sshd_config adjustments:
#  PermitRootLogin no
#  PermitEmptyPasswords no
#  StrictModes yes
#  PubkeyAuthentication yes

# check if root
if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this as root." >&2;
  exit 1
fi

# check arguments
if [ $# -lt 2 ]; then
  echo "2 arguments required: $0 user sshport"
  exit 1
else
 
  # check if user is valid
  re='^[0-9]+$'
  if [[ $1 =~ $re ]] ; then
    echo "Not a valid user." >&2;
    exit 1
  fi

  # check if user exist
  if id "$1" &>/dev/null; then
    SSHUSER=$1
    # check if a public key is set
    if [ ! -f "/home/$SSHUSER/.ssh/authorized_keys" ]; then
      echo "~/.ssh/authorized_keys not found." >&2;
      exit 1
    fi
  else
    echo "User not found. Before disabling root login, please create a personal user and setup public key in ~/.ssh/authorized_keys" >&2;
    exit 1
  fi

  # check port range
  if [ $2 -ge 1024 ] && [ $2 -le 65535 ] || [ $2 == 22 ]; then
    SSHPORT=$2
  else
    echo "Port not in specified range: 22 or 1024 - 65535" >&2;
    exit 1
  fi

  if [ $SSHUSER ] && [ $SSHPORT ]; then
    sed -i "s/^Port .*/Port $SSHPORT/g" /etc/ssh/sshd_config
    sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
    sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/g" /etc/ssh/sshd_config
    sed -i "s/#StrictModes yes/StrictModes yes/g" /etc/ssh/sshd_config
    sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
    if [ -f /etc/ssh/sshd_config.d/my.conf ]; then
      rm /etc/ssh/sshd_config.d/my.conf
    fi
    echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config.d/my.conf
    echo "AllowUsers $SSHUSER" >> /etc/ssh/sshd_config.d/my.conf
    
    echo "If the port has been adjusted, it must also be adjusted in the firewall configuration!"
    
    service ssh restart
  else
    echo "SSHUSER and SSHPORT are not set." >&2;
    exit 1
  fi

  # update fail2ban ssh port
  if [ -f /etc/fail2ban/jail.local ]; then
    sed -i "/^\[sshd\]$/,/^\[/s/port[[:blank:]]*=.*/port = $SSHPORT/" /etc/fail2ban/jail.local
    service fail2ban restart
  fi

fi

# EOF