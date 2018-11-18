#!/bin/bash

# mount data folder
sudo mkdir /downloads
sudo mount --bind ~/Projects/ResilioSyncFolder/Media\(btsync\)/ /downloads
#sudo ln -s ~/Projects/ResilioSyncFolder/Media\(btsync\)/.deluge ~/.config/deluge
# mount config folder
sudo mkdir /downloads2
sudo mount --bind ~/Projects/ResilioSyncFolder/BT/ /downloads2

sudo mount --bind ~/Projects_SSD/docker-srv/DelugeConfig ~/.config/deluge
#sudo ln -s ~/Projects/ResilioSyncFolder/Media\(btsync\) /downloads


# run deluge
deluge-gtk

# unmount data folder
#sudo umount /downloads
# unmount config folder
#sudo umount ~/.config/deluge
