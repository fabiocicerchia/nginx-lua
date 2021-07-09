#!/bin/bash
# shellcheck disable=SC1091,SC2207

source ./bin/_common.sh
source supported_versions

function docker_push() {
    TAG=$1
    EXITCODE=$(
        docker push prakasa1904/nginx-lua:"$TAG" >/dev/null
        echo $?
    )
    if [ "$EXITCODE" -ne "0" ]; then
        docker push prakasa1904/nginx-lua:"$TAG"
    fi
}

function push() {
    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    if [ "$FORCE" == "0" ]; then
        if [ "$(docker_tag_exists prakasa1904/nginx-lua "$PATCH-$OS$OS_VER")" == "0" ]; then
            return
        fi
    fi

    [[ $(docker image ls -q prakasa1904/nginx-lua:"$MAJOR-$OS$OS_VER" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS$OS_VER"
    [[ $(docker image ls -q prakasa1904/nginx-lua:"$MINOR-$OS$OS_VER" | wc -l) -ne 0 ]] && docker_push "$MINOR-$OS$OS_VER"
    [[ $(docker image ls -q prakasa1904/nginx-lua:"$PATCH-$OS$OS_VER" | wc -l) -ne 0 ]] && docker_push "$PATCH-$OS$OS_VER"

    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$MAJOR" | wc -l) -ne 0 ]] && docker_push "$MAJOR"
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$MINOR" | wc -l) -ne 0 ]] && docker_push "$MINOR"
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$PATCH" | wc -l) -ne 0 ]] && docker_push "$PATCH"
        [[ $(docker image ls -q prakasa1904/nginx-lua:latest | wc -l) -ne 0 ]] && docker push prakasa1904/nginx-lua:latest
    fi

    if [ "$LAST_VER_NGINX$LAST_VER_OS" == "11" ]; then
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$OS" | wc -l) -ne 0 ]] && docker_push "$OS"
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$MAJOR-$OS" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS"
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$MAJOR-$OS$OS_VER" | wc -l) -ne 0 ]] && docker_push "$MAJOR-$OS$OS_VER"
    fi

    if [ "$LAST_VER_OS" == "1" ]; then
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$MINOR-$OS" | wc -l) -ne 0 ]] && docker_push "$MINOR-$OS"
        [[ $(docker image ls -q prakasa1904/nginx-lua:"$PATCH-$OS" | wc -l) -ne 0 ]] && docker_push "$PATCH-$OS"
    fi
}

set -eux

OS=$1
FORCE=0
if [ "$2" == "1" ]; then
    FORCE=1
fi
VERSIONS=($(get_versions "$OS"))

loop_over_nginx_with_os "$OS" "push"
