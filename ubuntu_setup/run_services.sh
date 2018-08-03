#!/bin/bash

PROJECT_DIR=$1
PROJECT_DIR_SSD=$2
DOCKERDIR="$PROJECT_DIR/docker-srv"
DOCKERDIR_SSD="$PROJECT_DIR_SSD/docker-srv"
export DOCKERBIN="$(which docker)"

sudo mkdir -p $DOCKERDIR_SSD
sudo chmod 777 $DOCKERDIR_SSD

#
# gitlab data
#
export GITLAB_DIR=$DOCKERDIR/gitlab

#
# jenkins data
#
# security - How to give non-root user in Docker container access to a volume mounted on the host - Stack Overflow
# https://stackoverflow.com/questions/39397548/how-to-give-non-root-user-in-docker-container-access-to-a-volume-mounted-on-the
export JENKINS_DIR=$DOCKERDIR_SSD/jenkins_home
mkdir -p $JENKINS_DIR
chown -R 1000:1000 $JENKINS_DIR

#
# docker registry data
#
export REGISTRY_DIR=$DOCKERDIR/registry
export REG_BACKENDPORT=5000

#
# squid proxy data
#
export SQUID_DIR=$DOCKERDIR_SSD/squid/cache

#
# samba server shared folder
#
export SAMBA_DIR_SSD=$DOCKERDIR_SSD/samba
export SAMBA_DIR=$DOCKERDIR/samba


#
# xtensa source
#
# linux - Forcing bash to expand variables in a string loaded from a file - Stack Overflow
# https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file
#
export XTENSA_GIT=$(eval echo $PROJECT_DIR)/xtensa_X_docker

# folder to share with samba
export XTENSA_DIR=$SAMBA_DIR/xtensa_dir

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

# for nvidia-docker 1.0(deprecated)
# starting nvidia docker containers in the background and leaves them running
#bash -c "cd ../nvidia_docker;nvidia-docker-compose build;nvidia-docker-compose up -d"

# nvidia-docker2
bash -c "cd ../nvidia_docker;docker-compose build;docker-compose up -d"
