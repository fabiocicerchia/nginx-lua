#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function init_dockerfile() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    mkdir -p "$DOCKERFILE_PATH" 2> /dev/null
    cp "tpl/Dockerfile.$OS" "$DOCKERFILE"

    if [ "$(uname)" == "Darwin" ]; then
        sed -i "" "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_OS}}/$OS/"                    "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/"               "$DOCKERFILE"
        sed -i "" "s/{{VER_NGINX}}/$NGINX_VER/"                   "$DOCKERFILE"
    else
        sed -i "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_OS}}/$OS/"                    "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/"               "$DOCKERFILE"
        sed -i "s/{{VER_NGINX}}/$NGINX_VER/"                   "$DOCKERFILE"
    fi
}

set -eux

loop_over_nginx "init_dockerfile"

rm ./Dockerfile
DOCKEFILE=$(find nginx/*/alpine/*/Dockerfile -type f | sort -r | head -n1)
ln -s "$DOCKEFILE" ./Dockerfile