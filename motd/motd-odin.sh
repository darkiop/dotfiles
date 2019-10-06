#!/bin/bash

blue_color="\e[38;5;33m"
light_blue_color="\e[38;5;39m"
red_color="\e[38;5;196m"
green_color="\e[38;5;42m"
green_color_bold="\e[1;38;5;42m"
yellow_color="\e[38;5;227m"

echo
echo -e $light_blue_color"running docker containers:"$green_color
echo
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}' | sed -n '1!p' | sort
echo

#EOF