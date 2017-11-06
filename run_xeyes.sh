#!/bin/bash

#
# x11 - Can you run GUI apps in a docker container? - Stack Overflow 
# https://stackoverflow.com/a/25280523/1851492
# 
docker build -t xeyes - << EOF
FROM debian
RUN apt-get update
RUN apt-get install -qqy x11-apps
ENV DISPLAY :0
CMD xeyes
EOF


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
docker run -ti -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH xeyes

