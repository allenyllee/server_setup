#!/bin/bash

PROJECT_DIR=$1
DOCKERDIR="/mnt/docker-srv"
export DOCKERBIN="$(which docker)"

sudo mkdir -p $DOCKERDIR
sudo chmod 777 $DOCKERDIR

#
# gitlab data
#
GITLAB_DIR=$DOCKERDIR/gitlab
export GITLAB_DIR

#
# jenkins data
#
# security - How to give non-root user in Docker container access to a volume mounted on the host - Stack Overflow
# https://stackoverflow.com/questions/39397548/how-to-give-non-root-user-in-docker-container-access-to-a-volume-mounted-on-the
export JENKINS_DIR=$DOCKERDIR/jenkins_home
mkdir -p $JENKINS_DIR
chown -R 1000:1000 $JENKINS_DIR

#
# docker registry data
#
REGISTRY_DIR=$DOCKERDIR/registry
export REGISTRY_DIR

REG_BACKENDPORT=5000
export REG_BACKENDPORT

#
# squid proxy data
#
SQUID_DIR=$DOCKERDIR/squid/cache
export SQUID_DIR

#
# samba server shared folder
#
SAMBA_DIR=$DOCKERDIR/samba
export SAMBA_DIR

#
# xtensa source
#
# linux - Forcing bash to expand variables in a string loaded from a file - Stack Overflow
# https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file
#
XTENSA_GIT=$(eval echo $PROJECT_DIR)/xtensa_X_docker
export XTENSA_GIT

# folder to share with samba
XTENSA_DIR=$SAMBA_DIR/project
export XTENSA_DIR

###################
# docker
###################

# starting docker containers in the background and leaves them running
docker-compose up -d

###################
# nvidia docker
###################

# clone submodules
bash ../nvidia_docker/project/init_submodule.sh

# starting nvidia docker containers in the background and leaves them running
bash -c "cd ../nvidia_docker;nvidia-docker-compose build;nvidia-docker-compose up -d"

