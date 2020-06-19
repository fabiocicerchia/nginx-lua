#!/bin/bash

source supported_versions

function push() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5

    DOCKERFILE_PATH=nginx/$NGINX_VER/$OS/$OS_VER
    DOCKERFILE=$DOCKERFILE_PATH/Dockerfile

    MAJOR=$(echo $NGINX_VER | cut -d '.' -f 1)
    MINOR=$MAJOR.$(echo $NGINX_VER | cut -d '.' -f 2)
    PATCH=$NGINX_VER
    
    docker images ls fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER && docker push fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER
    docker images ls fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER && docker push fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER
    docker images ls fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER && docker push fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER

    if [ $VER_TAGS -eq 1 ]; then
        docker push fabiocicerchia/nginx-lua:latest
        docker push fabiocicerchia/nginx-lua:$MAJOR
        docker push fabiocicerchia/nginx-lua:$MINOR
        docker push fabiocicerchia/nginx-lua:$PATCH
    fi

    if [ $OS_TAGS -eq 1 ]; then
        docker push fabiocicerchia/nginx-lua:$MAJOR-$OS
        docker push fabiocicerchia/nginx-lua:$MINOR-$OS
        docker push fabiocicerchia/nginx-lua:$PATCH-$OS
    fi
}

function push_family() {
    OS=$1
    VERSIONS=$2
    VER_TAGS=$3

    for OS_VER in "${VERSIONS[@]}"; do
        OS_TAGS=0
        if [ "${VERSIONS[-1]}" == "$OS_VER" ]; then
            OS_TAGS=1
        fi
        push $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done
}

set -x

for NGINX_VER in "${NGINX[@]}"; do

    VER_TAGS=0
    push_family amazonlinux $AMAZONLINUX $VER_TAGS
    push_family centos $CENTOS $VER_TAGS
    push_family debian $DEBIAN $VER_TAGS
    push_family fedora $FEDORA $VER_TAGS
    push_family ubuntu $UBUNTU $VER_TAGS
    
    # Default image is Alpine
    VER_TAGS=1
    push_family alpine $ALPINE $VER_TAGS

done