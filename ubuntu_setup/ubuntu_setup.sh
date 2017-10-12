#!/bin/bash

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
# install VSCode
#
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders


###
### install Nvidia driver
###

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

