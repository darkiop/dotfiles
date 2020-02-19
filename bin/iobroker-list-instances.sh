#!/bin/bash

# load colors
blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"
close_color="$(tput sgr0)"

# iobroker process-check
echo
echo -e $light_blue_color"ioBroker instances:"$green_color

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
  state="$green_color[Running]$close_color"
else
  state="$red_color[Stopped]$close_color"
fi
echo -e "$state ${process[$i]}"
done

# EOF