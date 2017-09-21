#!/bin/bash

##
## NVIDIA/nvidia-docker: Build and run Docker containers leveraging NVIDIA GPUs
## https://github.com/NVIDIA/nvidia-docker
##




# Test nvidia-smi
nvidia-docker run \
  -ti \
  -v $(pwd)/project:/root/project \
  --name cuda8.0 \
  nvidia/cuda bash
