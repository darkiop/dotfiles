#!/bin/bash

ping -c 1 10.4.1.37 &> /dev/null && echo "Ping OK - VM 307" || /usr/sbin/qm stop 307 && /usr/sbin/qm start 307 && echo "No response: Restarting VM 307"