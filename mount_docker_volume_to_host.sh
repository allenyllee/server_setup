#!/bin/bash
USER=$(whoami)
VOLUME_NAME=$1

sudo mkdir -p /mnt/docker_volume/$VOLUME_NAME
sudo bindfs --map=root/$USER /var/lib/docker/volumes/$VOLUME_NAME/_data /mnt/docker_volume/$VOLUME_NAME
