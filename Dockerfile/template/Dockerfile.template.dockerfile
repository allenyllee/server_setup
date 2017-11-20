# dockerfile template
#
# VERSION               0.0.1

FROM      ubuntu/ubuntu:16.04
LABEL     maintainer="allen7575@gmail.com"

############
# update package list
############
RUN apt update

##########
# install vim
##########
RUN apt install -y vim


############
# put something here...
############





##############
# upgrade
##############
RUN apt upgrade -y

##############
# cleanup
##############
# debian - clear apt-get list - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/217369/clear-apt-get-list
#
# bash - autoremove option doesn't work with apt alias - Ask Ubuntu
# https://askubuntu.com/questions/573624/autoremove-option-doesnt-work-with-apt-alias
#
RUN apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#################
# init script
#################



ENTRYPOINT ["/script/init.sh"]

CMD ["bash"]