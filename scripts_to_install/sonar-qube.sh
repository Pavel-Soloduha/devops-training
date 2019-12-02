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
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

docker run -d --name sonarqube \
  -p 80:9000 \
  --restart always \
  -v sonarqube_conf:/opt/sonarqube/conf \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_data:/opt/sonarqube/data \
  sonarqube
reboot

