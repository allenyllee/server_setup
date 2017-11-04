#!/bin/bash

#
# What´s the sha256 code of a docker image? - Stack Overflow
# https://stackoverflow.com/questions/32046334/what%C2%B4s-the-sha256-code-of-a-docker-image
#

#
# Get digest & imageId
# you should have downloaded the image in local
#
# usage: 
#   ./get_local_digest.sh [image]
# ex:
#   ./get_local_digest.sh continuumio/anaconda3
#
IMAGE=$1

# get all informations
#docker inspect $IMAGE

# get second Env of ContainerConfig
#docker inspect --format='{{index .ContainerConfig.Env 2}}' $IMAGE

# get imageId
echo "imageId(docker inspect):"
docker inspect --format='{{.Id}}' $IMAGE
echo

# get digest without brace (returns first index of array)
echo "digest(docker inspect):"
docker inspect --format='{{index .RepoDigests 0}}' $IMAGE | cut -d '@' -f2
echo

# get digest & imageId(docker images)
echo "digest & imageId(docker imaes):"
docker images --digests | grep $IMAGE | grep latest
echo

