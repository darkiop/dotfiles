#!/bin/bash
# Docker Start Skript: iobroker-grafana

docker run -d --name=iobroker-grafana -p 3000:3000 --restart no --user 104 -v /volume1/docker/iobroker-grafana:/var/lib/grafana grafana/grafana
