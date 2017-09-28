#!/bin/bash
COMMAND="nvidia-docker-compose up tensorflow"

xhost local:root

# create new terminal window to run COMMAND
echo $COMMAND
gnome-terminal -e "bash -c \"$COMMAND;exec bash\""
