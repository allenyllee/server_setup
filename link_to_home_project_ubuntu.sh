#!/bin/bash

#
# create symlink to current folder at home
#
if [ ! -d ~/Project ]; 
then sudo ln -s $PWD ~/Project; 
else echo "~/Project already exist" && rm ~/Project && sudo ln -s $PWD ~/Project; 
fi


