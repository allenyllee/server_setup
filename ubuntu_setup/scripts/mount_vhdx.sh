#!/bin/bash

# [ubuntu] How do you mount a VHD image
# https://ubuntuforums.org/showthread.php?t=2299701
# 

# install qemu utils
sudo apt install qemu-utils

# install nbd client
sudo apt install nbd-client

# Load the nbd kernel module.
sudo rmmod nbd
sudo modprobe nbd max_part=16

# mount block device
sudo qemu-nbd -c /dev/nbd0 Cloud.vhdx

# reload partition table
sudo partprobe /dev/nbd0

# mount partition
sudo mount -o ro /dev/nbd0p2 /mnt/vhd/



#unmount
sudo qemu-nbd -d /dev/nbd0
sudo umount /mnt/vhd/

# remove nbd module
sudo rmmod nbd
