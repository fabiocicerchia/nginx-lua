#!/bin/bash
# shellcheck disable=SC1091

source supported_versions

function metadata() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3
    VER_TAGS=$4
    OS_TAGS=$5
    DEFAULT=$6

    MAJOR=$(echo "$NGINX_VER" | cut -d '.' -f 1)
    MINOR="$MAJOR".$(echo "$NGINX_VER" | cut -d '.' -f 2)
    PATCH="$NGINX_VER"

    if [ $(docker image ls -q fabiocicerchia/nginx-lua:"$PATCH-$OS$OS_VER" | wc -l) -ne 0 ]; then
        echo -e "# fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER\n" > "docs/metadata/$PATCH-$OS$OS_VER.md"
        echo '```json' >> "docs/metadata/$PATCH-$OS$OS_VER.md"
        docker image inspect "fabiocicerchia/nginx-lua:$PATCH-$OS$OS_VER" >> "docs/metadata/$PATCH-$OS$OS_VER.md"
        echo '```' >> "docs/metadata/$PATCH-$OS$OS_VER.md"
    fi
}

set -eux

OS=$1
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
        metadata "$NGINX_VER" "$OS" "$OS_VER" $VER_TAGS $OS_TAGS $DEFAULT
    done

done
