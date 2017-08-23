#!/bin/bash

docker run \
  --detach \
  -e ENV_DOCKER_REGISTRY_HOST=172.17.0.5 \
  -e ENV_DOCKER_REGISTRY_PORT=5000 \
  -p 8080:80 \
  --name registry-ui \
  --restart always \
  konradkleine/docker-registry-frontend:v2
