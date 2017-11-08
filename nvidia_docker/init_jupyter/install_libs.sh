#!/bin/bash

# Install Dlib on Ubuntu | Learn OpenCV 
# https://www.learnopencv.com/install-dlib-on-ubuntu/
#
# dependencies for build dlib: cmake, boost, PkgConfig
# build-essential: gcc,g++,make...
# check dependency: apt-cache depends build-essential
apt-get install -y build-essential cmake libboost-python-dev pkg-config

# dependencies for X11 GUI window
apt-get install -y libx11-dev

# dependencies for ??
apt-get install -y libatlas-base-dev libgtk-3-dev

# build dlib
# davisking/dlib: A toolkit for making real world machine learning and data analysis applications in C++ 
# https://github.com/davisking/dlib
#bash <<EOF
#cd /root/project
#git clone https://github.com/davisking/dlib.git
#cd dlib/
#python setup.py install
## python setup.py install --yes USE_AVX_INSTRUCTIONS
#EOF

