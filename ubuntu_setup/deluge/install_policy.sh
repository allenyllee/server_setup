#!/usr/bin/env bash

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# base dir of this script to exclude
BASE_DIR="$(basename $SOURCE_DIR)"

# copy policy
sudo cp $SOURCE_DIR/*.policy /usr/share/polkit-1/actions

# copy desktop file
cp $SOURCE_DIR/deluge.desktop ~/.local/share/applications/
