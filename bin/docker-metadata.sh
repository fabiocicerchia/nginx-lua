#!/bin/bash
# shellcheck disable=SC1091,SC2207

source ./bin/_common.sh
source supported_versions

function metadata() {
    PATCH="$NGINX_VER"

    if [ "$FORCE" == "NO" ]; then
        if [ -f "docs/metadata/$PATCH-$OS$OS_VER.md" ]; then
            return
        fi
    fi

    IMG_EXISTS=$(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$OS_VER" | wc -l)
    if [ "$IMG_EXISTS" -ne "0" ]; then
        {
            echo -e "# fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER\n"
            echo '```json'
            docker image inspect "fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER"
            echo '```'
        } >"docs/metadata/$PATCH-$OS$OS_VER.md"
    fi
}

set -eux

OS=$1
FORCE=${2:-NO}
VERSIONS=($(get_versions "$OS"))

loop_over_nginx_with_os "$OS" "metadata"
