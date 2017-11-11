#!/bin/bash

# how can you set up a docker container that acces web cams - Google 網上論壇
# https://groups.google.com/forum/#!msg/docker-user/3o7ASnyeULA/b7rKHTITEQAJ
# 
# This is an example from a shell script we use to run X11 NVIDIA accellerated docker images:
# 
# sameersbn/docker-browser-box: Dockerized google-chome and tor-browser with audio support via pulseaudio 
# https://github.com/sameersbn/docker-browser-box#getting-started
# 
# sameersbn/browser-box - Docker Hub 
# https://hub.docker.com/r/sameersbn/browser-box/

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# TODO: 
# test GPU accelerate
# 
docker run -it --rm \
    --env="USER_UID=$(id -u $USER)" \
    --env="USER_GID=$(id -g $USER)" \
    --env="DISPLAY=${DISPLAY}" \
    --env="XAUTHORITY=${XAUTH}" \
    --volume=${XSOCK}:${XSOCK} \
    --volume=${XAUTH_DIR}:${XAUTH_DIR} \
    --volume=/run/user/$(id -u $USER)/pulse:/run/pulse \
    sameersbn/browser-box:latest bash



