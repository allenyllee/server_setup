#!/bin/bash

sudo mount.cifs //localhost/project /mnt/smb/project --verbose -o guest,iocharset=utf8,uid=1000

