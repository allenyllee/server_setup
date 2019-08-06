#!/bin/bash

# mount data folder
sudo mkdir /downloads
sudo mount --bind ~/Projects/ResilioSyncFolder/Media\(btsync\)/ /downloads
#sudo ln -s ~/Projects/ResilioSyncFolder/Media\(btsync\)/.deluge ~/.config/deluge
# mount config folder
sudo mkdir /downloads2
sudo mount --bind ~/Projects/ResilioSyncFolder/BT/ /downloads2

sudo mkdir ~/.config/deluge
sudo mount --bind ~/Projects_SSD/docker-srv/DelugeConfig.bak ~/.config/deluge
#sudo ln -s ~/Projects/ResilioSyncFolder/Media\(btsync\) /downloads


# run deluge
deluge-gtk
# run deamon
# deluged -d

# unmount data folder
sudo umount /downloads
sudo umount /downloads2
# unmount config folder
sudo umount ~/.config/deluge
