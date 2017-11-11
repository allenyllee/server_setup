#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run -it --rm \
    --privileged \
    --cap-add=SYS_ADMIN \
    --env="USER_UID=$(id -u $USER)" \
    --env="USER_GID=$(id -g $USER)" \
    --env="DISPLAY=${DISPLAY}" \
    --env="XAUTHORITY=${XAUTH}" \
    --device=/dev/dri/card0 \
    --device=/dev/nvidia0 \
    --device=/dev/nvidiactl \
    --volume=${XSOCK}:${XSOCK} \
    --volume=${XAUTH_DIR}:${XAUTH_DIR} \
    --volume=/run/user/$(id -u $USER)/pulse:/run/pulse \
    sameersbn/browser-box:latest bash



