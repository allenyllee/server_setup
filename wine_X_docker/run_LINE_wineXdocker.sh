#/bin/bash

nvidia-docker run \
        -d \
        -ti \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /media/allenyllee/Project/Wine_drive:/home/wineXdocker/Wine_drive \
        --name LINE \
        --entrypoint /bin/bash \
        wine_x_docker \
        -c "Line"