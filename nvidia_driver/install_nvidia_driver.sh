#!/bin/bash

#
# add ppa repository
#
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get -y upgrade

#
# purge all previous version
#
sudo apt-get -y remove nvidia-*

#
# install latest version
#
sudo apt-get -y install nvidia-387
