#!/bin/bash

sudo apt-get install motion

# docker-webcam-server/motion.conf at master · johndevs/docker-webcam-server
# https://github.com/johndevs/docker-webcam-server/blob/master/conf/motion.conf
sudo cp motion.conf /etc/motion/motion.conf

sudo motion