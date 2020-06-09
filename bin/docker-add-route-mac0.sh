#!/bin/sh
if ip link | grep "mac0@ens18" > /dev/null; then
  echo "Device mac0 existiert"
else
  echo "Device mac0 anlegen"
  ip link del mac0
  ip link add mac0 link ens18 type macvlan mode bridge
  ip addr add 192.168.1.80/32 dev mac0
  ip link set mac0 up
  ip route add 192.168.1.80/28 dev mac0
fi
