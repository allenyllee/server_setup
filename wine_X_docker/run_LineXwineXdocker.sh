#/bin/bash

nvidia-docker run \
        -ti \
        --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /media/allenyllee/Project/Wine_drive:/home/wineXdocker/Wine_drive \
        --entrypoint /bin/bash \
        wine_x_docker \
        -c "Line"