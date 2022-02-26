#!/bin/bash

####################################### Boilerplate begin #######################################

# full directory name of the script no matter where it is being called from
# DIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)
# readlink will resolve the script path to an absolute path from the root of the filesystem
# DIR="$(readlink -f "$DIR")"

# CONTAINER_DIR="$(readlink -f "$DIR/..")"
CONTAINER_DIR="../"
CONTAINER_CONFIG_DIR="$CONTAINER_DIR/config"
# SRC_DIR="C:\\Users\\ignatev.my\\Desktop\\study\\gmw\\src"
# echo $SRC_DIR

[ -d "$CONTAINER_DIR" ] || eval 'echo "Directory CONTAINER_DIR=$CONTAINER_DIR does not exist" 1>&2; exit 1'
[ -d "$CONTAINER_CONFIG_DIR" ] || eval 'echo "Directory CONTAINER_CONFIG_DIR=$CONTAINER_CONFIG_DIR does not exist" 1>&2; exit 1'
# [ -d "$SRC_DIR" ] || eval 'echo "Directory SRC_DIR=$SRC_DIR does not exist" 1>&2; exit 1'

# Include container config
. $CONTAINER_CONFIG_DIR/container.cfg || eval 'echo "Could not source container config file" 1>&2; exit 1'

####################################### Boilerplate end #######################################
docker network connect bridge ${MYSERVICE}

