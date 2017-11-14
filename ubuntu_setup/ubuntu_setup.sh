#!/bin/bash

#/*
# * @Author: Allen_Lee 
# * @Date: 2017-10-15 00:27:41 
# * @Last Modified by:   Allen_Lee 
# * @Last Modified time: 2017-10-15 00:27:41 
# */

PROJECT_DIR=$1

# ________  ________  ________  ___  __    _______   ________
#|\   ___ \|\   __  \|\   ____\|\  \|\  \ |\  ___ \ |\   __  \
#\ \  \_|\ \ \  \|\  \ \  \___|\ \  \/  /|\ \   __/|\ \  \|\  \
# \ \  \ \\ \ \  \\\  \ \  \    \ \   ___  \ \  \_|/_\ \   _  _\
#  \ \  \_\\ \ \  \\\  \ \  \____\ \  \\ \  \ \  \_|\ \ \  \\  \|
#   \ \_______\ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\
#    \|_______|\|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|
#
#
#

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
sudo docker run --rm hello-world

#############################
# running docker without sudo by adding user into docker group
# How can I use docker without sudo? - Ask Ubuntu
# https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo
#############################

# add docker group & add current ser into it
sudo groupadd docker
sudo gpasswd -a $USER docker

# activate the changes to groups
# start new shell with group docker
# scripting - Problem while running "newgrp" command in script - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/18897/problem-while-running-newgrp-command-in-script
newgrp docker <<EOF
docker run --rm hello-world
EOF

######################
# enable docker api for jenkins CI use
# Enabling Docker Remote API on Ubuntu 16.04 – The Blog of Ivan Krizsan 
# https://www.ivankrizsan.se/2016/05/18/enabling-docker-remote-api-on-ubuntu-16-04/
# test: curl http://localhost:4243/version
# test2: curl -X GET http://192.168.5.5:4243/images/json
######################
sudo sed -i '/ExecStart=\/usr\/bin\/docker*/ c\ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ -H tcp:\/\/0.0.0.0:4243' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo service docker restart


##############################
# run GUI app in docker with Xauthority file (without using xhost +local:root)
# https://stackoverflow.com/a/25280523/1851492
#
# docker/Tutorials/GUI - ROS Wiki 
# http://wiki.ros.org/docker/Tutorials/GUI
#
# you need to mount volume /tmp/.docker.xauth and 
# set environment vaiable XAUTHORITY=/tmp/.docker.xauth 
# in your docker run command
# 
# --volume=/tmp/.docker.xauth:/tmp/.docker.xauth:rw
# --env="XAUTHORITY=/tmp/.docker.xauth"
###############################

# set .docker.xauth after login, becasue /tmp will be deleted everytime system startup
# filesystem - How is the /tmp directory cleaned up? - Ask Ubuntu 
# https://askubuntu.com/questions/20783/how-is-the-tmp-directory-cleaned-up
# 

# workflow:
#       1. To avoid docker automatically create a $XAUTH_DIR directory before it mount, 
#           insert a command which is to create $XAUTH_DIR directory 
#           with mod 777 (read/write for all user) into /etc/rc.local.
#           Because /etc/rc.local will execute at the end of runlevel which before docker service start, 
#           this is a good point to place it.
#       2. After docker daemon start, it will mount $XAUTH_DIR if needed. 
#       3. After system login, it will execute ~/.profile to setup $XAUTH_DIR/.xauth file

# 1. Use tr to swap the newline character to NUL character.
#       NUL (\000 or \x00) is nice because it doesn't need UTF-8 support and it's not likely to be used.
# 2. Use sed to match the string
# 3. Use tr to swap back.
# 4. insert a string into /etc/rc.local before exit 0
tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|\x00XAUTH_DIR=.*\x00\x00|\x00|' /etc/rc.local >/dev/null
tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|^exit 0.*$|XAUTH_DIR=/tmp/.docker.xauth; rm -rf $XAUTH_DIR; install -m 777 -d $XAUTH_DIR\n\nexit 0|' /etc/rc.local

# create a folder with mod 777 that can allow all other user read/write
XAUTH_DIR=/tmp/.docker.xauth; sudo rm -rf $XAUTH_DIR; install -m 777 -d $XAUTH_DIR

# append string in ~/.profile
tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
sed -i 's|\x00XAUTH_DIR=.*-\x00|\x00|' ~/.profile
tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
echo "XAUTH_DIR=/tmp/.docker.xauth; XAUTH=\$XAUTH_DIR/.xauth; touch \$XAUTH; xauth nlist \$DISPLAY | sed -e 's/^..../ffff/' | xauth -f \$XAUTH nmerge -" >> ~/.profile
source ~/.profile



# install jq
# https://stedolan.github.io/jq/
# jq is like sed for JSON data - you can use it to slice and filter and 
# map and transform structured data with the same ease that sed, awk, 
# grep and friends let you play with text.
sudo apt-get install -y jq

# ________   ___      ___ ___  ________  ___  ________          ________  ________  ___  ___      ___ _______   ________
#|\   ___  \|\  \    /  /|\  \|\   ___ \|\  \|\   __  \        |\   ___ \|\   __  \|\  \|\  \    /  /|\  ___ \ |\   __  \
#\ \  \\ \  \ \  \  /  / | \  \ \  \_|\ \ \  \ \  \|\  \       \ \  \_|\ \ \  \|\  \ \  \ \  \  /  / | \   __/|\ \  \|\  \
# \ \  \\ \  \ \  \/  / / \ \  \ \  \ \\ \ \  \ \   __  \       \ \  \ \\ \ \   _  _\ \  \ \  \/  / / \ \  \_|/_\ \   _  _\
#  \ \  \\ \  \ \    / /   \ \  \ \  \_\\ \ \  \ \  \ \  \       \ \  \_\\ \ \  \\  \\ \  \ \    / /   \ \  \_|\ \ \  \\  \|
#   \ \__\\ \__\ \__/ /     \ \__\ \_______\ \__\ \__\ \__\       \ \_______\ \__\\ _\\ \__\ \__/ /     \ \_______\ \__\\ _\
#    \|__| \|__|\|__|/       \|__|\|_______|\|__|\|__|\|__|        \|_______|\|__|\|__|\|__|\|__|/       \|_______|\|__|\|__|
#
#
#

######################
# install Nvidia driver
# How do I install the Nvidia drivers? - Ask Ubuntu 
# https://askubuntu.com/questions/61396/how-do-i-install-the-nvidia-drivers
######################

# add ppa repository
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get upgrade -y

# purge all previous version (--purge removes configuration files)
sudo apt-get remove --purge -y nvidia-*

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

##########################
# install intel microcode
##########################
sudo apt-get install -y intel-microcode


# ___      ___ ________  ________  ________  ________  _______
#|\  \    /  /|\   ____\|\   ____\|\   __  \|\   ___ \|\  ___ \
#\ \  \  /  / | \  \___|\ \  \___|\ \  \|\  \ \  \_|\ \ \   __/|
# \ \  \/  / / \ \_____  \ \  \    \ \  \\\  \ \  \ \\ \ \  \_|/__
#  \ \    / /   \|____|\  \ \  \____\ \  \\\  \ \  \_\\ \ \  \_|\ \
#   \ \__/ /      ____\_\  \ \_______\ \_______\ \_______\ \_______\
#    \|__|/      |\_________\|_______|\|_______|\|_______|\|_______|
#                \|_________|
#
#

######################
# install VSCode
######################
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders

#
# for Spell Right extension to find system dictionary
# 
# Spell Right - Visual Studio Marketplace 
# https://marketplace.visualstudio.com/items?itemName=ban.spellright
#
ln -s /usr/share/hunspell ~/.config/Code/Dictionaries

#
# Visual Studio Code Comes to Linux · 2buntu 
# https://2buntu.com/articles/1529/visual-studio-code-comes-to-linux/
#
# Multiple Cursors
# Code lets you edit a file in multiple places at the same time 
# (something that Sublime users are also familiar with). 
# However, Ubuntu users will quickly run into a problem. 
# The keyboard shortcut for doing this is Alt+Click, which by default will move the window instead of adding another cursor. 
# To fix this, we need to change a setting:
#
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Super>"

#
# How do I disable window move with alt + left mouse button in GNOME Shell? - Ask Ubuntu
# https://askubuntu.com/questions/118151/how-do-i-disable-window-move-with-alt-left-mouse-button-in-gnome-shell/118179#118179
#
sudo apt-get install -y dconf-tools

# install bash debug
sudo apt-get install -y bashdb

################
# build pdf
################
# install PhantomJS
sudo apt install -y phantomjs
phantomjs --version


# install pandoc
export VERSION=2.0.1.1
wget https://github.com/jgm/pandoc/releases/download/$VERSION/pandoc-$VERSION-1-amd64.deb
sudo dpkg -i pandoc-$VERSION-1-amd64.deb

# install xelatex for chinese support
sudo apt install -y texlive-xetex 


# ________   ________  ________  _______         ___  ________
#|\   ___  \|\   __  \|\   ___ \|\  ___ \       |\  \|\   ____\
#\ \  \\ \  \ \  \|\  \ \  \_|\ \ \   __/|      \ \  \ \  \___|_
# \ \  \\ \  \ \  \\\  \ \  \ \\ \ \  \_|/__  __ \ \  \ \_____  \
#  \ \  \\ \  \ \  \\\  \ \  \_\\ \ \  \_|\ \|\  \\_\  \|____|\  \
#   \ \__\\ \__\ \_______\ \_______\ \_______\ \________\____\_\  \
#    \|__| \|__|\|_______|\|_______|\|_______|\|________|\_________\
#                                                       \|_________|
#
#

######################
# install nodejs
# nodesource/distributions: NodeSource Node.js Binary Distributions 
# https://github.com/nodesource/distributions
######################
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v # print version

# npm install -g puppeteer fails · Issue #375 · GoogleChrome/puppeteer 
# https://github.com/GoogleChrome/puppeteer/issues/375
#
# 03 - Fixing npm permissions | npm Documentation 
# https://docs.npmjs.com/getting-started/fixing-npm-permissions
#
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# set PATH
tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
sed -i 's|\x00export PATH=".*npm-global.*"\x00|\x00|' ~/.profile
tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
echo 'export PATH="~/.npm-global/bin:$PATH"' >> ~/.profile
source ~/.profile

# add module search path NODE_PATH
# npm - node.js modules path - Stack Overflow 
# https://stackoverflow.com/questions/13465829/node-js-modules-path

# set NODE_PATH
tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
sed -i 's|\x00export NODE_PATH=".*node_modules"\x00|\x00|' ~/.profile
tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
echo 'export NODE_PATH="'$(npm root -g)'"' >> ~/.profile
source ~/.profile


# install puppeteer
npm install -g puppeteer

#
# install fast-cli
# sindresorhus/fast-cli: Test your download speed using fast.com
# https://github.com/sindresorhus/fast-cli
#
npm install --global fast-cli

########################
# install gun global
########################

# In ubuntu may reported that
#   configure: checking "location of ncurses.h file"...
#   configure: error: curses library is required but not found.
# you should install ncurse lib:
sudo apt-get install -y lib64ncurses5-dev

# download latest version 
# Getting GLOBAL 
# https://www.gnu.org/software/global/download.html
wget http://tamacom.com/global/global-6.5.7.tar.gz

# untar
tar zxvf global-6.5.7.tar.gz

# configure
cd global-6.5.7
./configure

# may install in /usr/local/lib/gtags
sudo make install

# remove files
cd -
sudo rm -rf global-6.5.7 global-6.5.7.tar.gz

#############
# enable Pygments Plug-in Parser for GNU Global
# GLOBAL: plugin-factory/PLUGIN_HOWTO.pygments | Fossies 
# https://fossies.org/linux/global/plugin-factory/PLUGIN_HOWTO.pygments
#############

# install python
sudo apt-get install -y python

# install exuberant-ctags
sudo apt-get install -y exuberant-ctags

# python - How to install pygments on Ubuntu? - Stack Overflow 
# https://stackoverflow.com/questions/26215738/how-to-install-pygments-on-ubuntu
# install python-pygments
sudo apt-get install -y python-pygments

# check python ctags
type python
type ctags

#
# The definition of Pygments plug-in parser is prepared
# in the default configuration file. Please specify it.
#
# How to permanently export a variable in Linux? - Stack Overflow 
# https://stackoverflow.com/questions/13046624/how-to-permanently-export-a-variable-in-linux
# 
echo GTAGSCONF=/usr/local/share/gtags/gtags.conf|sudo tee -a /etc/environment
echo GTAGSLABEL=pygments|sudo tee -a /etc/environment

# 
# install pylint for python3
# python - Installing Pylint for Python3 on Ubuntu - Ask Ubuntu 
# https://askubuntu.com/questions/340940/installing-pylint-for-python3-on-ubuntu
# 
sudo apt-get install -y python3-pip
sudo pip-3.3 install -y pylint

# ________       ___    ___ ________  _________  _______   _____ ______           ___  ________   ________ ________          _________  ________  ________  ___
#|\   ____\     |\  \  /  /|\   ____\|\___   ___\\  ___ \ |\   _ \  _   \        |\  \|\   ___  \|\  _____\\   __  \        |\___   ___\\   __  \|\   __  \|\  \
#\ \  \___|_    \ \  \/  / | \  \___|\|___ \  \_\ \   __/|\ \  \\\__\ \  \       \ \  \ \  \\ \  \ \  \__/\ \  \|\  \       \|___ \  \_\ \  \|\  \ \  \|\  \ \  \
# \ \_____  \    \ \    / / \ \_____  \   \ \  \ \ \  \_|/_\ \  \\|__| \  \       \ \  \ \  \\ \  \ \   __\\ \  \\\  \           \ \  \ \ \  \\\  \ \  \\\  \ \  \
#  \|____|\  \    \/  /  /   \|____|\  \   \ \  \ \ \  \_|\ \ \  \    \ \  \       \ \  \ \  \\ \  \ \  \_| \ \  \\\  \           \ \  \ \ \  \\\  \ \  \\\  \ \  \____
#    ____\_\  \ __/  / /       ____\_\  \   \ \__\ \ \_______\ \__\    \ \__\       \ \__\ \__\\ \__\ \__\   \ \_______\           \ \__\ \ \_______\ \_______\ \_______\
#   |\_________\\___/ /       |\_________\   \|__|  \|_______|\|__|     \|__|        \|__|\|__| \|__|\|__|    \|_______|            \|__|  \|_______|\|_______|\|_______|
#   \|_________\|___|/        \|_________|
#
#

###############################
# system info tools
# 5 GUI Tools to See Hardware Details in Ubuntu/Linux | TechGainer 
# https://www.techgainer.com/5-gui-tools-to-see-hardware-information-in-ubuntulinux/
###############################

# I-Nex
sudo add-apt-repository -y ppa:i-nex-development-team/stable
sudo apt-get update
sudo apt-get install -y i-nex

# Hardinfo
sudo apt-get install -y hardinfo

# Sysinfo
sudo apt-get install -y sysinfo

# lshw-gtk 
sudo apt-get install -y lshw-gtk

# KInfoCenter
sudo apt-get install -y kinfocenter

###################
# CUDA-Z 
# http://cuda-z.sourceforge.net/
###################
#
# linux - How to allow wget to overwrite files - Server Fault
# https://serverfault.com/questions/171369/how-to-allow-wget-to-overwrite-files
# -N, --timestamping don't re-retrieve files unless newer than local.
#
wget -N http://sourceforge.net/projects/cuda-z/files/cuda-z/0.10/CUDA-Z-0.10.251-64bit.run



#################
# graphical front-end to su and sudo
#################
sudo apt-get install -y gksu

##################
# display graphs for monitoring hardware temperature
##################
sudo apt-get install -y psensor

################
# GNOME partition editor
################
sudo apt-get install -y gparted

################
# utility for graphically configuring Logical Volumes
################
sudo apt-get install -y system-config-lvm


################
# Vi IMproved - enhanced vi editor
################
sudo apt-get install -y vim

################
# disk space analyzer
################
sudo apt-get install -y Baobab

################
# Alternative to CrystalDiskInfo
################
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

# install sshfs
sudo apt-get install -y sshfs

#####################
# install CopyQ
#####################
sudo add-apt-repository -y ppa:hluk/copyq
sudo apt update
sudo apt install -y copyq

############################
# install pdfsam
############################
# How to download the latest release from Github 
# http://www.starkandwayne.com/blog/how-to-download-the-latest-release-from-github/
############################
# PDFsam Basic on Linux with OpenJDK 
# http://pdfsam.org/run-on-linux-with-openjdk/
############################

# iinstall openjfx
sudo apt install -y openjfx

# get latest release file list (all version) from github
curl -s https://api.github.com/repos/torakiki/pdfsam/releases/latest | jq -r ".assets[].name"

# get latest release URL from github
pdfsam_type=-1_all.deb
URL=$(curl -s https://api.github.com/repos/torakiki/pdfsam/releases/latest | jq -r ".assets[] | select(.name | test(\"${pdfsam_type}\")) | .browser_download_url")

# download latest file
wget --content-disposition $URL

# install package
sudo dpkg -i pdfsam_*-1_all.deb


####################################
# install fcitx-chewing 新酷音
# ubuntu安裝fcitx及注音輸入法
# https://smpsfox.blogspot.tw/2016/06/ubuntufcitx.html
####################################
sudo apt-get install -y fcitx fcitx-chewing

# solve black window issue
sudo apt-get install -y qtdeclarative5-qtquick2-plugin

# install 7-zip
# How to install 7zip in Ubuntu | Ubuntu 12.04 Tips and Tricks | Ubuntu | Tips and Tricks 
# https://www.computernetworkingnotes.com/ubuntu-12-04-tips-and-tricks/how-to-install-7zip-in-ubuntu.html
# p7zip available in two packages.
#     p7zip-full
#     p7zip
# Difference between p7zip-full and p7zip are following.
# p7zip-full" contains "7z" and "7za" archives while "p7zip" contains "p7r" archive. 
# So p7zip provides 7zr (liter version of 7za/7z) and documentation whereas p7zip-full provides 7z (with 7z.so), 
# 7za, 7zCon.sfx (to make auto extractible archive), and documentation.
# If you want to create/extract only 7z archive (without password) take p7zip (7zr) else p7zip-full (with p7zip-rar)
sudo apt-get install p7zip-full


############################
# add hibernate option
# How can I hibernate on Ubuntu 16.04? - Ask Ubuntu
# https://askubuntu.com/questions/768136/how-can-i-hibernate-on-ubuntu-16-04
############################
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

#######################
# Ubuntu 如何支援exFAT(FAT64)檔案系統(File System)？ | MagicLen
# https://magiclen.org/ubuntu-exfat/
#######################
sudo apt install -y exfat-utils exfat-fuse

####################
# install bitmeteros
####################
# linux - How to wget a file with correct name when redirected? - Super User
# https://superuser.com/questions/301044/how-to-wget-a-file-with-correct-name-when-redirected
#
# software installation - How do I install a .deb file via the command line? - Ask Ubuntu
# https://askubuntu.com/questions/40779/how-do-i-install-a-deb-file-via-the-command-line
####################
wget -N --content-disposition https://codebox.net/downloads/bitmeteros/linux64
sudo dpkg -i bitmeteros_*-amd64.deb

###############
# install google chrome
###############
# UbuntuUpdates - PPA: Google Chrome 
# https://www.ubuntuupdates.org/ppa/google_chrome
#
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update 
sudo apt-get install -y google-chrome-stable

#############
# install normalized audio plugin
#############
# sound - Automatically adjust the volume based on content? - Ask Ubuntu 
# https://askubuntu.com/questions/95716/automatically-adjust-the-volume-based-on-content
#
# Change the control parameter to reflect control=-12,1,0.5,0.99 using -12 instead of 0. 
# This means that only sound above -12 dB will be compressed (softened), 
# which typically includes anything louder than voices / conversation. 
# Make this change if you're finding that, when watching movies (e.g. RED 2 on NetFlix), 
# the vocals are still too quiet compared to the explosions.
#
#sudo apt-get install -y swh-plugins
#
#tee ~/.config/pulse/default.pa << END
#.nofail
#.include /etc/pulse/default.pa
#load-module module-ladspa-sink  sink_name=ladspa_sink  plugin=dyson_compress_1403  label=dysonCompress  control=-12,1,0.5,0.99
#load-module module-ladspa-sink  sink_name=ladspa_normalized  master=ladspa_sink  plugin=fast_lookahead_limiter_1913  label=fastLookaheadLimiter  control=10,0,0.8
#set-default-sink ladspa_normalized
#END
#
#pulseaudio -k

#############
# install pulseeffects from ppa (old version)
#############
# sound - Real-Time Volume Leveling & Audio Outputs - Ask Ubuntu 
# https://askubuntu.com/questions/659582/real-time-volume-leveling-audio-outputs
# I found the following Internet address: omgubuntu.co.uk/2017/06/install-pulse-effects-ubuntu-ppa. 
# It is a very good software to get real time audio processing (limiter, compressor and equalizer) with PulseAudio. 
# 
#sudo add-apt-repository -y ppa:yunnxx/gnome3
#sudo apt-get update
#sudo apt-get install -y pulseeffects
#
#cp ./pulseeffects.desktop ~/.config/autostart/


###############
# install pulseeffects from flatpak
###############
# Getting Flatpak 
# http://flatpak.org/getting.html
#
sudo add-apt-repository -y ppa:alexlarsson/flatpak
sudo apt update
sudo apt install -y flatpak
#
# wwmm/pulseeffects: Limiter, compressor, reverberation, equalizer and auto volume effects for Pulseaudio applications 
# https://github.com/wwmm/pulseeffects
#
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.github.wwmm.pulseeffects

# Tray · Issue #5 · wwmm/pulseeffects 
# https://github.com/wwmm/pulseeffects/issues/5
# 
# In any case @Ixoos there is something you can do that has a similar effect as having a daemon. 
# Start PulseEffects with the option of hiding the interface https://github.com/wwmm/pulseeffects/wiki/Command-Line-Options. 
# You just have to write a .desktop file that uses this command line option and copy it to ~/.config/autostart.
# 
mkdir -p ~/.config/autostart/
cp ./com.github.wwmm.pulseeffects.desktop ~/.config/autostart/

#
# command line - Running a .desktop file in the terminal - Ask Ubuntu 
# https://askubuntu.com/a/577819
#
# jceb/dex: DesktopEntry Execution 
# https://github.com/jceb/dex
#
sudo apt-get install -y dex
dex ./com.github.wwmm.pulseeffects.desktop

###############
# How To Create Menu Icon in Ubuntu for Installed Flatpak Application 
# http://www.ubuntubuzz.com/2016/12/how-to-create-menu-icon-in-ubuntu-for-installed-flatpak-application.html
###############
# install alacarte (Menu Editor)
###############
sudo apt-get install -y alacarte


###################
# How to enable numlock at boot time for login screen? - Ask Ubuntu 
# https://askubuntu.com/questions/155679/how-to-enable-numlock-at-boot-time-for-login-screen
###################
sudo apt-get update
sudo apt-get install -y numlockx

# ################################
# # Just turn on numlock after user login
# ################################
# # first remove previous numlock command
# sudo sed -i 's|^.*[Nn]umlock.*||' /etc/rc.local 
# # second remove previous newline character
# # https://stackoverflow.com/a/8997314/1851492
# #
# # 1. Use tr to swap the newline with another character.
# # NULL (\000 or \x00) is nice because it doesn't need UTF-8 support and it's not likely to be used.
# # 2. Use sed to match the NULL
# # 3. Use tr to swap back extra newlines if you need them
# tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
# sudo sed -i 's|\x00\x00\x00\x00exit|\x00exit|' /etc/rc.local >/dev/null
# tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
# # third add new numlock command
# sudo sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ] \&\& numlockx on\n\nexit 0|' /etc/rc.local
# ################################


#####################################
# turn on numlock before & after login
#####################################
# Turn on NumLock Automatically When Ubuntu 14.04 Boots Up | UbuntuHandbook 
# http://ubuntuhandbook.org/index.php/2014/06/turn-on-numlock-ubuntu-14-04/
#
sudo sed -i 's|^.*numlockx.*||' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
tr '\n' '@' < /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf | sudo tee /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf >/dev/null
sudo sed -i 's|@@$|@|' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf >/dev/null
tr '@' '\n' < /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf | sudo tee /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf >/dev/null
echo "greeter-setup-script=/usr/bin/numlockx on" | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf


#########################
# TODO: build & up all docker service
#########################
# linux - Forcing bash to expand variables in a string loaded from a file - Stack Overflow
# https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file
#
git config --global credential.helper store
git clone https://gitlab.com/allenyllee/xtensa_X_docker.git -b xtensa $(eval echo $PROJECT_DIR)/xtensa_X_docker

bash<<EOF
# version control - How do I force "git pull" to overwrite local files? - Stack Overflow
# https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
cd $(eval echo $PROJECT_DIR)/xtensa_X_docker
echo $PWD
git fetch --all
git reset --hard origin/xtensa
EOF

bash ./run_services.sh "$PROJECT_DIR"

######################
# TODO: add backup job
######################


##############
# remove useless packages
##############
sudo apt autoremove -y
