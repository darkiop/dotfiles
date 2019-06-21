#!/bin/bash
# Docker Start Skript: iobroker-grafana

chown 104:104 /volume1/docker/iobroker-grafana

docker run -it -d --name=iobroker-grafana --hostname iobroker-grafana -p 3000:3000 --restart no --user 104 -v /volume1/docker/iobroker-grafana:/var/lib/grafana grafana/grafana
