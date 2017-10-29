    # wine_X_docker
    #
    # VERSION               0.0.1

    FROM        ubuntu:16.04
    LABEL       maintainer="allen7575@gmail.com"

    #
    # How to Install Wine 2.0 Stable in Ubuntu 16.04, 14.04, 16.10 | UbuntuHandbook 
    # http://ubuntuhandbook.org/index.php/2017/01/install-wine-2-0-ubuntu-16-04-14-04-16-10/
    # 
    # Do following command before adding the PPA:
    # 
    RUN apt update && \
        apt-get install -y software-properties-common
    #
    # adding Ricotz’s PPA:
    # For 64-bit system, enable 32-bit architecture (if you haven’t already) via 
    # sudo dpkg --add-architecture i386
    # 
    RUN add-apt-repository -y ppa:ricotz/unstable && \
        dpkg --add-architecture i386 && \
        apt update && \
        apt install -y wine-stable

    # add user wineXdocker
    RUN useradd -m wineXdocker -s /bin/bash
    #
    # add mikewu to root group
    #RUN usermod -a -G root mikewu
    #
    # change password with username:password
    RUN echo wineXdocker:wineXdocker | chpasswd
    RUN echo root:root | chpasswd
    #
    # 
    RUN apt update && apt-get install -y wget
    
    RUN apt update && apt-get install -y xvfb

    USER wineXdocker
    RUN cd ~ && \
        wget http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe

    USER root
    RUN mkdir /tmp/.X11-unix && \
        chmod 1777 /tmp/.X11-unix

    RUN apt update && apt-get install -y winbind

    RUN apt update && apt-get install -y mesa-utils

    #RUN apt update && apt-get install -y xserver-xorg

    USER wineXdocker

    #RUN Xvfb :99 & \
    #    export DISPLAY=:99 && \
    #    cd ~ && \
    #    WINEARCH=win32 wine ./LineInst.exe /s

    # 
    # 
    # 
    # 
    # 
    # 
    CMD ["bash"]
