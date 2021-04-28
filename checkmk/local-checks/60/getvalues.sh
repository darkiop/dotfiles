#!/bin/bash

#
# ioBroker getvalue
# TODO metrics
# TODO error handling (iobroker is not runnig)
#
iobGetvalue=$(iobroker state getvalue smartmeter.1.1-0:16_7_0__255.value)
if [[ $iobGetvalue -gt 400 && $iobGetvalue -lt 1000 ]]; then
  status=1
elif [ "$iobGetvalue" -ge "1000" ]; then
  status=2
else
  status=0
fi
servicename='ioBroker.GetValueTest'
metrics='-'
statusdetail=$iobGetvalue
echo "$status $servicename $metrics $statusdetail"

# EOF