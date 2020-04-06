#!/usr/bin/env bash

DOCKER=$(which docker)
GIT=$(which git)

GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
DOCKER_IMAGE_NAME='marble:latest'
DOCKER_CONTAINER_NAME='marble'

$DOCKER build $GIT_REPO_ROOT/conf \
    --tag $DOCKER_IMAGE_NAME

CONTAINER_EXISTS=$($DOCKER ps -a --format '{{ .Names }}' --filter name=$DOCKER_CONTAINER_NAME)

if [ -n "$CONTAINER_EXISTS" ];
then
    $DOCKER stop $DOCKER_CONTAINER_NAME && $DOCKER rm $DOCKER_CONTAINER_NAME
fi

$DOCKER run \
    --name $DOCKER_CONTAINER_NAME \
    --network=host \
    --volume=$(pwd):/app \
    # Map X11 ports and map display.
    #
    # See: https://stackoverflow.com/a/27162721
    # --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    # -e DISPLAY=unix$DISPLAY \
    # Avoid error 'Failed to get D-Bus connection' when starting 'lightdm'.
    #
    # See: https://github.com/maci0/docker-systemd-unpriv/issues/7
    --security-opt="seccomp=unconfined" \
    -itd $DOCKER_IMAGE_NAME
