#!/bin/bash

#
# linux - Prevent process from killing itself using pkill - Stack Overflow 
# https://stackoverflow.com/questions/15740481/prevent-process-from-killing-itself-using-pkill
#
echo "pid of this process is $$, kill all matched process but pid=$$"
kill $(pgrep -f pulseeffects | grep -v ^$$\$)

/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=pulseeffects com.github.wwmm.pulseeffects -s &>/dev/null
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=pulseeffects com.github.wwmm.pulseeffects -s -n &>/dev/null &
