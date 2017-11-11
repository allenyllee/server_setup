#!/bin/bash

docker build -t glxgears - << EOF
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y mesa-utils
CMD export LIBGL_DEBUG=verbose && glxgears
EOF

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

nvidia-docker run -ti --rm \
    --volume=$XSOCK:$XSOCK \
    --volume=$XAUTH_DIR:$XAUTH_DIR \
    --env="DISPLAY=$DISPLAY" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="/usr/lib/x86_64-linux-gnu/libXv.so.1:/usr/lib/x86_64-linux-gnu/libXv.so.1" \
    glxgears