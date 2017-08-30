#!/bin/bash

docker run -d \
           -p 8081:8080 \
           -p 50000:50000 \
           -v jenkins_home:/var/jenkins_home \
           --name jenkins \
           --restart=always \
           jenkins/jenkins:lts
