#!/bin/bash

##
## linux - how to mount local directory to remote like sshfs? - Super User 
## https://superuser.com/questions/616182/how-to-mount-local-directory-to-remote-like-sshfs
##

LOCAL_USER=$(whoami)
REMOTE_USER="root"

LOCAL_DIR="/media/$LOCAL_USER/Project/Project/server_setup/nvidia_docker/project"
REMOTE_DIR="./project2"

LOCAL_ADDR="localhost"
REMOTE_ADDR="10.1.53.168"

LOCAL_PORT="22"
FORWARD_PORT="10000"
REMOTE_PORT="88"

LOCAL_SSH="-p $FORWARD_PORT $LOCAL_USER@$LOCAL_ADDR"
REMOTE_SSH="-p $REMOTE_PORT $REMOTE_USER@$REMOTE_ADDR"

SSHFS_OPTION="-o NoHostAuthenticationForLocalhost=yes"

###############
## With ssh, how can you run a command on the remote machine without exiting? - Super User 
## https://superuser.com/questions/261617/with-ssh-how-can-you-run-a-command-on-the-remote-machine-without-exiting
##
## Here I use -t to force the allocation of a pseudo-terminal, which is required for an interactive shell. 
## Then I execute two commands on the server: first the thing I wanted to do prior to opening the interactive shell 
## (in my case, changing directory to a specific folder), and then the interactive shell itself. 
## bash sees that it has a pseudo-terminal and responds interactively.
##
###############
## Why does an SSH remote command get fewer environment variables then when run manually? - Stack Overflow 
## https://stackoverflow.com/questions/216202/why-does-an-ssh-remote-command-get-fewer-environment-variables-then-when-run-man
##
## sourcing the profile before running the command
## ssh user@host "source /etc/profile; /path/script.sh"
##
## usage:
## ssh -t -p 88 root@10.1.53.168 -R 10000:localhost:22 \
## "source /etc/profile; sshfs  -p 10000 allenyllee@localhost:/media/allenyllee/Project/Project/server_setup/nvidia_docker/project ./project2;bash"
###############
ssh -t $REMOTE_SSH -R $FORWARD_PORT:localhost:$LOCAL_PORT \
"source /etc/profile; sshfs $SSHFS_OPTION $LOCAL_SSH:$LOCAL_DIR $REMOTE_DIR; bash"

