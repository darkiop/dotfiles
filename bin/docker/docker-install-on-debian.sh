#!/bin/bash
#
# Install docker on debian
#
# https://docs.docker.com/install/linux/docker-ce/debian/

apt-get update

apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

# x86_64 / amd64
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io -y
