#!/bin/bash

docker build -t glxgears - << EOF
FROM nvidia/cudagl:9.0-devel-ubuntu16.04  `# support OpenGL`
RUN apt-get update
RUN apt-get install -y mesa-utils `# for glxgears` \
                        x11-apps `# for xeyes` \
                        wget `# for download file`

RUN apt-get install -y glmark2 `# for GPU benchmark` \
                        lshw `# for lshw` \
                        lsb-release `# for lsb_release` \
                        software-properties-common python-software-properties `# for add-apt-repository ` \
                        libvulkan1 vulkan-utils `# for vulkan` \
                        libalut-dev `# for openal audio libaray` \
                        xorg-dev `# avoid error while loading shared libraries: libXrandr.so.2`\
                        libcurl3 `# avoid error while loading shared libraries: libcurl.so.4`

########
# install Vulkan SDK
########

RUN wget -O VulkanSDK.run https://sdk.lunarg.com/sdk/download/1.0.61.0/linux/vulkansdk-linux-x86_64-1.0.61.0.run?Human=true;u= && \
    chmod ugo+x VulkanSDK.run

RUN ./VulkanSDK.run
RUN cd VulkanSDK/1.0.61.0
ENV VULKAN_SDK="/VulkanSDK/1.0.61.0/x86_64:\${VULKAN_SDK}" `# need to escape $ if you pass from shell script`
ENV PATH="\${VULKAN_SDK}/bin:\${PATH}"
ENV LD_LIBRARY_PATH="\${VULKAN_SDK}/lib:\${LD_LIBRARY_PATH}"
ENV VK_LAYER_PATH="\${VULKAN_SDK}/etc/explicit_layer.d:\${VK_LAYER_PATH}"

#ENV QT_X11_NO_MITSHM=1 `# avoid BadDrawable (invalid Pixmap or Window parameter) issue without MIT-SHM performance`

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
    --env="PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native" `# for pulse audio backend`\
    --volume=${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native `# for pulse audio backend` \
    --device /dev/snd:/dev/snd `# for sound device`\
    --ipc host `# avoid BadDrawable (invalid Pixmap or Window parameter) issue: with MIT-SHM performance`\
    --volume="/test:/test" \
    glxgears bash