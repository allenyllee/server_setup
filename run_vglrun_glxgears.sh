#!/bin/bash

#
# plumbee/nvidia-virtualgl: Base docker image to be ran with nvidia-docker 
# https://github.com/plumbee/nvidia-virtualgl
#

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

#xhost +local:root
nvidia-docker run -ti --rm \
    --env="DISPLAY=${DISPLAY}" \
    --env="XAUTHORITY=${XAUTH}" \
    --volume=${XSOCK}:${XSOCK} \
    --volume=${XAUTH}:${XAUTH} \
    --volume="/usr/lib/x86_64-linux-gnu/libXv.so.1:/usr/lib/x86_64-linux-gnu/libXv.so.1" \
    plumbee/nvidia-virtualgl:2.5.2 vglrun glxgears
#xhost -local:root # resetting permissions