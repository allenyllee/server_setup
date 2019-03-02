#!/bin/bash

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "SOURCE_DIR:" $SOURCE_DIR

# linux - Dropbox system tray icon missing, not working - Super User
# https://superuser.com/questions/1037769/dropbox-system-tray-icon-missing-not-working
# 
# Tray icon on Ubuntu is missing · Issue #765 · mattermost/desktop
# https://github.com/mattermost/desktop/issues/765
env XDG_CURRENT_DESKTOP=Unity dbus-launch $SOURCE_DIR/indicator-places-master/indicator-places.py

