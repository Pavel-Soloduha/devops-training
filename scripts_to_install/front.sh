#!/bin/bash

apt update

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs

git clone https://github.com/Pavel-Soloduha/devops-training-frontend

cd devops-training-frontend
npm install