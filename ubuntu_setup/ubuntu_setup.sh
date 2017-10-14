#!/bin/bash

#/*
# * @Author: Allen_Lee 
# * @Date: 2017-10-15 00:27:41 
# * @Last Modified by:   Allen_Lee 
# * @Last Modified time: 2017-10-15 00:27:41 
# */

########################
# install docker
# from: Get Docker CE for Ubuntu | Docker Documentation 
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#recommended-extra-packages-for-trusty-1404
########################

# Update the apt package index:
sudo apt-get update
sudo apt-get upgrade -y

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y \
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
sudo apt-get install -y docker-ce

# Verify that Docker CE is installed correctly by running the hello-world image.
sudo docker run hello-world

#############################
# running docker without sudo by adding user into docker group
# How can I use docker without sudo? - Ask Ubuntu
# https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
#############################

# add docker group & add current ser into it
sudo groupadd docker
sudo gpasswd -a $USER docker

# activate the changes to groups
newgrp docker
docker run hello-world

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

# add ppa repository
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get upgrade -y

# purge all previous version
sudo apt-get remove -y nvidia-*

# install latest version
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

#######################
# install nvidia-docker-compose
#######################
sudo apt-get install -y python-pip
pip install nvidia-docker-compose



######################
# install VSCode
######################
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders

##################################3


#
# graphical front-end to su and sudo
#
sudo apt-get install -y gksu

#
# display graphs for monitoring hardware temperature
#
sudo apt-get install -y psensor

#
# GNOME partition editor
#
sudo apt-get install -y gparted

#
# utility for graphically configuring Logical Volumes
#
sudo apt-get install -y system-config-lvm


#
# Vi IMproved - enhanced vi editor
#
sudo apt-get install -y vim

#
# disk space analyzer
#
sudo apt-get install -y Baobab

#
# Alternative to CrystalDiskInfo
#
sudo apt-get install -y gsmartcontrol

#########################
# install redshift
#########################
sudo apt-get install -y redshift-gtk

# copy redshift settings
cp ./redshift.conf ~/.config/

############################
# install ssh server
# will generate /etc/ssh/sshd_config
############################
sudo apt-get install -y openssh-server

#
# install CopyQ
#
sudo add-apt-repository ppa:hluk/copyq
sudo apt update
sudo apt install -y copyq

####################################
# install fcitx-chewing 新酷音
# ubuntu安裝fcitx及注音輸入法
# https://smpsfox.blogspot.tw/2016/06/ubuntufcitx.html
####################################
sudo apt-get install -y fcitx fcitx-chewing

# solve black window issue
sudo apt-get install -y qtdeclarative5-qtquick2-plugin

#
# add docker-srv dir
#
DOCKERDIR="docker-srv"

#sudo ln -s /media/allenyllee/DATA/$DOCKERDIR /mnt/$DOCKERDIR
mkdir -p /mnt/$DOCKERDIR
chmod 777 /mnt/$DOCKERDIR

#
# build & up all docker service
#
#TODO: add docker compose file
docker-compose build
docker-compose up


#
# TODO: add backup job
#


#
# add hibernate option
# How can I hibernate on Ubuntu 16.04? - Ask Ubuntu
# https://askubuntu.com/questions/768136/how-can-i-hibernate-on-ubuntu-16-04
#
sudo tee -a /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla <<END
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
END

