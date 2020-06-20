#!/bin/bash

source supported_versions

function runtest() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5

    MAJOR=$(echo $NGINX_VER | cut -d '.' -f 1)
    MINOR=$MAJOR.$(echo $NGINX_VER | cut -d '.' -f 2)
    PATCH=$NGINX_VER

    docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER \
        ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
        ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
        ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
        ; docker rm -f nginx_lua_test

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MAJOR \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MAJOR-$OS \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MINOR \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$PATCH \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
    fi

    if [ "$OS_TAGS" == "1" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MINOR-$OS \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$PATCH-$OS \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        docker run -d --name nginx_lua_test -p 8080:80 -v $PWD/test/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua:latest \
            ; until $(curl --output /dev/null --silent --head --fail http://localhost); do echo -n '.'; sleep 0.5; done \
            ; curl -v http://localhost:8080 | grep "Welcome to nginx" || exit 1 \
            ; curl -v http://localhost:8080/lua_content | grep "Hello world" || exit 1 \
            ; docker rm -f nginx_lua_test
    fi

}

set -x

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    VER_TAGS=0

    OS=amazonlinux
    DLEN=${#AMAZONLINUX[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${AMAZONLINUX[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

    OS=centos
    DLEN=${#CENTOS[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${CENTOS[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

    OS=debian
    DLEN=${#DEBIAN[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${DEBIAN[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

    OS=fedora
    DLEN=${#FEDORA[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${FEDORA[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

    OS=ubuntu
    DLEN=${#UBUNTU[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${UBUNTU[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

    # Default image is Alpine
    if [ "$((I+1))" == "$NLEN" ]; then
        VER_TAGS=1
    fi

    OS=alpine
    DLEN=${#ALPINE[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${ALPINE[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        runtest $NGINX_VER $OS $OS_VER $VER_TAGS $OS_TAGS
    done

done