#!/bin/bash

#/*
# * @Author: Allen_Lee
# * @Date: 2017-10-15 00:27:41
# * @Last Modified by:   Allen_Lee
# * @Last Modified time: 2017-10-15 00:27:41
# */

PROJECT_DIR=$1
PROJECT_DIR_SSD=$2

###################
# shell - How to check OS and version using a Linux command - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/88644/how-to-check-os-and-version-using-a-linux-command
###########
# bash search for string in each line of file - Stack Overflow
# https://stackoverflow.com/questions/5695916/bash-search-for-string-in-each-line-of-file
###########
# How to define 'tab' delimiter with 'cut' in BASH? - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/35369/how-to-define-tab-delimiter-with-cut-in-bash
###################

## code name ##
# 16.04 xenial
# 18.04 bionic
###############
# 1. "lsb_release -a" get the distribution information
# 2. "grep" get the line contains "Codename"
# 3. "cut" get the second column of tab delimiter line
CODENAME=$(lsb_release -a | grep "Codename" | cut -d$'\t' -f2)

USER_NAME=$(logname)

sudo -u $USER_NAME bash <<EOF
mkdir -p ~/.config/autostart/
EOF

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
# Get Docker CE for Ubuntu | Docker Documentation
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce
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
sudo add-apt-repository -y \
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

# add docker group & add current user into it
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

########
# Ubuntu 18.04 rc.local systemd设置 - CSDN博客
# https://blog.csdn.net/zhengchaooo/article/details/80202599
########
# Codename:
# Releases - Ubuntu Wiki
# https://wiki.ubuntu.com/Releases
########
# If Statements - Bash Scripting Tutorial
# https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php
########
# How to append tee to a file in Bash? - Ask Ubuntu
# https://askubuntu.com/questions/808539/how-to-append-tee-to-a-file-in-bash
########
# How can I replace a newline (\n) using sed? - Stack Overflow
# https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
########
# Echo newline in Bash prints literal \n - Stack Overflow
# https://stackoverflow.com/questions/8467424/echo-newline-in-bash-prints-literal-n
########

if [ $CODENAME == "bionic" ]
then
    echo "hello" $CODENAME
    sudo ln -fs /lib/systemd/system/rc-local.service /etc/systemd/system/rc.local.service

    # 在rc.local.service 新增 [Install] 区块，定义如何安装这个配置文件，即怎样做到开机启动。
    tr '\n' '\000' < /etc/systemd/system/rc.local.service | sudo tee /etc/systemd/system/rc.local.service >/dev/null
    sudo sed -i 's|\x00\[Install\]\x00WantedBy=multi-user.target\x00Alias=rc.local.service||' /etc/systemd/system/rc.local.service
    tr '\000' '\n' < /etc/systemd/system/rc.local.service | sudo tee /etc/systemd/system/rc.local.service >/dev/null
    printf "[Install]\nWantedBy=multi-user.target\nAlias=rc.local.service\n" | sudo tee -a /etc/systemd/system/rc.local.service >>/dev/null

    # 新增 /etc/rc.local
    sudo touch /etc/rc.local
    sudo chmod 755 /etc/rc.local

    # 第一行插入 #!/bin/bash
    # Add a line to a specific position in a file using Linux sed
    # https://www.garron.me/en/linux/add-line-to-specific-position-in-file-linux.html
    tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
    sudo sed -i 's|^#!/bin/bash\x00||' /etc/rc.local
    tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
    sudo sed -i '1i#!/bin/bash' /etc/rc.local

    # 最後一行插入exit 0
    tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
    sudo sed -i 's|\x00exit 0.*$||' /etc/rc.local
    tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
    printf "\nexit 0" | sudo tee -a /etc/rc.local >>/dev/null
fi

XAUTH_CMD="XAUTH_DIR=/tmp/.docker.xauth; rm -rf \$XAUTH_DIR; install -m 777 -d \$XAUTH_DIR"

# 1. Use tr to swap the newline character to NUL character.
#       NUL (\000 or \x00) is nice because it doesn't need UTF-8 support and it's not likely to be used.
# 2. Use sed to match the string
# 3. Use tr to swap back.
# 4. insert a string into /etc/rc.local before exit 0
tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|\x00'"$XAUTH_CMD"'\x00\x00|\x00|' /etc/rc.local >/dev/null
tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|^exit 0.*$|'"$XAUTH_CMD"'\n\nexit 0|' /etc/rc.local


# create a folder with mod 777 that can allow all other user read/write
eval "sudo bash -c '$XAUTH_CMD'"



XAUTH_CMD2="XAUTH_DIR=/tmp/.docker.xauth; XAUTH=\$XAUTH_DIR/.xauth; touch \$XAUTH; xauth nlist \$DISPLAY | sed -e 's/^..../ffff/' | xauth -f \$XAUTH nmerge -"

# append string in ~/.profile
tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
# use # as delimiter to avoid conflict with XAUTH_CMD2's pipe |
sed -i 's#'"$XAUTH_CMD2"'\x00##' ~/.profile
tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
echo "$XAUTH_CMD2" >> ~/.profile
source ~/.profile


#############
# run GUI app with host dbus
#############

#
# d bus - Connect with D-Bus in a network namespace - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/184964/connect-with-d-bus-in-a-network-namespace/396821#396821
#
# xdg-dbus-proxy package : Ubuntu
# https://launchpad.net/ubuntu/+source/xdg-dbus-proxy
#
curl 'https://launchpadlibrarian.net/448458251/xdg-dbus-proxy_0.1.2-1_amd64.deb' --output 'xdg-dbus-proxy_0.1.2-1_amd64.deb'
sudo dpkg -i xdg-dbus-proxy_0.1.2-1_amd64.deb

DBUS_CMD="DBUS_DIR=/tmp/.dbus; rm -rf \$DBUS_DIR; install -m 777 -d \$DBUS_DIR"

# 1. Use tr to swap the newline character to NUL character.
#       NUL (\000 or \x00) is nice because it doesn't need UTF-8 support and it's not likely to be used.
# 2. Use sed to match the string
# 3. Use tr to swap back.
# 4. insert a string into /etc/rc.local before exit 0
tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|\x00'"$DBUS_CMD"'\x00\x00|\x00|' /etc/rc.local >/dev/null
tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
sudo sed -i 's|^exit 0.*$|'"$DBUS_CMD"'\n\nexit 0|' /etc/rc.local


# create a folder with mod 777 that can allow all other user read/write
eval "sudo bash -c '$DBUS_CMD'"



# DBUS_CMD2="DBUS_DIR=/tmp/.dbus; DBUS_PROXY=\$DBUS_DIR/.proxybus; xdg-dbus-proxy \$DBUS_SESSION_BUS_ADDRESS \$DBUS_PROXY &"

# # append string in ~/.profile
# tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
# # use # as delimiter to avoid conflict with DBUS_CMD2's pipe |
# sed -i 's#'"$DBUS_CMD2"'\x00##' ~/.profile
# tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
# echo "$DBUS_CMD2" >> ~/.profile
# source ~/.profile

#
# use upstart to run dbus proxy
#
# gnome-open raises this error when run from inside tmux - Ask Ubuntu
# https://askubuntu.com/questions/51132/gnome-open-raises-this-error-when-run-from-inside-tmux
#
sudo cp ./upstart/dbus_proxy.conf /usr/share/upstart/sessions/


# install jq
# https://stedolan.github.io/jq/
# jq is like sed for JSON data - you can use it to slice and filter and
# map and transform structured data with the same ease that sed, awk,
# grep and friends let you play with text.
sudo apt-get install -y jq


#######
# Install Docker Compose | Docker Documentation
# https://docs.docker.com/compose/install/#install-compose
#######
# Shell - Get latest release from GitHub
# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
# it needs jq to parse json from github API, and get the download url.
#######
# jq Manual (development version)
# https://stedolan.github.io/jq/manual/
#
# --arg name value:
# This option passes a value to the jq program as a predefined variable.
# If you run jq with --arg foo bar, then $foo is available in the program and has the value "bar".
# Note that value will be treated as a string, so --arg foo 123 will bind $foo to "123".
#
# --raw-output / -r:
# With this option, if the filter’s result is a string then it will be written directly to standard
# output rather than being formatted as a JSON string with quotes. This can be useful for making jq
# filters talk to non-JSON-based systems.
#
#  select(boolean_expression)
# The function select(foo) produces its input unchanged if foo returns true for that input,
# and produces no output otherwise.
# It’s useful for filtering lists: [1,2,3] | map(select(. >= 2)) will give you [2,3].
#
#  endswith(str)
# Outputs true if . ends with the given string argument.
#######
# curl - How To Use
# https://curl.haxx.se/docs/manpage.html
#
# --url <url>
# Specify a URL to fetch. This option is mostly handy when you want to specify URL(s) in a config file.
#######
curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | jq --arg PLATFORM_ARCH "$(echo `uname -s`-`uname -m`)" -r '.assets[] | select(.name | endswith($PLATFORM_ARCH)).browser_download_url' | xargs sudo curl -L -o /usr/local/bin/docker-compose --url
sudo chmod +x /usr/local/bin/docker-compose
cp /usr/local/bin/docker-compose /home/allenyllee/.local/bin/

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

# Proprietary GPU Drivers : "Graphics Drivers" team
# https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa
#
# add ppa repository
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get upgrade -y

# purge all previous version (--purge removes configuration files)
sudo apt-get remove --purge -y nvidia-*

# bash - How do I delete the first n lines of an ascii file using shell commands? - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/37790/how-do-i-delete-the-first-n-lines-of-an-ascii-file-using-shell-commands
#
# apt - How do I search for available packages from the command-line? - Ask Ubuntu
# https://askubuntu.com/questions/160897/how-do-i-search-for-available-packages-from-the-command-line
#
# # get latest version
# old version before nvidia-390
# NVIDIA_VERSION=$(sudo apt-cache search ^nvidia-[0-9]{3}$ | sort | tail -n -1 | cut -d' ' -f1)
# new version after nvidia-driver-390
# Trying to install nvidia driver for ubuntu Desktop 18.04 LTS - Ask Ubuntu
# https://askubuntu.com/questions/1032938/trying-to-install-nvidia-driver-for-ubuntu-desktop-18-04-lts
#
#
if [ $CODENAME == "bionic" ]
then
NVIDIA_VERSION=$(sudo apt-cache search ^nvidia-driver-[0-9]{3}$ | sort | tail -n -1 | cut -d' ' -f1)
else
NVIDIA_VERSION=$(sudo apt-cache search ^nvidia-[0-9]{3}$ | sort | tail -n -1 | cut -d' ' -f1)
fi

# install latest version
sudo apt-get install -y $NVIDIA_VERSION


########
# install CUDA
########
# How can I install CUDA 9 on Ubuntu 17.10 - Ask Ubuntu
# https://askubuntu.com/questions/967332/how-can-i-install-cuda-9-on-ubuntu-17-10

wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run

chmod +x cuda_9.0.176_384.81_linux-run

sudo sh -c './cuda_9.0.176_384.81_linux-run --override --silent --toolkit --samples'

# add CUDA environments in ~/.bashrc
# Add a line to a specific position in a file using Linux sed
# https://www.garron.me/en/linux/add-line-to-specific-position-in-file-linux.html

# .desktop file with .bashrc environment - Ask Ubuntu
# https://askubuntu.com/questions/542152/desktop-file-with-bashrc-environment
#
# When running from a launcher, the idea.sh script is started using a non-iteractive shell.
# In your .bashrc make sure the environment variables are exported before
# # If not running interactively, don't do anything

# escaping - How to escape single quote in sed? - Stack Overflow
# https://stackoverflow.com/questions/24509214/how-to-escape-single-quote-in-sed

# bash - how to smart append LD_LIBRARY_PATH in shell when nounset - Stack Overflow
# https://stackoverflow.com/questions/9631228/how-to-smart-append-ld-library-path-in-shell-when-nounset
#
# You could use this construct:
# ```
# export LD_LIBRARY_PATH=/mypath${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
# ```
# Explanation:
# -   If `LD_LIBRARY_PATH` is not set, then `${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}`
#           expands to nothing without evaluating `$LD_LIBRARY_PATH`, thus the
#           result is equivalent to `export LD_LIBRARY_PATH=/mypath` and no error is raised.
# -   If `LD_LIBRARY_PATH` is already set, then `${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}`
#           expands to `:$LD_LIBRARY_PATH`, thus the result is equivalent to
#           `export LD_LIBRARY_PATH=/mypath:$LD_LIBRARY_PATH`.
#

# 导入tensorflow：ImportError: libcublas.so.9.0: cannot open shared object file: No such file or director - ZeroZone零域的博客 - CSDN博客
# https://blog.csdn.net/ksws0292756/article/details/80034086
#
# 对于tensorflow 1.7版本，只接受cuda 9.0（9.1也不可以！），和cudnn 7.0，所以如果你安装了cuda9.1和cudnn7.1或以上版本，那么你需要重新安装9.0和7.0版本。
# 安装完正确的版本后，确认你在你的~/.bashrc（或者~/.zshrc）文件中加入了下面环境变量
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib64
# export PATH=$PATH:/usr/local/cuda-9.0/bin
# export CUDA_HOME=$CUDA_HOME:/usr/local/cuda-9.0


CUDA_ENV='# add by allen for cuda \x00export PATH="/usr/local/cuda-9.0/bin${PATH:+:$PATH}"\x00export LD_LIBRARY_PATH="/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"\x00export CUDA_HOME="/usr/local/cuda-9.0"'
NONINTERACTIVE='# If not running interactively, don\x27t do anything'

cp ~/.bashrc ~/.bashrc_allen_cuda.bak

tr '\n' '\000' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null
sudo sed -i 's|\x00\x00'"$CUDA_ENV"'\x00\x00'"$NONINTERACTIVE"'\x00|\x00\x00'"$NONINTERACTIVE"'\x00|' ~/.bashrc
tr '\000' '\n' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null
tr '\n' '\000' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null
sudo sed -i 's|\x00\x00'"$NONINTERACTIVE"'\x00|\x00\x00'"$CUDA_ENV"'\x00\x00'"$NONINTERACTIVE"'\x00|' ~/.bashrc
tr '\000' '\n' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null



#######
# install cuDNN
#######
# cuDNN Download | NVIDIA Developer
# https://developer.nvidia.com/rdp/cudnn-download
#######
# The easy way: Install Nvidia drivers, CUDA, CUDNN and Tensorflow GPU on Ubuntu 18.04 - Ask Ubuntu
# https://askubuntu.com/questions/1033489/the-easy-way-install-nvidia-drivers-cuda-cudnn-and-tensorflow-gpu-on-ubuntu-1
#######

wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.4.1.5/prod/9.0_20181108/Ubuntu16_04-x64/libcudnn7_7.4.1.5-1%2Bcuda9.0_amd64.deb
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.4.1.5/prod/9.0_20181108/Ubuntu16_04-x64/libcudnn7-dev_7.4.1.5-1%2Bcuda9.0_amd64.deb

dpkg -i libcudnn7_7.4.1.5-1%2Bcuda9.0_amd64.deb libcudnn7-dev_7.4.1.5-1%2Bcuda9.0_amd64.deb


# Installing Tensorflow GPU on Ubuntu 18.04 LTS – Taylor Denouden – Medium
# https://medium.com/@taylordenouden/installing-tensorflow-gpu-on-ubuntu-18-04-89a142325138

# Install libcupti
sudo apt-get install libcupti-dev

# test tensorflow
python << EOF
from tensorflow.python.client import device_lib
device_lib.list_local_devices()
EOF


######################
# install nvidia docker
# NVIDIA/nvidia-docker: Build and run Docker containers leveraging NVIDIA GPUs
# https://github.com/NVIDIA/nvidia-docker
######################

# stop and remove all containers started with nvidia-docker 1.0.
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge nvidia-docker

# # Repository configuration | nvidia-docker
# # https://nvidia.github.io/nvidia-docker/
# #
# # setup the nvidia-docker repository
# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
#   sudo apt-key add -
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
#   sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# sudo apt-get update



# # Installation (version 2.0) · NVIDIA/nvidia-docker Wiki
# # https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)
# #
# # Install the nvidia-docker2 package and reload the Docker daemon configuration:
# sudo apt-get install -y nvidia-docker2
# sudo pkill -SIGHUP dockerd


# Repository configuration | nvidia-docker
# https://nvidia.github.io/nvidia-docker/
#
# Note that with the release of Docker 19.03,
# usage of nvidia-docker2 packages are deprecated since NVIDIA GPUs
# are now natively supported as devices in the Docker runtime.
#
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker


# test nvidia-smi
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi


# nvidia-docker 1.0 was deprecated
#
# # install nvidia-modprobe
# sudo apt-get install -y nvidia-modprobe

# # Install nvidia-docker and nvidia-docker-plugin
# wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
# sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# # Test nvidia-smi
# nvidia-docker run --rm nvidia/cuda nvidia-smi


#######################
# install nvidia-docker-compose
#######################

# Nvidia-docker2 · Issue #23 · eywalker/nvidia-docker-compose
# https://github.com/eywalker/nvidia-docker-compose/issues/23
#
# using native docker-compose with default runtime: nvidia
#
# the specific runtime can be set in /etc/docker/daemon.json
#
# {
#     "default-runtime": "nvidia",
#     "runtimes": {
#         "nvidia": {
#             "path": "/usr/bin/nvidia-container-runtime",
#             "runtimeArgs": [ ]
#         }
#     }
# }
#
# by using this the docker-compose started to work again, because eliminates the necessity of pass this argument all the time.
#
# Example of nvidia-docker2 with docker-compose · Issue #568 · NVIDIA/nvidia-docker
# https://github.com/NVIDIA/nvidia-docker/issues/568
#
# Add "default-runtime": "nvidia",
#
sudo sed -i 's/    \"runtimes\":/    \"default-runtime\": \"nvidia\",\n    \"runtimes\":/' /etc/docker/daemon.json


# nvidia-docker 1.0 was deprecated
#
# sudo apt-get install -y python-pip
# pip install nvidia-docker-compose

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

######
# install context menu open in VSCode
######
# How to add Open with VS Code context menu in Nautilus · Issue #873 · Microsoft/vscode-docs
# https://github.com/Microsoft/vscode-docs/issues/873
######
# VSCode extension for Nautilus
# https://gist.github.com/cra0zy/f8ec780e16201f81ccd5234856546414
######

# install python-nautilus package
sudo apt-get install -y python-nautilus
# add extension
mkdir -p ~/.local/share/nautilus-python/extensions && cp -f VSCodeExtension.py ~/.local/share/nautilus-python/extensions/VSCodeExtension.py && nautilus -q

####
# Setting VS Code as the default text editor
####
# Running Visual Studio Code on Linux
# https://code.visualstudio.com/docs/setup/linux#_setting-vs-code-as-the-default-text-editor
####
# Set default application using `xdg-mime` | Guy Rutenberg
# https://www.guyrutenberg.com/2018/01/20/set-default-application-using-xdg-mime/
#
# 1. Query the default mime-type associations,
#    Will return the .desktop file associated with the default app to open mp4 files.
#
#       xdg-mime query default video/mp4
#
# 2. To change the default association, you need to specify the desktop
#    file to open files of the specified mime type.
#
#       xdg-mime default vlc.desktop video/mp4
#
# 3. To check the mime-type of a given file, use
#
#       file -ib filename
#
####
xdg-mime default code.desktop text/plain




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

##########
# How do I disable window move with alt + left mouse button in GNOME Shell? - Ask Ubuntu
# https://askubuntu.com/questions/118151/how-do-i-disable-window-move-with-alt-left-mouse-button-in-gnome-shell/118179#118179
##########
# Graphical editor for GSettings/dconf? - Ask Ubuntu
# https://askubuntu.com/questions/15262/graphical-editor-for-gsettings-dconf
##########
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
sudo rm -rf pandoc-*-1-amd64.deb*

# install xelatex for chinese support
sudo apt install -y texlive-xetex


#############
# fonts
#############

# firacode
#  tonsky/FiraCode: Monospaced font with programming ligatures
#  https://github.com/tonsky/FiraCode
sudo apt install -y fonts-firacode

if [ $CODENAME == "xenial" ]
then
./fira_code/install_fira_code.sh
else
sudo apt install -y fonts-firacode
fi



#############
# compare tool
#############

#
# install kdiff3
#
sudo apt install -y kdiff3

#
# install meld
#
sudo apt install -y meld


#########
# git tool
#########

#
# install gitkarken
#
#wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
#sudo dpkg -i gitkraken-amd64.deb
#sudo rm -rf gitkraken-amd64.deb

#
# install smartgit
#
sudo add-apt-repository -y ppa:eugenesan/ppa
sudo apt-get update
sudo apt-get install -y smartgit


# Download Git Client SmartGit
# https://www.syntevo.com/smartgit/download
wget https://www.syntevo.com/smartgit/download?file=smartgit/smartgit-17_1_2.deb
sudo dpkg -i smartgit-*.deb
sudo rm -rf smartgit-*.deb

#
# install git-secret
# http://git-secret.io/
#
echo "deb https://dl.bintray.com/sobolevn/deb git-secret main" | sudo tee -a /etc/apt/sources.list
wget -qO - https://api.bintray.com/users/sobolevn/keys/gpg/public.key | sudo apt-key add -
sudo apt-get update && sudo apt-get install git-secret


#
# git lfs
#

# PPA repo installed to get git >= 1.8.2
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:git-core/ppa

# The curl script below calls apt-get update, if you aren't using it,
# don't forget to call apt-get update before installing git-lfs.
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install



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


#
# install poetry
# sdispater/poetry: Python dependency management and packaging made easy.
# https://github.com/sdispater/poetry
#
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python



###############
# install anaconda
###############
# How To Install the Anaconda Python Distribution on Ubuntu 16.04 | DigitalOcean
# https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-16-04
#
# how to install anaconda / miniconda on Linux silently - Stack Overflow
# https://stackoverflow.com/questions/49338902/how-to-install-anaconda-miniconda-on-linux-silently
###############
curl -O https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
bash Anaconda3-*-Linux-x86_64.sh -b


##############
# jupyter notebook launcher
##############
# How to create a icon on Ubuntu 16.04 desktop that would start a command line app? - Ask Ubuntu
# https://askubuntu.com/questions/812017/how-to-create-a-icon-on-ubuntu-16-04-desktop-that-would-start-a-command-line-app
#
# launcher - How to handle jupyter notebook files in Ubuntu? - Ask Ubuntu
# https://askubuntu.com/questions/848350/how-to-handle-jupyter-notebook-files-in-ubuntu
#
##############
# .desktop file with .bashrc environment - Ask Ubuntu
# https://askubuntu.com/questions/542152/desktop-file-with-bashrc-environment
#
# to source ~/.bashrc, just change .desktop Exec= from
#     bash -c "~/anaconda3/bin/jupyter notebook --notebook-dir=~/"
# to
#     bash -c "source ~/.bashrc && ~/anaconda3/bin/jupyter notebook --notebook-dir=~/"
##############
sudo wget https://cdn.rawgit.com/jupyter/design/121ca202/logos/Square%20Logo/squarelogo-greytext-orangebody-greymoons/squarelogo-greytext-orangebody-greymoons.svg -O /usr/share/icons/squarelogo-greytext-orangebody-greymoons.svg
cp ./launcher/jupyter.desktop ~/.local/share/applications/

#####
# python - Ipython Notebook: where is jupyter_notebook_config.py in Mac? - Stack Overflow
# https://stackoverflow.com/questions/32625939/ipython-notebook-where-is-jupyter-notebook-config-py-in-mac
#####
# create jupyter_notebook_config.py
#jupyter notebook --generate-config


# copy jupyter_notebook_config.py to ~/.jupyter/
cp ./jupyter/jupyter_notebook_config.py ~/.jupyter/




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
if [ $CODENAME == "bionic" ]
then
# remove offical ppa first
sudo add-apt-repository -r ppa:i-nex-development-team/stable
# for ubuntu 18.04 (unoffical)
# I-Nex PPA for Ubuntu 18/Mint 19? · Issue #89 · i-nex/I-Nex
# https://github.com/i-nex/I-Nex/issues/89
sudo add-apt-repository -y ppa:trebelnik-stefina/i-nex
# i-nex depends on gambas3
sudo add-apt-repository -y ppa:gambas-team/gambas3
else
# for ubuntu 16.04 (offical)
sudo add-apt-repository -y ppa:i-nex-development-team/stable
fi

sudo apt-get update
sudo apt-get install -y i-nex

if [ $CODENAME == "bionic" ]
then
# add sym link libcpuid.so.14.0.0 -> libcpuid.so.14.0.1
sudo ln -s ./libcpuid.so.14.0.1 ./libcpuid.so.14.0.0
fi


# Hardinfo
sudo apt-get install -y hardinfo

# Sysinfo
sudo apt-get install -y sysinfo

# lshw-gtk
sudo apt-get install -y lshw-gtk

# KInfoCenter
sudo apt-get install -y kinfocenter

########################
#
# power management tools
#
########################


#########
# install tlp
#########
# software recommendation - Is there a power saving application similar to Jupiter? - Ask Ubuntu
# https://askubuntu.com/questions/285434/is-there-a-power-saving-application-similar-to-jupiter
########
sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install -y tlp tlp-rdw smartmontools ethtool

# Removing default Ubuntu cpu frequency config
sudo update-rc.d -f ondemand remove

# The main config file of TLP is at /etc/default/tlp
#  sudo -i gedit /etc/default/tlp
sudo cp ./tlp_conf/tlp /etc/default/tlp

# start tlp
sudo tlp start

# install indicator-cpufreq
sudo apt-get install -y indicator-cpufreq

# add to autostart
sudo -u $USER_NAME bash <<EOF
cp "./autostart/CPU frequency Scaling Indicator.desktop" ~/.config/autostart
EOF

# PowerSavingTweaks for Intel Graphics
#
# Kernel/PowerManagement/PowerSavingTweaks - Ubuntu Wiki
# https://wiki.ubuntu.com/Kernel/PowerManagement/PowerSavingTweaks
#
# This gist will show you how to tune your Intel-based Skylake, Kabylake and beyond Integrated Graphics Core for performance and reliability through GuC and HuC firmware usage on Linux.
# https://gist.github.com/Brainiarc7/aa43570f512906e882ad6cdd835efe57
#
# Intel graphics (简体中文) - ArchWiki
# https://wiki.archlinux.org/index.php/Intel_graphics_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)
#
# linux kernel - Setting CPU governor to on demand or conservative - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/121410/setting-cpu-governor-to-on-demand-or-conservative
#
# 实现面向 Intel Core（SandyBridge 和更新的型号）处理器的调频驱动。
# https://wiki.archlinux.org/index.php/CPU_frequency_scaling_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)
#
sudo sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash\"|GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash intel_pstate=disable i915.lvds_downclock=1 drm.vblankoffdelay=1 i915.semaphores=1 i915_enable_rc6=1 i915_enable_fbc=1\"|' /etc/default/grub
sudo update-grub


#####
# install powertop
#####
# PowerManagement/ReducedPower - Community Help Wiki
# https://help.ubuntu.com/community/PowerManagement/ReducedPower
#####
sudo apt install -y powertop

#####
# install startup application
#####
sudo apt install -y gnome-startup-application


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


############
# Disk space, IO, partition format
############

#
# linux - What Process is using all of my disk IO - Stack Overflow
# https://stackoverflow.com/questions/488826/what-process-is-using-all-of-my-disk-io
#
sudo apt-get install -y iotop

#
# disk space analyzer
#
sudo apt-get install -y Baobab

#
# Alternative to CrystalDiskInfo
#
sudo apt-get install -y gsmartcontrol


#
# support btrfs
#
# usage:
#   create loop device for btrfs & mount to /mnt/btrfs_dsk:
#       truncate -s100G 100GB.btrfs.img
#       ld=$(sudo losetup --show --find 100GB.btrfs.img); echo "$ld"
#       sudo mkfs -t btrfs -f "$ld"
#       sudo mkdir -p /mnt/btrfs_dsk
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd "$ld" /mnt/btrfs_dsk
#   or
#       truncate -s100G 100GB.btrfs.img
#       sudo mkfs -t btrfs -f 100GB.btrfs.img
#       sudo mkdir -p /mnt/btrfs_dsk
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd 100GB.btrfs.img /mnt/btrfs_dsk
#
#   create subvol Dataset & Snapshot:
#       sudo btrfs subvolume create /mnt/btrfs_dsk/Dataset
#       sudo btrfs subvolume create /mnt/btrfs_dsk/Snapshot
#       sudo mkdir -p /mnt/Dataset /mnt/Snapshot
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd,subvol=Dataset "$ld" /mnt/Dataset
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd,subvol=Snapshot "$ld" /mnt/Snapshot
#       sudo umount /mnt/btrfs_dsk
#       sudo rm -r /mnt/btrfs_dsk
#   or
#       sudo btrfs subvolume create /mnt/btrfs_dsk/Dataset
#       sudo btrfs subvolume create /mnt/btrfs_dsk/Snapshot
#       sudo mkdir -p /mnt/Dataset /mnt/Snapshot
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd,subvol=Dataset 100GB.btrfs.img /mnt/Dataset
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd,subvol=Snapshot 100GB.btrfs.img /mnt/Snapshot
#       sudo umount /mnt/btrfs_dsk
#       sudo rm -r /mnt/btrfs_dsk
#
#   create read only (-r) snapshot for Dataset:
#       sudo btrfs subvolume snapshot -r /mnt/Dataset /mnt/Snapshot/Dataset-`date +%Y%m%d-%H%M`
#
#   delete snapshot of Dataset:
#       sudo btrfs subvolume delete /mnt/Snapshot/Dataset-20180809-1303
#
#   defrag & compress:
#       btrfs filesystem defragment -r -czstd /mnt/Dataset
#
#   show subvolume info:
#       sudo btrfs subvolume list -a .
#
#   /etc/fstab:
#       /media/allenyl/DATA_SSD/Projects_SSD/100GB.btrfs.img  /mnt/Dataset    btrfs   rw,user,noatime,ssd,space_cache,compress=zstd,subvol=/Dataset   0       0
#       /media/allenyl/DATA_SSD/Projects_SSD/100GB.btrfs.img  /mnt/Snapshot    btrfs   rw,user,noatime,ssd,space_cache,compress=zstd,subvol=/Snapshot   0       0
#
#   backup image & change uuid (to prevent confilct):
#       cp /media/allenyl/DATA_SSD/Projects_SSD/100GB.btrfs.img /media/allenyl/DATA/Projects/server_setup/repo-ai/NLP-AI-in-Law/tw_law_dataset/100GB.2.btrfs.img
#       sudo btrfstune -u /media/allenyl/DATA/Projects/server_setup/repo-ai/NLP-AI-in-Law/tw_law_dataset/100GB.2.btrfs.img
#
#   send & receive:
#       sudo mkdir -p /mnt/tmp
#       sudo mount -o rw,user,noatime,space_cache,compress=zstd,subvol=Snapshot /media/allenyl/DATA/Projects/server_setup/repo-ai/NLP-AI-in-Law/tw_law_dataset/100GB.2.btrfs.img /mnt/tmp
#       sudo btrfs subvolume snapshot -r /mnt/Dataset /mnt/Snapshot/Dataset-`date +%Y%m%d-%H%M` && sync
#       sudo btrfs send /mnt/Snapshot/Dataset-20180809-1936/ | sudo btrfs receive /mnt/tmp

#
#############
# How to set a non default zstd compression level at btrfs filesystem defragment? - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/412480/how-to-set-a-non-default-zstd-compression-level-at-btrfs-filesystem-defragment
#
# Compression - btrfs Wiki
# https://btrfs.wiki.kernel.org/index.php/Compression
#
# The level support of ZLIB has been added in v4.14, LZO does not support levels (the kernel implementation provides only one), ZSTD level support is planned.
#
#
sudo apt install btrfs-progs

#
# install snapper
#
sudo apt install snapper



#
# system backup job: install duplicity
#
sudo apt install duplicity


#
# add swappiness
#
echo vm.swappiness=80 | sudo tee /etc/sysctl.d/99-sawapness.conf && sudo sysctl -p --system

# show current value
cat /proc/sys/vm/swappiness
sysctl vm.swappiness

# #
# # add inotify max_user_watches
# #
# echo fs.inotify.max_user_watches=100000 | sudo tee /etc/sysctl.d/99-max_user_watches.conf && sudo sysctl -p --system

# # show current value
# cat /proc/sys/fs/inotify/max_user_watches
# sysctl fs.inotify.max_user_watches


###########
# screen, display
###########

#
# install redshift
#
sudo apt-get install -y redshift-gtk

# copy redshift settings
cp ./redshift.conf ~/.config/



#####################
# install CopyQ
#####################
sudo add-apt-repository -y ppa:hluk/copyq
sudo apt update
sudo apt install -y copyq


#################
# install telegram
#################
sudo add-apt-repository -y ppa:atareao/telegram
sudo apt-get update
sudo apt-get install -y telegram
ln -s /opt/telegram/telegram /usr/local/bin

################
# install ultracopier
################
# sudo apt-get install ultracopier

# sudo -u $USER_NAME bash <<EOF
# cp ./autostart/ultracopier.desktop ~/.config/autostart/
# EOF


############
# install pv
############

sudo apt install -y pv



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
sudo rm -rf pdfsam_*-1_all.deb*


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
sudo apt-get install -y p7zip-full

#
# install unrar
#
# compression - What's the easiest way to unrar a file? - Ask Ubuntu
# https://askubuntu.com/questions/41791/whats-the-easiest-way-to-unrar-a-file
sudo apt-get install -y unrar



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

###################
##############
# network tools
##############
###################

####################
# install bitmeteros
####################
# linux - How to wget a file with correct name when redirected? - Super User
# https://superuser.com/questions/301044/how-to-wget-a-file-with-correct-name-when-redirected
#
# software installation - How do I install a .deb file via the command line? - Ask Ubuntu
# https://askubuntu.com/questions/40779/how-do-i-install-a-deb-file-via-the-command-line
####################
wget -N --content-disposition https://codebox.net/downloads/bitmeteros/linux64/080
sudo dpkg -i bitmeteros_*-amd64.deb
sudo rm -rf bitmeteros_*-amd64.deb*

# HOW TO USE BITMETEROS:-
# BitMeter comprises of two items; a 'daemon' that runs continuously in the background, monitoring which ever network interface you're connected to, and a web interface, by means of which you view the information collected. This makes sense, in fact, since most data usage tends to be incurred in your browser anyway. It's set to auto-start at boot by default.
# When it's installed, go into your browser, and enter the following into the address bar:-
#
# http://localhost:2605/index.html
#
# 如果發現完全沒有流量資訊，可以嘗試bmdb capstop 再 bmdb capstart


#########
# install net tools (includes netstat)
#########

sudo apt install -y net-tools

#########
# install autossh
#########

sudo apt install -y autossh

#########
# install sshpass
#########

sudo apt install sshpass

############################
# install ssh server
# will generate /etc/ssh/sshd_config
############################
sudo apt-get install -y openssh-server

# install sshfs
sudo apt-get install -y sshfs

# download & install VirtualGL
VIRTUALGL_VERSION=2.5.2
curl -sSL https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb -o virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb && \
    dpkg -i virtualgl_*_amd64.deb && \
    rm virtualgl_*_amd64.deb


###############
# install google chrome
###############
# UbuntuUpdates - PPA: Google Chrome
# https://www.ubuntuupdates.org/ppa/google_chrome
#
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable


###############
# install deludge: the BT client
###############
# Plugins – Deluge
# https://dev.deluge-torrent.org/wiki/Plugins#InstallingPluginEggs
###############
sudo add-apt-repository -y ppa:deluge-team/ppa
sudo apt-get update
sudo apt-get install deluge

# install LabelPlus plugin
#cp ~/Projects/server_setup/ubuntu_setup/deludge/plugins/LabelPlus-0.3.2.2-py2.7.egg ~/.config/deluge/plugins/

# install .desktop file
./deluge/install_policy.sh


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
sudo -u $USER_NAME bash <<EOF
cp ./autostart/com.github.wwmm.pulseeffects.desktop ~/.config/autostart/
EOF

#
# command line - Running a .desktop file in the terminal - Ask Ubuntu
# https://askubuntu.com/a/577819
#
# jceb/dex: DesktopEntry Execution
# https://github.com/jceb/dex
#
sudo apt-get install -y dex
dex ./com.github.wwmm.pulseeffects.desktop

#
# install GUVCView for webcam record
#
# webcam - Anything better than Cheese for video capture? - Ask Ubuntu
# https://askubuntu.com/questions/186003/anything-better-than-cheese-for-video-capture
#
sudo add-apt-repository -y ppa:pj-assis/ppa
sudo apt-get update -y
sudo apt-get install -y guvcview

#
# install v4l-utils in order to get list of all camara (webcam)
#
# v4l-utils
# https://stackoverflow.com/questions/4290834/how-to-get-a-list-of-video-capture-devices-web-cameras-on-linux-ubuntu-c
#
sudo apt-get install -y v4l-utils
v4l2-ctl --list-devices

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


###################
# install grub-customizer
###################
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
sudo apt-get update
sudo apt-get install -y grub-customizer


################
# install nautilus-admin
################
# How do I start Nautilus as root? - Ask Ubuntu
# https://askubuntu.com/questions/156998/how-do-i-start-nautilus-as-root
################
sudo apt install nautilus-admin

# kill nautilus
nautilus -q


###################
# install gnome-tweak-tool
###################
# How to Install Themes in Ubuntu 18.04 and 17.10 | It's FOSS
# https://itsfoss.com/install-themes-ubuntu/
###################
sudo apt install gnome-tweak-tool
# install GNOME Shell Extensions
sudo apt install gnome-shell-extensions

##############
# install communitheme
##############
# How to Install The New Ubuntu Community Theme “Yaru” | It's FOSS
# https://itsfoss.com/ubuntu-community-theme/
sudo snap install communitheme


##############
# Nautilus launcher
##############
cp ./launcher/nautilus.desktop ~/.local/share/applications/



###############
# install xdotool
###############
# linux - Kill the currently active window with a keyboard shortcut - Super User
# https://superuser.com/questions/757160/kill-the-currently-active-window-with-a-keyboard-shortcut
#
# xdotool getwindowfocus windowkill
#
###############
sudo apt install -y xdotool


##########
# command line - How to set custom keyboard shortcuts from terminal? - Ask Ubuntu
# https://askubuntu.com/questions/597395/how-to-set-custom-keyboard-shortcuts-from-terminal
##########

# set keyboard shortcut
KET_NAME="killwindow"
KEY_LIST=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$KET_NAME/"

NEW_BIND=`echo "$KEY_LIST" | sed -e"s%'\]%','$KEY_PATH']%" | sed -e"s%@as \[\]%['$KEY_PATH']%"`

echo $NEW_BIND

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_BIND"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH name "$KET_NAME"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH command 'xdotool getwindowfocus windowkill'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH binding '<Primary><Alt>x'


########
# set ctrl+shift as input layout switch
########
# 18.04 ctrl+shift to change language - Ask Ubuntu
# https://askubuntu.com/questions/1029588/18-04-ctrlshift-to-change-language
#
# ubuntu16.4 修改菜單到下方 錯誤：GLib-GIO-Message: Using the 'memory' GSettings backend. Your settings will not be saved or shared with other applications. - 掃文資訊
# https://hk.saowen.com/a/ebbd364855b4987bcf2718a46b5045fb246b6ef0f5b72c5c8278e63bc09dd959


export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:rctrl_rshift_toggle']" # right-ctrl + right-shift


# 17.10 - Switching between windows with scroll wheel on Ubuntu Dock - Ask Ubuntu
# https://askubuntu.com/questions/966887/switching-between-windows-with-scroll-wheel-on-ubuntu-dock

gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'

# How do I enable 'minimize on click' on Ubuntu dock in Ubuntu 17.10 and 18.04? - Ask Ubuntu
# https://askubuntu.com/questions/960074/how-do-i-enable-minimize-on-click-on-ubuntu-dock-in-ubuntu-17-10-and-18-04

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-overview'

##########
# Powerline shell
##########
# b-ryan/powerline-shell: A beautiful and useful prompt for your shell
# https://github.com/b-ryan/powerline-shell
######
# will hang on bit git directory...
##################
# POWERLINE_ENV='# added by powerline-shell\nfunction _update_ps1() {\n    PS1=$(powerline-shell $?)\n}\n\nif [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then\n    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"\nfi'
# POWERLINE_regex='# added by powerline-shell\x00function _update_ps1.*PROMPT_COMMAND"\x00fi'

# cp ~/.bashrc ~/.bashrc_allen_powerline.bak

# # remove previous POWERLINE setting
# tr '\n' '\000' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null
# sudo sed -i 's|\x00\x00'"$POWERLINE_regex"'\x00|\x00|' ~/.bashrc
# tr '\000' '\n' < ~/.bashrc | sudo tee ~/.bashrc >/dev/null

# # append POWERLINE setting
# printf "\n$POWERLINE_ENV\n" | sudo tee -a ~/.bashrc >>/dev/null


##########
# install deepin-screenshot
##########
#
# Deepin_Screenshot - deepin Wiki
# https://wiki.deepin.org/index.php?title=Deepin_Screenshot&language=en#Save_Screenshot
#
# -   Select auto_save to save the image under the system default picture folder.
# -   Select save_to_desktop to save the picture to desktop.
# -   Select save_to_dir to save the picture to your specified storage directory.
# -   Select save_ClipBoard to copy the picture to the clipboard.
# -   Select auto_save_ClipBoard to save the picture in the system default picture folder and copy it to the clipboard.
# -   Adjust the quality of the saved pictures by dragging the slider left or right.
##########

sudo apt install -y deepin-screenshot

# set keyboard shortcut
export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/
KET_NAME="deepin-screenshot"
KEY_LIST=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$KET_NAME/"

NEW_BIND=`echo "$KEY_LIST" | sed -e"s%'\]%','$KEY_PATH']%" | sed -e"s%@as \[\]%['$KEY_PATH']%"`

echo $NEW_BIND

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_BIND"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH name "$KET_NAME"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH command 'deepin-screenshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$KEY_PATH binding 'F1'




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

#bash ./run_services.sh "$PROJECT_DIR"

######################
# TODO: add backup job
######################


##############
# remove useless packages
##############
sudo apt list --upgradable
sudo apt upgrade -y
sudo apt autoremove -y
