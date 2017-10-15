#!/bin/bash

PROJECT_DIR=$1
DOCKERDIR="/mnt/docker-srv"

sudo mkdir -p $DOCKERDIR
sudo chmod 777 $DOCKERDIR

GITLAB_DIR=$DOCKERDIR/gitlab
export GITLAB_DIR

JENKINS_DIR=$DOCKERDIR/jenkins_home
export JENKINS_DIR

REGISTRY_DIR=$DOCKERDIR/registry
export REGISTRY_DIR

REG_BACKENDPORT=5000
export REG_BACKENDPORT

SQUID_DIR=$DOCKERDIR/squid/cache
export SQUID_DIR

SAMBA_DIR=$DOCKERDIR/samba
export SAMBA_DIR

XTENSA_GIT=$PROJECT_DIR/xtensa_X_docker
export XTENSA_GIT

XTENSA_DIR=$SAMBA_DIR/project
export XTENSA_DIR



# starts the containers in the background and leaves them running
docker-compose up -d
