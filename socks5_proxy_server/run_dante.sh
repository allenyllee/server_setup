#!/bin/bash

docker run \
    -d \
    -p 1080:1080 \
    --name dante \
    --restart=always \
    wernight/dante

