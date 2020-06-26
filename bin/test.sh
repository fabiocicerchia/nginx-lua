#!/bin/bash

source supported_versions

function test() {
    DOCKER_TAG=$1

    docker rm -f nginx_lua_test 2> /dev/null

    FOUND=$(docker image ls -q fabiocicerchia/nginx-lua:$DOCKER_TAG | wc -l)
    if [ $FOUND -ne 0 ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$DOCKER_TAG
        COUNT=0
        until [ $COUNT -eq 20 -o "$(curl --output /dev/null --silent --head --fail http://localhost:8080; echo $?)" == "0" ]; do
            echo -n '.'; sleep 0.5;
            COUNT=$((COUNT+1))
        done
        curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1
        curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1
        docker rm -f nginx_lua_test
     else
        echo "Image not found: fabiocicerchia/nginx-lua:$DOCKER_TAG"
     fi
}

function runtest() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5

    MAJOR=$(echo $NGINX_VER | cut -d '.' -f 1)
    MINOR=$MAJOR.$(echo $NGINX_VER | cut -d '.' -f 2)
    PATCH=$NGINX_VER

    test $PATCH-$OS$OS_VER

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        test $MAJOR
        test $MAJOR-$OS
        test $MAJOR-$OS$OS_VER
        test $MINOR
        test $PATCH
    fi

    if [ "$OS_TAGS" == "1" ]; then
        test $MINOR-$OS
        test $PATCH-$OS
        test $MINOR-$OS$OS_VER
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        test latest
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
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS $DEFAULT
    done

done
