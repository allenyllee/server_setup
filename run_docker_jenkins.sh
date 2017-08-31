#!/bin/bash

docker run -d \
           -p 8081:8080 \
           -p 50000:50000 \
           -v jenkins_home:/var/jenkins_home \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(which docker):/usr/bin/docker \
           -v /usr/lib/x86_64-linux-gnu/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
           --name jenkins \
           --restart=always \
           jenkins/jenkins:lts
