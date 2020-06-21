#!/bin/bash

source supported_versions

function build() {
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

    NOT_FOUND=$(docker pull fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER; echo $?)

    if [ "$NOT_FOUND" == "0" ]; then
        return
    fi

    VCS_REF=$(git rev-parse --short HEAD)
    docker build --build-arg BUILD_DATE=$(date +%Y%m%d%H%M%S) --build-arg BUILD_VERSION=$(date +%s) --build-arg VCS_REF=$VCS_REF -t fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER -f $DOCKERFILE .
    IMAGE_ID=$(docker image ls -q fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER)

    if [ "$VER_TAGS$OS_TAGS$DEFAULT" == "111" ]; then
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MAJOR
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MINOR
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$PATCH
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:latest
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MAJOR-$OS
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER
    fi

    if [ "$OS_TAGS" == "1" ]; then
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MINOR-$OS
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$PATCH-$OS
        docker tag $IMAGE_ID fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER
    fi
}

set -x

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    VER_TAGS=0
    if [ "$((I+1))" == "$NLEN" ]; then
        VER_TAGS=1
    fi

    # Default image is Alpine
    DEFAULT=1
    OS=alpine
    DLEN=${#ALPINE[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${ALPINE[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    DEFAULT=0

    OS=amazonlinux
    DLEN=${#AMAZONLINUX[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${AMAZONLINUX[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=centos
    DLEN=${#CENTOS[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${CENTOS[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=debian
    DLEN=${#DEBIAN[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${DEBIAN[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=fedora
    DLEN=${#FEDORA[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${FEDORA[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

    OS=ubuntu
    DLEN=${#UBUNTU[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${UBUNTU[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

done
