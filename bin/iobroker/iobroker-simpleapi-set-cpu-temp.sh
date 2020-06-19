#!/bin/bash
# Source: https://forum.iobroker.net/topic/23602/gel%C3%B6st-cpu-temperatur-von-proxmox-vm/63

hostname=$(hostname)
core0Dp=javascript.0.System.${hostname}.CPUTemp0
core1Dp=javascript.0.System.${hostname}.CPUTemp1
core2Dp=javascript.0.System.${hostname}.CPUTemp2
core3Dp=javascript.0.System.${hostname}.CPUTemp3

IPP=XXX.XXX.XXX.XXX:XXXX
user=
pw=

for((c=1; c<=6; c++))
do
        core0=$(sensors | grep 'Core 0:' | awk '{print $3}' | cut -c2-3)
        core1=$(sensors | grep 'Core 1:' | awk '{print $3}' | cut -c2-3)
        curl --insecure -G https://${IPP}/set/${core0Dp} --data-urlencode user=${user} --data-urlencode pass=${pw} --data-urlencode value=${core0} --data-urlencode "ack=true"
        curl --insecure -G https://${IPP}/set/${core1Dp} --data-urlencode user=${user} --data-urlencode pass=${pw} --data-urlencode value=${core1} --data-urlencode "ack=true"
        sleep 10
done
