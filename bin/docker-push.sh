#!/bin/bash
# shellcheck disable=SC1091,SC2207

source ./bin/_common.sh
source supported_versions

function docker_push() {
    TAG=$1
    EXITCODE=$(
        docker push fabiocicerchia/nginx-lua:"$TAG" >/dev/null
        echo $?
    )
    if [ "$EXITCODE" -ne "0" ]; then
        docker push fabiocicerchia/nginx-lua:"$TAG"
    fi
}

function push_images() {
    SUFFIX=$1

    if [ "$FORCE" == "0" ]; then
        if [ "$(docker_tag_exists fabiocicerchia/nginx-lua "$PATCH-$OS$OS_VER$SUFFIX")" == "0" ]; then
            return
        fi
    fi

    [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MAJOR-$OS$OS_VER$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS$OS_VER$SUFFIX"
    [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MINOR-$OS$OS_VER$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MINOR-$OS$OS_VER$SUFFIX"
    [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$OS_VER$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$PATCH-$OS$OS_VER$SUFFIX"

    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MAJOR$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MAJOR$SUFFIX"
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MINOR$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MINOR$SUFFIX"
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$PATCH$SUFFIX"
        [[ $(docker image ls -q "fabiocicerchia/nginx-lua:latest$SUFFIX" | wc -l) -ne 0 ]] && docker push "fabiocicerchia/nginx-lua:latest$SUFFIX"
    fi

    if [ "$LAST_VER_NGINX$LAST_VER_OS" == "11" ]; then
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$OS$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$OS$SUFFIX"
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MAJOR-$OS$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS$SUFFIX"
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MAJOR-$OS$OS_VER$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS$OS_VER$SUFFIX"
    fi

    if [ "$LAST_VER_OS" == "1" ]; then
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$MINOR-$OS$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$MINOR-$OS$SUFFIX"
        [[ $(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$SUFFIX" | wc -l) -ne 0 ]] && docker_push "$PATCH-$OS$SUFFIX"
    fi
}

function push() {
    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    SUFFIX=""

    push_images "$SUFFIX"
}

function push_compat() {
    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    SUFFIX="-compat"

    push_images "$SUFFIX"
}

set -eux

OS=$1
FORCE=0
if [ "$2" == "1" ]; then
    FORCE=1
fi
VERSIONS=($(get_versions "$OS"))

loop_over_nginx_with_os "$OS" "push"
loop_over_nginx_with_os "$OS" "push_compat"
