#!/bin/bash

#
# x11 - Can you run GUI apps in a docker container? - Stack Overflow 
# https://stackoverflow.com/a/25280523/1851492
# 
docker build -t xeyes - << __EOF__
FROM debian
RUN apt-get update
RUN apt-get install -qqy x11-apps
CMD xeyes
__EOF__

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
docker run -ti -v $XSOCK:$XSOCK -v $XAUTH_DIR:$XAUTH_DIR -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH xeyes

