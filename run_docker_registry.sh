#!/bin/bash

NETWORK=reg_net
BACKEND=reg-server
BACKENDPORT=5000
FRONTEND=reg-ui
FRONTENDPORT=8080
MOUNTPOINT=/mnt/docker-srv/registry

#
# create a network bridge between containers
#
docker network create \
  --driver=bridge \
  $NETWORK

#
# run a docker registry backend container and link it to network bridge above
#
docker run \
  --detach \
  -p $BACKENDPORT:5000 \
  --restart=always \
  --name=$BACKEND \
  --network=$NETWORK \
  -v $MOUNTPOINT:/var/lib/registry \
  registry:2

#
# run a docker registry frontend container and link it to network bridge above
#
docker run \
  --detach \
  -e ENV_DOCKER_REGISTRY_HOST=$BACKEND \
  -e ENV_DOCKER_REGISTRY_PORT=$BACKENDPORT \
  -p $FRONTENDPORT:80 \
  --network=$NETWORK \
  --name=$FRONTEND \
  --restart=always \
  konradkleine/docker-registry-frontend:v2



