#!/bin/bash

xhost local:root

#nvidia-docker-compose build
nvidia-docker-compose up -d tensorflow
