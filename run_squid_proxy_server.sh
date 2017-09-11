#!/bin/bash

MOUNTPOINT=/mnt/docker-srv/squid/cache

docker run -d \
  --name squid \
  --restart=always \
  --publish 3128:3128 \
  --volume $MOUNTPOINT:/var/spool/squid3 \
  sameersbn/squid:latest
