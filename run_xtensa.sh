#!/bin/bash

MOUNTPOINT=/mnt/docker-srv/samba/project

docker run \
  -d \
  -ti \
  --restart=always\
  -p 3322:22 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $MOUNTPOINT:/home/project \
  -v xtensa:/home/xtensa \
  --name xtensa_xplorer \
  xtensa/xplorer:7.0.4_1 \
  bash -c "service sshd start;bash"
