#!/usr/bin/env python3

"""
Script to create a password for the Jupyter notebook configuration
Written by Pieter de Rijk <pieter@de-rijk.com>
Modified by Allen YL Lee <allen7575@gmail.com>
"""
#
# Can one set up automated config file with a password prompt? · Issue #1700 · jupyter/notebook
# https://github.com/jupyter/notebook/issues/1700
#
# I wrote a small python script that creates the correct password entry.
# https://github.com/paderijk/jupyter-password/blob/master/jupyter-password.py
#

import os
from notebook.auth import passwd


JUPYTER_CONFIG = os.path.expanduser('~/.jupyter/jupyter_notebook_config.py')
LINE = "==========================================================================="

print(LINE)
print("Setting Jupyter additional configuration")
print(LINE)

#
# tensorflow/jupyter_notebook_config.py at 075d1d13b47b09405a65a4897bdb755e043ef4e0 · tensorflow/tensorflow
# https://github.com/tensorflow/tensorflow/blob/075d1d13b47b09405a65a4897bdb755e043ef4e0/tensorflow/tools/docker/jupyter_notebook_config.py
#
if 'PASSWORD' in os.environ:
    PSWD = os.environ['PASSWORD']
    if PSWD:
        print("PASSWORD environment varible has been set, just use it....")
        PWHASH = passwd(PSWD)
    else:
        print("Please set a strong password")
        PWHASH = passwd()
    del os.environ['PASSWORD']

print(LINE)
print("Following will be added to %s " % (JUPYTER_CONFIG))

JUPYTER_COMMENT_START = "# Start of lines added by jupyter-password.py"
JUPYTER_COMMENT_END = "# End lines added by jupyter-passwordd.py"
JUPYTER_PASSWD_LINE = "c.NotebookApp.password = u'%s'" % (PWHASH)
JUPYTER_NO_BROWSER = "c.NotebookApp.open_browser = False"

print(" ")
print("  %s " % (JUPYTER_COMMENT_START))
print("  %s " % (JUPYTER_PASSWD_LINE))
print("  %s " % (JUPYTER_NO_BROWSER))
print("  %s " % (JUPYTER_COMMENT_END))
print(LINE)

with open(JUPYTER_CONFIG, 'a') as file:
    file.write('\n')
    file.write(JUPYTER_COMMENT_START + '\n')
    file.write(JUPYTER_PASSWD_LINE + '\n')
    file.write(JUPYTER_NO_BROWSER + '\n')
    file.write(JUPYTER_COMMENT_END + '\n')
