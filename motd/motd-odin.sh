#!/bin/bash

# size of /volume1
if [[ -d /volume1 ]]; then
	volume1_usage=$(df -h /volume1 | awk '/\// {print $(NF-1)}' | sed 's/%//g')
	volume1_usage_gb=$(df -h /volume1 | awk '/\// {print $(NF-3)}')
	volume1_total=$(df -h /volume1 | awk '/\// {print $(NF-4)}')

	echo -e "  ${COLOR_BLUE}/volume1${COLOR_CLOSE} ${COLOR_GREEN}${volume1_usage_gb}${COLOR_CLOSE} of ${COLOR_GREEN}${volume1_total}${COLOR_CLOSE} (${volume1_usage}%)"
fi

echo

#EOF