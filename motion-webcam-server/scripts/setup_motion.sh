#!/bin/bash

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# sudo apt-get install motion

# docker-webcam-server/motion.conf at master · johndevs/docker-webcam-server
# https://github.com/johndevs/docker-webcam-server/blob/master/conf/motion.conf
# sudo cp motion.conf /etc/motion/motion.conf

cp $SOURCE_DIR/motion.conf /usr/local/etc/motion/