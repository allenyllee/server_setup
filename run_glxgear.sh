#!/bin/bash

docker build -t glxgears - << EOF
FROM nvidia/cudagl:9.0-devel-ubuntu16.04
RUN apt-get update
RUN apt-get install -y mesa-utils x11-apps
RUN apt-get update && \
    apt-get install -y cmake && \
    apt-get install -y xorg-dev libglu1-mesa-dev --fix-missing && \
    apt-get install -y wget && \
    `# apt-get install -y assimp-utils &&` \
    `# apt-get install -y libassimp-dev &&` \
    apt-get install -y libglfw3-dev && \
    `# apt-get install -y libboost-all-dev &&` \
    apt-get install -y git

RUN wget -O VulkanSDK.run https://sdk.lunarg.com/sdk/download/1.0.61.0/linux/vulkansdk-linux-x86_64-1.0.61.0.run?u= && \
    chmod ugo+x VulkanSDK.run

RUN ./VulkanSDK.run
RUN cd VulkanSDK/1.0.61.0
ENV VULKAN_SDK="/VulkanSDK/1.0.61.0/x86_64:${VULKAN_SDK}"
ENV PATH="${VULKAN_SDK}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${VULKAN_SDK}/lib:${LD_LIBRARY_PATH}"
ENV VK_LAYER_PATH="${VULKAN_SDK}/etc/explicit_layer.d:${VK_LAYER_PATH}"

RUN apt-get install -y glmark2 \
                        lshw `# for lshw` \
                        lsb-release `# for lsb_release` \
                        software-properties-common python-software-properties `# for add-apt-repository ` \
                        libvulkan1 mesa-vulkan-drivers vulkan-utils `# for vulkan` \

ENV QT_X11_NO_MITSHM=1 `# avoid BadDrawable (invalid Pixmap or Window parameter) issue when execute Unigine_Heaven-4.0`

CMD export LIBGL_DEBUG=verbose && glxgears
EOF

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

nvidia-docker run -ti --rm \
    --volume=$XSOCK:$XSOCK \
    --volume=$XAUTH_DIR:$XAUTH_DIR \
    --env="DISPLAY=$DISPLAY" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="/test:/test" \
    glxgears bash