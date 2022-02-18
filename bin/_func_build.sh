#!/bin/bash
# shellcheck disable=SC1091,SC2086,SC2207

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

function docker_build_amd64_only() {
    time docker buildx build \
        --platform=linux/amd64 --load \
        --build-arg EXTENDED_IMAGE="$EXTENDED_IMAGE" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg VCS_REF="$VCS_REF" \
        $TAGS \
        -f "$DOCKERFILE" .
}

function docker_build() {
    time docker buildx build \
        --platform=linux/amd64,linux/arm64/v8 \
        --progress=plain \
        --build-arg EXTENDED_IMAGE="$EXTENDED_IMAGE" \
        --build-arg BUILD_DATE="$BUILD_DATE" \
        --build-arg VCS_REF="$VCS_REF" \
        $TAGS \
        -f "$DOCKERFILE" .
}

function build() {
    MULTI_ARCH=$1
    SUFFIX=$2
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile$SUFFIX"

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    if [ "$EXTENDED_IMAGE" -eq "0" ]; then
        SUFFIX="${SUFFIX}-minimal"
    fi

    if [ "$FORCE" == "NO" ]; then
        if [ "$(docker_tag_exists fabiocicerchia/nginx-lua "$PATCH-$OS$OS_VER$SUFFIX")" == "0" ]; then
            return
        fi
    fi

    TAGS=$(get_tags)

    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    VCS_REF=$(git rev-parse --short HEAD)

    if [ $MULTI_ARCH -eq 0 ]; then
        docker_build_amd64_only
    else
        docker_build
    fi
}

function build_classic() {
    echo $MULTI_ARCH
    build $MULTI_ARCH ""
}

function build_compat() {
    build $MULTI_ARCH "-compat"
}
