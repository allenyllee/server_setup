#!/bin/bash


PROJECT_DIR=$1
PROJECT_DIR_SSD=$2
DOCKERDIR="$PROJECT_DIR/docker-srv"
DOCKERDIR_SSD="$PROJECT_DIR_SSD/docker-srv"
export DOCKERBIN="$(which docker)"
export UserID=$(id -u)
export GroupID=$(id -g)

export XSOCK=/tmp/.X11-unix
export XAUTH_DIR=/tmp/.docker.xauth
export XAUTH=$XAUTH_DIR/.xauth


sudo mkdir -p $DOCKERDIR_SSD
sudo chmod 777 $DOCKERDIR_SSD

#
# gitlab data
#
export GITLAB_DIR=$DOCKERDIR/gitlab

#
# jenkins data
#
# security - How to give non-root user in Docker container access to a volume mounted on the host - Stack Overflow
# https://stackoverflow.com/questions/39397548/how-to-give-non-root-user-in-docker-container-access-to-a-volume-mounted-on-the
export JENKINS_DIR=$DOCKERDIR_SSD/jenkins_home
mkdir -p $JENKINS_DIR
chown -R 1000:1000 $JENKINS_DIR

#
# docker registry data
#
export REGISTRY_DIR=$DOCKERDIR/registry
export REG_BACKENDPORT=5000

#
# squid proxy data
#
export SQUID_DIR=$DOCKERDIR_SSD/squid/cache

#
# samba server shared folder
#
export SAMBA_DIR_SSD=$DOCKERDIR_SSD/samba
export SAMBA_DIR=$DOCKERDIR/samba

#
# Resilio Sync folder
#

export SYNC_CONFIG="$DOCKERDIR_SSD/ResilioSyncConfig"
export SYNC_DATA="$PROJECT_DIR/ResilioSyncFolder"

mkdir -p "$SYNC_CONFIG"
cp ./entrypoint_script/init_script.sh "$SYNC_CONFIG"

#
# onedrive
#
# 2019/08/05 update to latest version
# abraunegg/onedrive: Free Client for OneDrive on Linux
# https://github.com/abraunegg/onedrive
export ONEDRIVE_CONFIG="$DOCKERDIR_SSD/OneDriveConfig"
export ONEDRIVE_DATA="$SYNC_DATA/Cloud/OneDrive"


COMMAND=$(cat << EOF
docker run -it --rm \
  -e PUID=$UserID \
  -e PGID=$GroupID \
  -v $ONEDRIVE_CONFIG:/onedrive/conf \
  -v $ONEDRIVE_DATA:/onedrive/data \
  driveone/onedrive
EOF
)

if [ ! -e $ONEDRIVE_CONFIG/already_config ] ; then
  # create new terminal window to run COMMAND
  echo "$COMMAND"
  bash -c "$COMMAND; touch $ONEDRIVE_CONFIG/already_config"
fi


#
# Google Drive
#
export GOOGLEDRIVE_CONFIG="$DOCKERDIR_SSD/GoogleDriveConfig"
export GOOGLEDRIVE_DATA="$SYNC_DATA/Cloud/Google 雲端硬碟"

# export CLIENT_JSONFILE="google_drive_oauth.json"
# export CLIENT_ID=$(jq .installed.client_id $GOOGLEDRIVE_CONFIG/$CLIENT_JSONFILE | cut -d\" -f2 | cut -d. -f1)
# export CLIENT_SECRET=$(jq .installed.client_secret $GOOGLEDRIVE_CONFIG/$CLIENT_JSONFILE | cut -d\" -f2)

mkdir -p "$GOOGLEDRIVE_CONFIG"
cp ./entrypoint_script/docker-entrypoint.sh "$GOOGLEDRIVE_CONFIG"

# COMMAND=$(cat << EOF
# docker run -it --rm \
#   --user root:root \
#   --security-opt apparmor:unconfined \
#   --cap-add mknod \
#   --cap-add sys_admin \
#   --device=/dev/fuse \
#   -e CLIENT_ID=$CLIENT_ID \
#   -e CLIENT_SECRET=$CLIENT_SECRET \
#   -v "$GOOGLEDRIVE_DATA":/mnt/google-drive:shared \
#   -v "$GOOGLEDRIVE_CONFIG:/home/rancher/.gdfuse/default" \
#   --entrypoint "/home/rancher/.gdfuse/default/docker-entrypoint.sh" \
#   retrohunter/docker-google-drive-ocamlfuse
# EOF
# )


# if [ ! -e $GOOGLEDRIVE_CONFIG/already_config ] ; then
#   echo "$CLIENT_ID"
#   echo "$CLIENT_SECRET"
#   # create new terminal window to run COMMAND
#   echo "$COMMAND"
#   #gnome-terminal -x bash -c "$COMMAND"
#   bash -c "$COMMAND; touch $GOOGLEDRIVE_CONFIG/already_config"
# fi

#
# ODrive (Google Drive client)
#
export ODRIVE_CONFIG="$DOCKERDIR_SSD/ODriveConfig/odrive"
export ODRIVE_DATA="$SYNC_DATA/Cloud/Google 雲端硬碟"


#
# Dropbox
#
export DROPBOX_CONFIG="$DOCKERDIR_SSD/DropboxConfig"
export DROPBOX_DATA="$SYNC_DATA/Cloud/Dropbox"

mkdir -p "$DROPBOX_CONFIG"
cp ./entrypoint_script/run.sh "$DROPBOX_CONFIG"

# COMMAND=$(cat << EOF
# docker run -it --rm \
#   -e DBOX_UID=$UserID \
#   -e DBOX_GID=$GroupID \
#   -v $DROPBOX_DATA:/dbox/Dropbox \
#   -v $DROPBOX_CONFIG:/dbox/.dropbox \
#   --net="host" \
#   --entrypoint /dbox/.dropbox/run \
#   --privileged=true \
#   janeczku/dropbox
# EOF
# )

# if [ ! -e $DROPBOX_CONFIG/already_config ] ; then
#   # create new terminal window to run COMMAND
#   echo "$COMMAND"
#   bash -c "$COMMAND; touch $ONEDRIVE_CONFIG/already_config"
# fi


#
# WebStorage
# 
export WebStorage_CONFIG="$DOCKERDIR_SSD/WebStorageConfig/.wine"
export WebStorage_DATA="$SYNC_DATA/Cloud/WebStorage"


#
# BaiduYun
# 
export BaiduYun_CONFIG="$DOCKERDIR_SSD/BaiduYunConfig/.wine"
export BaiduYun_DATA="$SYNC_DATA/Cloud/baidubox"


#
# deluge
#
export DELUGE_DATA="$SYNC_DATA/Media(btsync)"
export DELUGE_DATA2="$SYNC_DATA/BT"
export DELUGE_TEMP="$SYNC_DATA/temps"
export DELUGE_CONFIG="$DOCKERDIR_SSD/DelugeConfig"

# mount data folder
#sudo mount --bind ~/Projects/ResilioSyncFolder/Media\(btsync\)/ /downloads
# sudo ln -s -T -f $DELUGE_DATA/.deluge ~/.config/deluge
# mount config folder
#sudo mount --bind ~/Projects_SSD/docker-srv/DelugeConfig ~/.config/deluge
#sudo ln -s -T -f "$DELUGE_DATA" /downloads

#
# xtensa source
#
# linux - Forcing bash to expand variables in a string loaded from a file - Stack Overflow
# https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file
#
export XTENSA_GIT=$(eval echo $PROJECT_DIR)/xtensa_X_docker

# folder to share with samba
export XTENSA_DIR=$SAMBA_DIR/xtensa_dir

