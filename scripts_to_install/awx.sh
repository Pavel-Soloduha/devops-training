#!/bin/bash

apt update
apt-get remove docker docker-engine docker.io
apt-get install     apt-transport-https     ca-certificates     curl     software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt update
apt-get install docker-ce -y
usermod -aG docker ubuntu


apt install python3-pip
pip3 install --upgrade pip
pip3 install ansible docker docker-compose


reboot
