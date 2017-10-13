#!/bin/bash

########################
# install docker
# from: Get Docker CE for Ubuntu | Docker Documentation 
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#recommended-extra-packages-for-trusty-1404
########################

# Update the apt package index:
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Use the following command to set up the stable repository. 
# amd64
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker CE
sudo apt-get update
sudo apt-get install docker-ce

# Verify that Docker CE is installed correctly by running the hello-world image.
sudo docker run hello-world

######################
# enable docker api for jenkins CI use
# Enabling Docker Remote API on Ubuntu 16.04 – The Blog of Ivan Krizsan 
# https://www.ivankrizsan.se/2016/05/18/enabling-docker-remote-api-on-ubuntu-16-04/
# test: curl http://localhost:4243/version
# test2: curl -X GET http://192.168.5.5:4243/images/json
######################
sudo sed -i '/ExecStart=\/usr\/bin\/docker*/ c\ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ -H tcp:\/\/0.0.0.0:4243' /lib/systemd/system/docker.service
systemctl daemon-reload
sudo service docker restart


######################
# install Nvidia driver
# How do I install the Nvidia drivers? - Ask Ubuntu 
# https://askubuntu.com/questions/61396/how-do-i-install-the-nvidia-drivers
######################

#
# add ppa repository
#
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get upgrade -y

#
# purge all previous version
#
sudo apt-get remove -y nvidia-*

#
# install latest version
#
sudo apt-get install -y nvidia-387

######################
# install nvidia docker
# NVIDIA/nvidia-docker: Build and run Docker containers leveraging NVIDIA GPUs 
# https://github.com/NVIDIA/nvidia-docker
######################

# install nvidia-modprobe
sudo apt-get install -y nvidia-modprobe

# Install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# Test nvidia-smi
nvidia-docker run --rm nvidia/cuda nvidia-smi


######################
# install VSCode
######################
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders

##################################3

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y psensor

sudo apt-get install -y gparted

sudo apt-get install -y system-config-lvm

sudo apt-get install -y vim

#
# disk space analyzer
#
sudo apt-get install -y Baobab

#
# Alternative to CrystalDiskInfo
#
sudo apt-get install -y gsmartcontrol

#
# install redshift
#
sudo apt-get install -y redshift-gtk

#
# copy redshift config to ~/.config/redshift.conf
#
cp ./redshift.conf ~/.config/

#
# install ssh server
# will generate /etc/ssh/sshd_config
#
sudo apt-get install -y openssh-server

#
# install CopyQ
#
sudo add-apt-repository ppa:hluk/copyq
sudo apt update
sudo apt install copyq


