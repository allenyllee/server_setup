#!/bin/bash

UDEV_RULE_PATH=/lib/udev/rules.d # ubuntu 16.04


##############
# Running a Script on connecting USB device - Ask Ubuntu
# https://askubuntu.com/questions/401390/running-a-script-on-connecting-usb-device
# 
# To make this script work for any USB device which is connected change the rules file to this
# ACTION=="add", ATTRS{idVendor}=="****", ATTRS{idProduct}=="****", RUN+="/usr/local/my_script.sh"
# asterik(*) tells that this should be done for every USB device connected!
##############
# udev - How to run custom scripts upon USB device plug-in? - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/28548/how-to-run-custom-scripts-upon-usb-device-plug-in
# 
# Put a line like this in a file in /etc/udev/rules.d:
# KERNEL=="sd*", ATTRS{vendor}=="Yoyodyne", ATTRS{model}=="XYZ42", ATTRS{serial}=="123465789", RUN+="/pathto/script"
# 
# Add a clause like NAME="subdir/mydisk%n" if you want to use a custom entry path under /dev.
# 
# Run udevadm info -a -n sdb to see what attributes you can match against 
# (attribute=="value"; replace sdb by the device name automatically assigned to the disk, 
# corresponding to the new entry created in /dev when you plug it in).
# 
# the ATTRS clauses must all come from the same stanza, you can't mix and match. 
# You can mix ATTRS clauses with other types of clauses listed in a different stanza.
# 
# get all available attrs for /dev/video1:
#   udevadm info -a -n video1
#################################
echo 'KERNEL=="video*", ATTRS{idVendor}=="****", ATTRS{idProduct}=="****", RUN+="/usr/local/bin/webcam.sh"' | sudo tee $UDEV_RULE_PATH/webcam.rules >/dev/null

# copy script to /usr/local/bin
cp webcam.sh /usr/local/bin

# kernel - How to reload udev rules without reboot? - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/39370/how-to-reload-udev-rules-without-reboot
#
# Udev uses the inotify mechanism to watch for changes in the rules directory, 
# in both the library and in the local configuration trees (typically located at /lib/udev/rules.d and /etc/udev/rules.d). 
# So you don't need to do anything when you change a rules file.
# 
# You only need to notify the udev daemon explicitly if you're doing something unusual, 
# for example if you have a rule that includes files in another directory. 
# Then you can use the usual convention for asking daemons to reload their configuration: 
# send a SIGHUP (pkill -HUP udevd). Or you can use the udevadm command: udevadm control --reload-rules.
# 
sudo udevadm control --reload-rules

