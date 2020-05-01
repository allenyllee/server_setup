#!/usr/bin/env sh

######
# Turn on NumLock Automatically When Ubuntu 14.04 Boots Up | UbuntuHandbook
# http://ubuntuhandbook.org/index.php/2014/06/turn-on-numlock-ubuntu-14-04/
######
/usr/bin/numlockx on

#######
# Wifi not getting detected in Ubuntu 16.04 - Stack Overflow
# https://stackoverflow.com/questions/46836085/wifi-not-getting-detected-in-ubuntu-16-04
###
# networking - Wifi networks are not showing in Ubuntu 16.04 - Ask Ubuntu
# https://askubuntu.com/questions/769521/wifi-networks-are-not-showing-in-ubuntu-16-04
#######
/etc/init.d/networking restart
/usr/sbin/service network-manager restart
