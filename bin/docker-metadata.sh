#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function metadata() {
    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    if [ "$FORCE" == "0" ]; then
        if [ -f "docs/metadata/$PATCH-$OS$OS_VER.md" ]; then
            return
        fi
    fi

    if [ $(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$OS_VER" | wc -l) -ne 0 ]; then
        echo -e "# fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER\n" > "docs/metadata/$PATCH-$OS$OS_VER.md"
        echo '```json' >> "docs/metadata/$PATCH-$OS$OS_VER.md"
        docker image inspect "fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER" >> "docs/metadata/$PATCH-$OS$OS_VER.md"
        echo '```' >> "docs/metadata/$PATCH-$OS$OS_VER.md"
    fi
}

set -eux

OS=$1
FORCE=0
if [ "$2" == "1" ]; then
    FORCE=1
fi
VERSIONS=($(get_versions "$OS"))

loop_over_nginx_with_os "$OS" "metadata"