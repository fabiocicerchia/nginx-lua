#!/bin/bash
# shellcheck disable=SC1091,SC2086,SC2207

source ./bin/_common.sh
source supported_versions

function get_tags() {
    TAGS=""
    if [ "$LAST_VER_NGINX$LAST_VER_OS$DEFAULT_IMAGE" == "111" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:latest$SUFFIX"
    fi

    if [ "$LAST_VER_NGINX$LAST_VER_OS" == "11" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER$SUFFIX"
    fi

    if [ "$LAST_VER_OS" == "1" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR-$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH-$OS$SUFFIX"
    fi

    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER$SUFFIX"
    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER$SUFFIX"
    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER$SUFFIX"

    echo $TAGS
}

function build() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    SUFFIX=""
    if [ "$EXTENDED_IMAGE" -eq "0" ]; then
        SUFFIX="${SUFFIX}-minimal"
    fi

    if [ "$FORCE" == "0" ]; then
        if [ "$(docker_tag_exists fabiocicerchia/nginx-lua "$PATCH-$OS$OS_VER$SUFFIX")" == "0" ]; then
            return
        fi
    fi

    TAGS=$(get_tags)

    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    VCS_REF=$(git rev-parse --short HEAD)

    # REF: https://pascalroeleven.nl/2021/09/09/ubuntu-21-10-and-fedora-35-in-docker/
    #      https://github.com/docker/buildx/issues/99
    time docker buildx build \
        --progress=plain \
        --build-arg EXTENDED_IMAGE="$EXTENDED_IMAGE" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg VCS_REF="$VCS_REF" \
        $TAGS \
        -f "$DOCKERFILE" .
}

function build_compat() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile-compat"

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    SUFFIX="-compat"
    if [ "$EXTENDED_IMAGE" -eq "0" ]; then
        SUFFIX="${SUFFIX}-minimal"
    fi

    if [ "$FORCE" == "0" ]; then
        if [ "$(docker_tag_exists fabiocicerchia/nginx-lua "$PATCH-$OS$OS_VER$SUFFIX")" == "0" ]; then
            return
        fi
    fi

    TAGS=$(get_tags)

    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    VCS_REF=$(git rev-parse --short HEAD)
    time docker buildx build \
        --progress=plain \
        --build-arg EXTENDED_IMAGE="$EXTENDED_IMAGE" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg VCS_REF="$VCS_REF" \
        $TAGS \
        -f "$DOCKERFILE" .
}

set -eux

OS=$1
FORCE=0
if [ "$2" == "1" ]; then
    FORCE=1
fi
EXTENDED_IMAGE=1
if [ "$2" == "0" ]; then
    EXTENDED_IMAGE=0
fi
VERSIONS=($(get_versions "$OS"))

loop_over_nginx_with_os "$OS" "build"
loop_over_nginx_with_os "$OS" "build_compat"

docker images
