#!/bin/bash

# size of /volume1
volume1_usage=$(df -h /volume1 | awk '/\// {print $(NF-1)}' | sed 's/%//g')
volume1_usage_gb=$(df -h /volume1 | awk '/\// {print $(NF-3)}')
volume1_total=$(df -h /volume1 | awk '/\// {print $(NF-4)}')

echo -e "$blue_color"usage of /volume1"$close_color `echo -e "$green_color$volume1_usage_gb$close_color"` "of" `echo -e "$green_color$volume1_total$close_color"` ($volume1_usage%)"

echo

#EOF