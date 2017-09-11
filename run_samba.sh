#!/bin/bash

MOUNTPOINT=/mnt/docker-srv/samba

docker run \
  -d \
  -it \
  --name samba \
  -p 139:139 -p 445:445 \
  -e USERID=0 \
  -e GROUPID=0 \
  -v $MOUNTPOINT:/data \
  --restart always\
  dperson/samba \
  -S \
  -s "project;/data;yes;no"
