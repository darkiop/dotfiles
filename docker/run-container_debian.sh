#!/bin/bash
# Docker Start Skript: debian mit connect zu Docker auf odin

docker run -it -d --name debian --hostname debian -v /var/run/docker.sock:/var/run/docker.sock darkiop/debian:latest
