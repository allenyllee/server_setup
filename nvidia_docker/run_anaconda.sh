#!/bin/bash

####################
# Enter the password you want as the argument of this script
####################
# first time start:
#   if you enter a password, system will create the conteiner
#   if you left it blank, system will create the container without password (must use login token)
# second time and ever:
#   if you enter a different password, system wil recreate the container
#   if you left it blank, system will just start old container
####################
if [ -z $1 ]
then
    COMMAND="nvidia-docker-compose up --no-recreate anaconda"
else
    COMMAND="PSWD=$1 nvidia-docker-compose up anaconda"
fi

xhost local:root

# create new terminal window to run COMMAND
echo $COMMAND
gnome-terminal -e "bash -c \"$COMMAND;exec bash\""

##docker run -i -t \
##    -p 8889:8888 \
##    continuumio/anaconda3 \
##    /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook  --allow-root --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
