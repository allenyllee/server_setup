#!/usr/bin/env bash

SERVICE=$1

source ./setup_services.sh ~/Projects ~/Projects_SSD


###################
# docker
###################

# bash - unary operator expected - Stack Overflow
# https://stackoverflow.com/questions/13617843/unary-operator-expected
if [ "$SERVICE" == "update" ]
then
  # update image
  # How to update existing images with docker-compose? - Stack Overflow
  # https://stackoverflow.com/questions/49316462/how-to-update-existing-images-with-docker-compose
  # 
  # build process - how to get docker-compose to use the latest image from repository - Stack Overflow
  # https://stackoverflow.com/questions/37685581/how-to-get-docker-compose-to-use-the-latest-image-from-repository
  echo "update image"
  docker-compose stop
  docker-compose rm -f
  docker-compose pull
  docker-compose up -d
  docker image prune -f
else
  echo "run services"
  # starting docker containers in the background and leaves them running
  docker-compose up -d $SERVICE
fi



#docker logs Dropbox

###################
# nvidia docker
###################

# clone submodules
#bash ../nvidia_docker/project/init_submodule.sh

# for nvidia-docker 1.0(deprecated)
# starting nvidia docker containers in the background and leaves them running
#bash -c "cd ../nvidia_docker;nvidia-docker-compose build;nvidia-docker-compose up -d"

# nvidia-docker2
#bash -c "cd ../nvidia_docker;docker-compose build;docker-compose up -d"
