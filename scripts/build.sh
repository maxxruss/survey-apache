#!/bin/bash

####################################### Boilerplate begin #######################################

# full directory name of the script no matter where it is being called from
DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) >/dev/null 2>&1 && pwd )
# readlink will resolve the script path to an absolute path from the root of the filesystem
DIR="`readlink -f "$DIR"`"

CONTAINER_DIR="`readlink -f "$DIR/.."`"
CONTAINER_CONFIG_DIR="$CONTAINER_DIR/config"

[ -d "$CONTAINER_DIR" ] || eval 'echo "Directory CONTAINER_DIR=$CONTAINER_DIR does not exist" 1>&2; exit 1'
[ -d "$CONTAINER_CONFIG_DIR" ] || eval 'echo "Directory CONTAINER_CONFIG_DIR=$CONTAINER_CONFIG_DIR does not exist" 1>&2; exit 1'

# Include container config
. $CONTAINER_CONFIG_DIR/container.cfg || eval 'echo "Could not source container config file" 1>&2; exit 1'

####################################### Boilerplate end #######################################
MY_IMAGE="$MY_IMAGE_NAME"
# Build own PROD image and tag as 'latest', add tag
DOCKER_BUILDKIT=1 docker build --no-cache \
 --build-arg BASE_BUILD_IMAGE=$BASE_BUILD_IMAGE \
 -t $MY_IMAGE \
 -f $CONTAINER_CONFIG_DIR/Dockerfile \
 $CONTAINER_DIR || eval 'echo "Could not build $MY_IMAGE_LATEST $MY_IMAGE_TAGGED from $BASE_IMAGE, exit code $?" 1>&2; exit 1'
