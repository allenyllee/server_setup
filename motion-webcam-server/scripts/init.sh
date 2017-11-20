#!/bin/bash

echo "input parameter: $@"

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SOURCE_DIR/setup_motion.sh

bash