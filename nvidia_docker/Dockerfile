    # CUDA 8.0
    #
    # VERSION               0.0.1

    FROM      nvidia/cuda:8.0-devel-ubuntu16.04
    MAINTAINER allencat "allencat.lee@liteon.com"

    ##
    ## Ubuntu - Packages - Search
    ## https://packages.ubuntu.com/search?suite=xenial&section=all&arch=amd64&searchon=contents&keywords=Search
    ##
    
    ###
    ### solve for
    ### >>> WARNING - libGL.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - libX11.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - Xlib.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - gl.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ###
    ### 2_Graphics/volumeFiltering
    ### 2_Graphics/simpleGL
    ### 2_Graphics/bindlessTexture
    ### 2_Graphics/volumeRender
    ### 2_Graphics/Mandelbrot
    ### 2_Graphics/marchingCubes
    ### 2_Graphics/simpleTexture3D
    ### 3_Imaging/imageDenoising
    ### 3_Imaging/recursiveGaussian
    ### 3_Imaging/simpleCUDA2GL
    ### 3_Imaging/postProcessGL
    ### 3_Imaging/bicubicTexture
    ### 3_Imaging/boxFilter
    ### 3_Imaging/SobelFilter
    ### 3_Imaging/cudaDecodeGL
    ### 3_Imaging/bilateralFilter
    ### 5_Simulations/particles
    ### 5_Simulations/smokeParticles
    ### 5_Simulations/oceanFFT
    ### 5_Simulations/fluidsGL
    ### 5_Simulations/nbody
    ### 6_Advanced/FunctionPointers
    ### 7_CUDALibraries/randomFog
    ###
    RUN apt update && apt -y install libgl1-mesa-dev

    ###
    ### solve for
    ### >>> WARNING - libGLU.so not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### >>> WARNING - glu.h not found, refer to CUDA Getting Started Guide for how to find and install them. <<<
    ### 
    RUN apt update && apt -y install libglu1-mesa-dev

    ###
    ### solve for
    ### /usr/bin/ld: cannot find -lglut
    ### https://stackoverflow.com/questions/15064159/usr-bin-ld-cannot-find-lglut
    ###
    RUN apt update && apt -y install freeglut3-dev

    ### 
    ### solve for
    ### >>> WARNING - egl.h not found, please install egl.h <<<
    ### >>> WARNING - eglext.h not found, please install eglext.h <<<
    ### >>> WARNING - gl31.h not found, please install gl31.h <<<
    ###
    ### 2_Graphics/simpleGLES_EGLOutput
    ### 2_Graphics/simpleGLES
    ### 2_Graphics/simpleGLES_screen
    ### 5_Simulations/nbody_opengles
    ### 5_Simulations/fluidsGLES
    ### 5_Simulations/nbody_screen
    ###
    RUN apt update && apt -y install libgles2-mesa-dev


    ###
    ### Also search and replace all 'UBUNTU_PKG_NAME = "nvidia-367"' to 'UBUNTU_PKG_NAME = "nvidia"' under NVIDIA_CUDA-8.0_Samples folder
    ###
    RUN mkdir /usr/lib/nvidia && \
        ### solve for  /usr/bin/ld: cannot find -lnvcuvid \
        ### 3_Imaging/cudaDecodeGL \
        ln -s /usr/local/nvidia/lib64/libnvcuvid.so.1 /usr/lib/nvidia/libnvcuvid.so && \
        ### solve for >>> WARNING - libEGL.so not found, please install libEGL.so <<< \
        ### 3_Imaging/EGLStreams_CUDA_Interop \
        ln -s /usr/local/nvidia/lib64/libEGL.so.1 /usr/lib/nvidia/libEGL.so && \
        ### solve for >>> WARNING - libGLES.so not found, please install libGLES.so <<< \
        ### 2_Graphics/simpleGLES_EGLOutput \
        ### 2_Graphics/simpleGLES \
        ### 2_Graphics/simpleGLES_screen \
        ### 5_Simulations/nbody_opengles \
        ### 5_Simulations/fluidsGLES \
        ### 5_Simulations/nbody_screen \
        ln -s /usr/local/nvidia/lib64/libGLESv2_nvidia.so.2 /usr/lib/nvidia/libGLESv2.so




    # install & start sshd server
    # for ssh login & X11 forward use
    #RUN yum -y install openssh-server.x86_64
    # first start to preserve all SSH host keys
    #RUN service sshd start
    #

	
    # install toolchain enviroment for xtensa xplorer-7.0.4
    #RUN yum -y install gcc
    #RUN yum -y install glibc-devel.i686
    #RUN yum -y install libgcc.i686
    #RUN yum -y install gtk2.i686
    #RUN yum -y install libXtst.i686
    #RUN yum -y install libcanberra-gtk2.i686
    #RUN yum -y install pciutils-devel.i686
    #RUN yum -y install gtk2-engines.i686
    #RUN yum -y install PackageKit-gtk-module.i686
    #RUN yum -y install gcc-c++
    #


    # install pciutils lib
    #RUN yum -y install pciutils-devel.x86_64
    #

    # install sudo package
    #RUN yum -y install sudo.x86_64
    #

    # install git
    #RUN yum -y install git.x86_64
    #
    # clone faketime lib
    #RUN git clone https://github.com/allenyllee/libfaketime.git -b allenyllee-patch-1 /home/libfaketime
    #
    # make & install faketim lib
    #RUN cd /home/libfaketime && make install
    #

	
    # add user mikewu
    #RUN useradd mikewu
    #
    # add mikewu to root group
    #RUN usermod -a -G root mikewu
    #
    # change password with username:password
    #RUN echo mikewu:mikewu | chpasswd
    #RUN echo root:root | chpasswd
    #



    # fix Pango-WARNING **: failed to choose a font, expect ugly output. engine-type='PangoRenderFc', script='common'
    # https://www.centos.org/forums/viewtopic.php?t=1372
    #
    #RUN yum -y install liberation-sans-fonts # looks good
    #RUN yum -y groupinstall 'Fonts' # all fonts
    #

    # fix issue "failed to read machine uuid: Failed to open “/var/lib/dbus/machine-id”"
    # for x window use
    #RUN dbus-uuidgen > /var/lib/dbus/machine-id
    #
	
    # Fix: /bin/dbus-launch terminated abnormally without any error message
    # https://www.cyberciti.biz/faq/fix-bindbus-launch-terminated-abnormally-without-on-centos-rhel/
    #RUN yum -y install dbus-x11
    #
	
    #linux - PuTTY X11 proxy: wrong authorisation protocol attempted - Super User
    #https://superuser.com/questions/610084/putty-x11-proxy-wrong-authorisation-protocol-attempted
    # 
    #RUN yum -y install xorg-x11-xauth.x86_64
    #
	
	
    # install Xvfb (virtual framebuffer)
    # Running a GUI application in a Docker container | LinuxMeerkat
    # https://linuxmeerkat.wordpress.com/2014/10/17/running-a-gui-application-in-a-docker-container/
    #RUN yum -y install xorg-x11-server-Xvfb.x86_64
    #
	
    # install firefox
    #RUN yum -y install firefox
    #
	
    # install desktop environment GNOME or KDE
    # https://technozeal.wordpress.com/2009/12/15/linux-graphical-desktop-environment-x-windowgnomekde/
    #RUN yum -y groupinstall "X Window System" "GNOME Desktop Environment"
    #RUN yum -y groupinstall "X Window System" "KDE Desktop"
    #
	
    # install file explorer
    #RUN yum -y install nautilus.x86_64 
    #


    # copy binary file of xtensa xplorer-7.0.4 into container
    #COPY ./data/Xplorer-7.0.4-linux-installer.bin /home/tmp/Xplorer-7.0.4-linux-installer.bin
    #COPY ./data/development_tools_RG-2015.2.xws /home/tmp/development_tools_RG-2015.2.xws
    #COPY ./data/xplorer.sh /home/tmp/xplorer.sh
    
    # install xtensa xplorer-7.0.4
    #RUN /home/tmp/Xplorer-7.0.4-linux-installer.bin --mode unattended --prefix /opt/xtensa/


    # copy & apply license
    #COPY ./data/license_backup.txt /usr/local/flexlm/licenses/license.dat
    #COPY ./data/license_backup.txt /opt/xtensa/XtDevTools/install/tools/RG-2015.2-linux/XtensaTools/Tools/lic/license.dat

    #
    #RUN /home/tmp/xplorer.sh
    

    # remove binary file after installed
    #RUN rm -rf /home/tmp

    # add write access to mikewu
    #RUN chmod -R g+w /opt/xtensa/

    #RUN mkdir -p /usr/local/flexlm
    #RUN ln --symbolic --target-directory=/usr/local/flexlm  /home/xtensa/licenses
    

    #EXPOSE 22

    

    #CMD    ["/usr/sbin/sshd", "-D"]
    CMD    ["bash"]


