#!/bin/bash

##
## linux - how to mount local directory to remote like sshfs? - Super User 
## https://superuser.com/questions/616182/how-to-mount-local-directory-to-remote-like-sshfs
##

LOCAL_USER=$(whoami)
REMOTE_USER="root"

LOCAL_DIR="/media/$LOCAL_USER/Project/Project"
REMOTE_DIR="./project2"

LOCAL_ADDR="localhost"
REMOTE_ADDR="10.1.53.168"

LOCAL_PORT="22"
FORWARD_PORT="10000"
REMOTE_PORT="88"

LOCAL_SSH="-p $FORWARD_PORT $LOCAL_USER@$LOCAL_ADDR"
REMOTE_SSH="-p $REMOTE_PORT $REMOTE_USER@$REMOTE_ADDR"

SSHFS_OPTION="-o NoHostAuthenticationForLocalhost=yes"

##
## With ssh, how can you run a command on the remote machine without exiting? - Super User 
## https://superuser.com/questions/261617/with-ssh-how-can-you-run-a-command-on-the-remote-machine-without-exiting
##
## Here I use -t to force the allocation of a pseudo-terminal, which is required for an interactive shell. 
## Then I execute two commands on the server: first the thing I wanted to do prior to opening the interactive shell 
## (in my case, changing directory to a specific folder), and then the interactive shell itself. 
## bash sees that it has a pseudo-terminal and responds interactively.
##
ssh -t $REMOTE_SSH -R $FORWARD_PORT:localhost:$LOCAL_PORT \
"sshfs $SSHFS_OPTION $LOCAL_SSH:$LOCAL_DIR $REMOTE_DIR;bash"


