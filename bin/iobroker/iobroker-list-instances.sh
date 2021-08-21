#!/bin/bash

# load colors
COLOR_BLUE="\e[38;5;33m"
COLOR_LIGHT_BLUE="\e[38;5;39m"
COLOR_RED="\e[38;5;196m"
COLOR_GREEN="\e[38;5;42m"
COLOR_GREEN_BOLD="\e[1;38;5;42m"
COLOR_YELLOW="\e[38;5;227m"
COLOR_CLOSE="$(tput sgr0)"

# iobroker process-check
echo
echo -e $COLOR_LIGHT_BLUE"ioBroker instances:"$COLOR_GREEN

# grep ^+                          = select only instances with +
# cut -f1 -d":"                    = remove all after ':'
# head -n -2                       = remove last 2 lines
# sed "s/system.adapter./io./g"    = search/replace system.adapter. with io. (for pidof)
# cut -c 2-                        = remove leading +
# sed -e 's/^[ \t]*//'             = remove leading blank

process=(
$(iobroker list instances | cut -f1 -d":" | head -n -2 | sed "s/system.adapter./io./g" | cut -c 2- | sed -e 's/^[ \t]*//')
)
services=${#process[@]}

echo
for (( i=0; i<${services}; i++)); do
if [ "$(pidof ${process[$i]})" ]; then
  state="$COLOR_GREEN[Running]$COLOR_CLOSE"
else
  state="$COLOR_RED[Stopped]$COLOR_CLOSE"
fi
echo -e "$state ${process[$i]}"
done

# EOF
