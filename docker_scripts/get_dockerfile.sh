#!/bin/bash

#
# Get dockerfile from image
#
# usage:
#       ./get_dockerfile.sh [username] [password] [image] [tag] [option] [registry]
# option:
#       digest, imageid, tags
#
# registry:
#       registry-1.docker.io, index.docker.io
#
# before use this script, you need to install jq
# in ubuntu:
#       sudo apt-get install jq
# 
# also you need to download another script in the same folder: 
#       get_digest.sh

USERNAME=$1         # user name
PASSWORD=$2         # pasword
REPOSITORY=$3       # repositry name
TAG=$4              # specify image tag
OPTION=$5           # digest, imageid, tags
REGISTRY=$6         # which registry

DIGEST=$(./get_digest.sh $USERNAME $PASSWORD $REPOSITORY $TAG $OPTION $REGISTRY)

#
# bash - How to run an alias in a shell script? - Ask Ubuntu
# https://askubuntu.com/questions/98782/how-to-run-an-alias-in-a-shell-script
#
# chenzj/dfimage - Docker Hub
# https://hub.docker.com/r/chenzj/dfimage/
#
# repository - How to generate a Dockerfile from an image? - Stack Overflow
# https://stackoverflow.com/questions/19104847/how-to-generate-a-dockerfile-from-an-image
# centurylink/dockerfile-from-image doesn't work with new version docker. This one works for me: hub.docker.com/r/chenzj/dfimage
#
dfimage() {
    docker run -v /var/run/docker.sock:/var/run/docker.sock --rm chenzj/dfimage "$@"
}

echo "$DIGEST"
dfimage $DIGEST
