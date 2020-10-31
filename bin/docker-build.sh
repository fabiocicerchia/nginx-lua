#!/bin/bash
# shellcheck disable=SC1091,SC2086

source supported_versions

function docker_tag_exists() {
    curl --silent -f -lSL "https://index.docker.io/v1/repositories/$1/tags/$2" > /dev/null
    echo $?
}

function build() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5
    DEFAULT=$6
    EXTENDED=$7

    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    if [ "$FORCE" == "0" ]; then
        if [ "$(docker_tag_exists fabiocicerchia/nginx-lua "$PATCH-$OS$OS_VER")" == "0" ]; then
            return
        fi
    fi

    SUFFIX=""
    if [ "$EXTENDED" -eq "0" ]; then
        SUFFIX="${SUFFIX}-minimal"
    fi

    TAGS=""
    if [ "$VER_TAGS$OS_TAGS$DEFAULT" == "111" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:latest$SUFFIX"
    fi

    if [ "$VER_TAGS$OS_TAGS" == "11" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER$SUFFIX"
    fi

    if [ "$OS_TAGS" == "1" ]; then
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR-$OS$SUFFIX"
        TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH-$OS$SUFFIX"
    fi

    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER$SUFFIX"
    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MINOR-$OS$OS_VER$SUFFIX"
    TAGS="$TAGS -t fabiocicerchia/nginx-lua:$MAJOR-$OS$OS_VER$SUFFIX"

    BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    VCS_REF=$(git rev-parse --short HEAD)
    time docker build \
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
VERSIONS=()
if [ "$OS" == "alpine" ]; then VERSIONS=("${ALPINE[@]}")
elif [ "$OS" == "amazonlinux" ]; then VERSIONS=("${AMAZONLINUX[@]}")
elif [ "$OS" == "centos" ]; then VERSIONS=("${CENTOS[@]}")
elif [ "$OS" == "debian" ]; then VERSIONS=("${DEBIAN[@]}")
elif [ "$OS" == "fedora" ]; then VERSIONS=("${FEDORA[@]}")
elif [ "$OS" == "ubuntu" ]; then VERSIONS=("${UBUNTU[@]}")
fi

NLEN=${#NGINX[@]}
for (( I=0; I<NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    VER_TAGS=0
    if [ "$((I+1))" == "$NLEN" ]; then
        VER_TAGS=1
    fi

    # Default image is Alpine
    DEFAULT=0
    if [ "$OS" == "alpine" ]; then DEFAULT=1; fi

    DLEN=${#VERSIONS[@]}
    for (( J=0; J<DLEN; J++ )); do
        OS_VER="${VERSIONS[$J]}"
        OS_TAGS=0
        if [ "$((J+1))" == "$DLEN" ]; then
            OS_TAGS=1
        fi
        build "$NGINX_VER" "$OS" "$OS_VER" $VER_TAGS $OS_TAGS $DEFAULT $EXTENDED_IMAGE
    done

done

docker images
