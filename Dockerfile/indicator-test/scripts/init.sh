#!/bin/bash

echo "input parameter: $@"

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "SOURCE_DIR:" $SOURCE_DIR

# run init script here
source /home/guest/.profile
$SOURCE_DIR/run_indicator.sh

