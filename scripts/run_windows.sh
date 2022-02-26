#!/bin/bash

####################################### Boilerplate begin #######################################

# full directory name of the script no matter where it is being called from
DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) >/dev/null 2>&1 && pwd )
# readlink will resolve the script path to an absolute path from the root of the filesystem
DIR="`readlink -f "$DIR"`"

CONTAINER_DIR="`readlink -f "$DIR/.."`"
CONTAINER_CONFIG_DIR="$CONTAINER_DIR/config"
SRC_DIR="/${PWD}/../src"

[ -d "$CONTAINER_DIR" ] || eval 'echo "Directory CONTAINER_DIR=$CONTAINER_DIR does not exist" 1>&2; exit 1'
[ -d "$CONTAINER_CONFIG_DIR" ] || eval 'echo "Directory CONTAINER_CONFIG_DIR=$CONTAINER_CONFIG_DIR does not exist" 1>&2; exit 1'

# Include container config
. $CONTAINER_CONFIG_DIR/container.cfg || eval 'echo "Could not source container config file" 1>&2; exit 1'
# echo ${NETWORK_ATTACH}
# exit
####################################### Boilerplate end #######################################

# If network not created
if [ "$NETWORK" != "" ]; then
    NET_EXISTS=$(docker network ls | grep -c "$NETWORK")
    if [ "$NET_EXISTS" == "0" ]; then
        docker network create -o com.docker.network.bridge.enable_ip_masquerade=false "$NETWORK"
    fi
fi

# full image name, used when starting container
# MY_IMAGE="$MY_IMAGE_NAME"

docker run \
    -it \
    --cap-add NET_ADMIN \
    --name ${MYSERVICE} \
    --hostname ${MYHOSTNAME} \
    -v ${SRC_DIR}:/var/www/html \
    --network=${NETWORK} \
    -p 80:80 \
    ${MY_IMAGE_NAME}

# Attach container to networks needed
for NET_ATTACH in $NETWORK_ATTACH; do
docker network connect $NET_ATTACH $MYSERVICE
done

docker network connect $NETWORK $MYSERVICE

docker start $MYSERVICE
sleep 1
docker exec $MYSERVICE ip ro delete default
docker exec $MYSERVICE ip ro add default via 172.17.0.1
docker attach $MYSERVICE