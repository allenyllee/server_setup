#!/bin/bash

# shell - Process all arguments except the first one (in a bash script) - Stack Overflow
# https://stackoverflow.com/questions/9057387/process-all-arguments-except-the-first-one-in-a-bash-script

# docker run $1 ${@:2}

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

PORT=8081

docker run -ti --rm \
    --name motion \
    --publish $PORT:8081 \
    --env DISPLAY=$DISPLAY \
    --env XAUTHORITY=$XAUTH \
    --volume $XSOCK:$XSOCK \
    --volume $XAUTH_DIR:$XAUTH_DIR \
    --volume $PWD/scripts:/scripts2 \
    --device /dev/video0:/dev/video0 `# for webcam` \
    --device /dev/video1:/dev/video1 `# for webcam` \
    allenyllee/motion-webcam-server