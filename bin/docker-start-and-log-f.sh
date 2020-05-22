#!/bin/bash
# starts containers and show log

sudo docker start $1
sudo docker logs -f $1

#EOF
