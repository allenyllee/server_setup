#!/bin/bash

##
## Linux xhost command help and examples
## https://www.computerhope.com/unix/xhost.htm
##
## xhost [[+-]name ...]
##
## [+]name 	The given name (the plus sign is optional) is added to the list allowed to connect to the X server. The name can be a host name or a complete name
## -name 	The given name is removed from the list of allowed to connect to the server. The name can be a host name or a complete name 
##
## Names
## 
## A complete name has the syntax "family:name" where the families are as follows:
## inet 	Internet host (IPv4).
## inet6 	Internet host (IPv6).
## dnet 	DECnet host.
## nis 	Secure RPC network name.
## krb 	Kerberos V5 principal.
## local 	Contains only one name, the empty string.
## si 	Server Interpreted.
##
##
## x11 - Running Chromium inside Docker - Gtk: cannot open display: :0 - Stack Overflow
## https://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0
##
xhost local:root

#nvidia-docker-compose build
nvidia-docker-compose run cuda bash -c "cd ~/project;bash"