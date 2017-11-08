# anaconda with dlib
#
# VERSION               0.0.1

FROM      continuumio/anaconda3 
LABEL     maintainer="allen7575@gmail.com"

# Install Dlib on Ubuntu | Learn OpenCV 
# https://www.learnopencv.com/install-dlib-on-ubuntu/
#
# dependencies for build dlib: cmake, boost, PkgConfig
# build-essential: gcc,g++,make...
# check dependency: apt-cache depends build-essential
RUN apt-get install -y build-essential cmake libboost-python-dev pkg-config

# dependencies for X11 GUI window
RUN apt-get install -y libx11-dev

# dependencies for ??
RUN apt-get install -y libatlas-base-dev libgtk-3-dev

# build dlib
# davisking/dlib: A toolkit for making real world machine learning and data analysis applications in C++ 
# https://github.com/davisking/dlib
RUN bash -c " \
mkdir -p /root/project && \
cd /root/project && \
git clone https://github.com/davisking/dlib.git && \
cd dlib/ && \
python setup.py install"
# python setup.py install --yes USE_AVX_INSTRUCTIONS && \


ADD ./init_jupyter/* /init_jupyter/

ENTRYPOINT ["/init_jupyter/jupyter_init.sh"]

CMD ["bash"]