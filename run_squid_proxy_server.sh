#!/bin/bash

docker run -d \
  --name squid \
  --restart=always \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid3 \
  sameersbn/squid:latest
