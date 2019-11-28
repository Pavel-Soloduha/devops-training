#!/bin/bash

apt update && apt install -y openjdk-8-jdk
git clone https://github.com/Pavel-Soloduha/devops-training-backend
cd devops-training-backend
export DB_URL=nlb-private-solodukha-8659a48e2874cdf4.elb.us-east-1.amazonaws.com
export DB_PORT=3306
export DB_NAME=conduit
export DB_USERNAME=root
export DB_PASSWORD=root
#./gradlew compileJava
./gradlew bootRun