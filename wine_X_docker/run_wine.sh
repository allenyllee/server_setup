#/bin/bash

#docker run \
#        -ti \
#        --rm \
#        -e DISPLAY=$DISPLAY \
#        -v /tmp/.X11-unix:/tmp/.X11-unix \
#        -v /media/allenyllee/Project/Wine_drive:/home/xclient/drive_d \
#        --entrypoint /bin/bash \
#        suchja/wine \
#        -c "wine wineboot --init;wine notepad.exe;bash"

#docker run \
#        -ti \
#        --rm \
#        -e DISPLAY=$DISPLAY \
#        -v /tmp/.X11-unix:/tmp/.X11-unix \
#        -v /media/allenyllee/Project/Wine_drive:/home/xclient/drive_d \
#        --entrypoint /bin/bash \
#        thawsystems/wine-stable \
#        -c "wine wineboot --init;wine notepad.exe;bash"

#docker run -it -e DISPLAY=$DISPLAY \
#-v /tmp/.X11-unix:/tmp/.X11-unix \
#-v $HOME/.Xauthority:/root/.Xauthority \
#--name qq lijianying10/wineqq /bin/bash

#docker run -ti --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=${DISPLAY} --entrypoint /bin/bash jamesnetherton/wine -c "calc.exe;bash"

#mkdir -p $HOME/.wine
#_USER=ubuntu

#docker run -ti --rm \
#-e DISPLAY=$DISPLAY \
#-v /tmp/.X11-unix:/tmp/.X11-unix \
#-v $HOME/.wine:/home/$_USER/.wine \
#--entrypoint /bin/bash \
#tagplus5/wine \
#-c "wine notepad.exe;bash"

#xhost +si:localuser:$(whoami) >/dev/null
#docker run \
#    --privileged \
#    --rm \
#    -ti \
#    -e DISPLAY=$DISPLAY \
#    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
#    -v ~/docker-data/wine:/home/docker/wine/ \
#    -v /etc/localtime:/etc/localtime:ro \
#    -u docker \
#    yantis/wine /bin/bash -c "sudo initialize-graphics >/dev/null 2>/dev/null; vglrun /home/docker/templates/skype.template;bash"

#docker run \
#        -ti \
#        --rm \
#        -e DISPLAY=$DISPLAY \
#        -v /tmp/.X11-unix:/tmp/.X11-unix \
#        -v /media/allenyllee/Project/Wine_drive:/home/xclient/drive_d \
#        --entrypoint /bin/bash \
#        twlsw/wine \
#        -c "wine wineboot --init;wine notepad.exe;bash#

nvidia-docker run \
        -ti \
        --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /media/allenyllee/Project/Wine_drive:/home/wineXdocker/Wine_drive \
        --entrypoint /bin/bash \
        wine_x_docker \
        -c "wine wineboot --init;wine notepad.exe;bash"