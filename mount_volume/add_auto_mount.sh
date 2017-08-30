#!/bin/bash

cp ./mount_volume.sh /etc/init.d

RUN_LEVEL=rc2.d #multi people mode, no GUI
rm -f /etc/$RUN_LEVEL/S98mount_volume.sh 
ln -s /etc/init.d/mount_volume.sh /etc/$RUN_LEVEL/S98mount_volume.sh 

RUN_LEVEL=rc5.d #with GUI
rm -f /etc/$RUN_LEVEL/S98mount_volume.sh 
ln -s /etc/init.d/mount_volume.sh /etc/$RUN_LEVEL/S98mount_volume.sh 

RUN_LEVEL=rcS.d #single mode
rm -f /etc/$RUN_LEVEL/S98mount_volume.sh 
ln -s /etc/init.d/mount_volume.sh /etc/$RUN_LEVEL/S98mount_volume.sh 

