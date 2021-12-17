#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function patch_dockerfile() {
    DOCKERFILE=$1

    if [ "$(uname)" == "Darwin" ]; then
        sed -i "" "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_OS}}/$OS/" "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/" "$DOCKERFILE"
        sed -i "" "s/{{VER_NGINX}}/$NGINX_VER/" "$DOCKERFILE"
    else
        sed -i "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_OS}}/$OS/" "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/" "$DOCKERFILE"
        sed -i "s/{{VER_NGINX}}/$NGINX_VER/" "$DOCKERFILE"
    fi
}

function init_dockerfile() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    mkdir -p "$DOCKERFILE_PATH" 2>/dev/null
    cp "tpl/Dockerfile.$OS" "$DOCKERFILE"

    patch_dockerfile "$DOCKERFILE"
}

function init_dockerfile_compat() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile-compat"

    mkdir -p "$DOCKERFILE_PATH" 2>/dev/null
    cp "tpl/Dockerfile.$OS-compat" "$DOCKERFILE"

    patch_dockerfile "$DOCKERFILE"
}

set -eux

loop_over_nginx "init_dockerfile"
loop_over_nginx "init_dockerfile_compat"

rm ./Dockerfile
DOCKERFILE=$(find nginx/*/alpine/*/Dockerfile -type f | sort -r | head -n1)
cp "$DOCKERFILE" ./Dockerfile
