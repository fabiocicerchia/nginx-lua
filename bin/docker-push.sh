#!/bin/bash

source supported_versions

function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

function push() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5
    DEFAULT=$6

    DOCKERFILE_PATH=nginx/$NGINX_VER/$OS/$OS_VER
    DOCKERFILE=$DOCKERFILE_PATH/Dockerfile

    MAJOR=$(echo $NGINX_VER | cut -d '.' -f 1)
    MINOR=$MAJOR.$(echo $NGINX_VER | cut -d '.' -f 2)
    PATCH=$NGINX_VER

    #if docker_tag_exists fabiocicerchia/nginx-lua $PATCH-$OS$OS_VER; then
    #    return
    #fi

    docker push fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER
    docker push fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER
    docker push fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER

    if [ "$VER_TAGS$OS_TAGS$DEFAULT" == "111" ]; then
        docker push fabiocicerchia/nginx-lua:$MAJOR
        docker push fabiocicerchia/nginx-lua:$MINOR
        docker push fabiocicerchia/nginx-lua:$PATCH
        docker push fabiocicerchia/nginx-lua:latest
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        docker push fabiocicerchia/nginx-lua:$MAJOR-$OS
        docker push fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER
    fi

    if [ "$OS_TAGS" == "1" ]; then
        docker push fabiocicerchia/nginx-lua:$MINOR-$OS
        docker push fabiocicerchia/nginx-lua:$PATCH-$OS
        docker push fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER
    fi
}

set -x

OS=$1
VERSIONS=()
if [ "$OS" == "alpine" ]; then VERSIONS=$ALPINE
elif [ "$OS" == "amazonlinux" ]; then VERSIONS=$AMAZONLINUX
elif [ "$OS" == "centos" ]; then VERSIONS=$CENTOS
elif [ "$OS" == "debian" ]; then VERSIONS=$DEBIAN
elif [ "$OS" == "fedora" ]; then VERSIONS=$FEDORA
elif [ "$OS" == "ubuntu" ]; then VERSIONS=$UBUNTU
fi

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    VER_TAGS=0
    if [ "$((I+1))" == "$NLEN" ]; then
        VER_TAGS=1
    fi

    # Default image is Alpine
    DEFAULT=0
    if [ "$OS" == "alpine" ]; then DEFAULT=1; fi

    DLEN=${#VERSIONS[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${VERSIONS[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        push $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

done
