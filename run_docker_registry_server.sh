#!/bin/bash

docker run -d \
    -p 5000:5000 \
    --restart=always \
    --name registry \
    -v /mnt/docker_registry:/var/lib/registry \
    registry:2
