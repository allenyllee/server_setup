#!/bin/bash
function mount_docker_volume {
    USER=$1
    VOLUME_NAME=$2
    TARGETDIR=$3

    sudo mkdir -p $TARGETDIR/$VOLUME_NAME
    sudo bindfs --map=root/$USER /var/lib/docker/volumes/$VOLUME_NAME/_data $TARGETDIR/$VOLUME_NAME
}

mount_docker_volume allencat project /mnt/docker_volume
mount_docker_volume allencat jenkins_home /mnt/docker_volume

