#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function metadata() {
    PATCH="$NGINX_VER"

    if [ "$FORCE" == "0" ]; then
        if [ -f "docs/metadata/$PATCH-$OS$OS_VER.md" ]; then
            return
        fi
    fi

    IMG_EXISTS=$(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$OS_VER" | wc -l)
    if [ "$IMG_EXISTS" -ne "0" ]; then
        {
            echo -e "# fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER\n";
            echo '```json';
            docker image inspect "fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER";
            echo '```';
         } > "docs/metadata/$PATCH-$OS$OS_VER.md"
    fi
}

set -eux

OS=$1
FORCE=0
if [ "$2" == "1" ]; then
    FORCE=1
fi
mapfile -t VERSIONS < <(get_versions "$OS")

loop_over_nginx_with_os "$OS" "metadata"