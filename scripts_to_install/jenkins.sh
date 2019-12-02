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
docker run \
  -u root \
  -d \
  -p 80:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name blueocean \
  --restart always \
  jenkinsci/blueocean
reboot

