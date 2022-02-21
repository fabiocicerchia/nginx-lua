#!/bin/bash
# shellcheck disable=SC2207,SC2129

if [ ! -d /tmp/generate-supported-versions ]; then
    mkdir -p /tmp/generate-supported-versions
fi

fetch_latest() {
    DISTRO=$1
    FILTER=${2-}
    if [ "$FILTER" == "" ]; then
        FILTER=".+"
    fi
    DIGEST=$(wget -q "https://hub.docker.com/v2/repositories/library/$DISTRO/tags/latest" -O - | jq -rc '.images[] | select( .architecture == "amd64") | .digest')

    VER=""
    PAGE=1
    while [ "$VER" = "" ] && [ $PAGE -lt 100 ]; do
        VER=$(wget -q "https://hub.docker.com/v2/repositories/library/$DISTRO/tags?page=$PAGE" -O - |
            jq -rc '.results[] | select( .images[].digest == "'"$DIGEST"'" and .name != "latest" ) | .name' |
            grep -E "$FILTER" | sort -Vr | head -n 1)
        ((PAGE += 1))
    done

    echo "$VER"
}

set -eux

VER_NGINX=$(wget -q https://registry.hub.docker.com/v1/repositories/nginx/tags -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n' | cut -d: -f3 | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | grep -E -v "alpine|perl" | sort -Vr | head -n 1)
if [ "$VER_NGINX" = "" ]; then
    echo "Wrong version count in NGINX."
    exit 1
fi

VER_ALMALINUX=$(fetch_latest "almalinux")
if [ "$VER_ALMALINUX" = "" ]; then
    echo "Wrong version count in ALMALINUX."
    exit 1
fi

VER_ALPINE=$(fetch_latest "alpine")
if [ "$VER_ALPINE" = "" ]; then
    echo "Wrong version count in ALPINE."
    exit 1
fi

VER_AMAZONLINUX=$(fetch_latest "amazonlinux")
if [ "$VER_AMAZONLINUX" = "" ]; then
    echo "Wrong version count in AMAZONLINUX."
    exit 1
fi

VER_DEBIAN=$(fetch_latest "debian" "^[0-9]{2}\.[0-9]{1,2}")
if [ "$VER_DEBIAN" = "" ]; then
    echo "Wrong version count in DEBIAN."
    exit 1
fi

VER_FEDORA=$(fetch_latest "fedora")
if [ "$VER_FEDORA" = "" ]; then
    echo "Wrong version count in FEDORA."
    exit 1
fi

VER_UBUNTU=$(fetch_latest "ubuntu" "^[0-9]{2}\.[0-9]{2}")
if [ "$VER_UBUNTU" = "" ]; then
    echo "Wrong version count in UBUNTU."
    exit 1
fi

cp supported_versions supported_versions.bak

echo "nginx=${VER_NGINX}" >supported_versions
echo "almalinux=${VER_ALMALINUX}" >>supported_versions
echo "alpine=${VER_ALPINE}" >>supported_versions
echo "amazonlinux=${VER_AMAZONLINUX}" >>supported_versions
echo "debian=${VER_DEBIAN}" >>supported_versions
echo "fedora=${VER_FEDORA}" >>supported_versions
echo "ubuntu=${VER_UBUNTU}" >>supported_versions

DIFF=$(diff supported_versions supported_versions.bak | wc -l | tr -d ' ')
rm supported_versions.bak
echo "$DIFF"
