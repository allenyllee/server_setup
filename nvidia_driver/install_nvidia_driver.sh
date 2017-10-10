#!/bin/bash

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y nvidia-387
