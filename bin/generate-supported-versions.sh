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

DISTRO=nginx
VER_NGINX=$(wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n' | cut -d: -f3 | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | grep -E -v "alpine|perl" | sort -Vr | head -n 1)
NGINX=()
for VER in $VER_NGINX; do
    NGINX+=("$VER")
done
if [ "${#NGINX[@]}" != "1" ]; then
    echo "Wrong version count in NGINX."
    exit 1
fi

VER_ALMALINUX=$(fetch_latest "almalinux")
ALMALINUX=("$VER_ALMALINUX")
if [ "$VER_ALMALINUX" = "" ]; then
    echo "Wrong version count in ALMALINUX."
    exit 1
fi

VER_ALPINE=$(fetch_latest "alpine")
ALPINE=("$VER_ALPINE")
if [ "$VER_ALPINE" = "" ]; then
    echo "Wrong version count in ALPINE."
    exit 1
fi

VER_AMAZONLINUX=$(fetch_latest "amazonlinux")
AMAZONLINUX=("$VER_AMAZONLINUX")
if [ "$VER_AMAZONLINUX" = "" ]; then
    echo "Wrong version count in AMAZONLINUX."
    exit 1
fi

VER_DEBIAN=$(fetch_latest "debian" "^[0-9]{2}\.[0-9]{1,2}")
DEBIAN=("$VER_DEBIAN")
if [ "$VER_DEBIAN" = "" ]; then
    echo "Wrong version count in DEBIAN."
    exit 1
fi

VER_FEDORA=$(fetch_latest "fedora")
FEDORA=("$VER_FEDORA")
if [ "$VER_FEDORA" = "" ]; then
    echo "Wrong version count in FEDORA."
    exit 1
fi

VER_UBUNTU=$(fetch_latest "ubuntu" "^[0-9]{2}\.[0-9]{2}")
UBUNTU=("$VER_UBUNTU")
if [ "$VER_UBUNTU" = "" ]; then
    echo "Wrong version count in UBUNTU."
    exit 1
fi

IFS=$'\n'
NGINX=($(sort -Vu <<<"${NGINX[*]}"))
ALMALINUX=($(sort -Vu <<<"${ALMALINUX[*]}"))
ALPINE=($(sort -Vu <<<"${ALPINE[*]}"))
AMAZONLINUX=($(sort -Vu <<<"${AMAZONLINUX[*]}"))
DEBIAN=($(sort -Vu <<<"${DEBIAN[*]}"))
FEDORA=($(sort -Vu <<<"${FEDORA[*]}"))
UBUNTU=($(sort -Vu <<<"${UBUNTU[*]}"))
unset IFS

cp supported_versions supported_versions.bak

echo "NGINX=(\"${NGINX[*]}\")" | sed 's/ /" "/g' >supported_versions
echo "ALMALINUX=(\"${ALMALINUX[*]}\")" | sed 's/ /" "/g' >>supported_versions
echo "ALPINE=(\"${ALPINE[*]}\")" | sed 's/ /" "/g' >>supported_versions
echo "AMAZONLINUX=(\"${AMAZONLINUX[*]}\")" | sed 's/ /" "/g' >>supported_versions
echo "DEBIAN=(\"${DEBIAN[*]}\")" | sed 's/ /" "/g' >>supported_versions
echo "FEDORA=(\"${FEDORA[*]}\")" | sed 's/ /" "/g' >>supported_versions
echo "UBUNTU=(\"${UBUNTU[*]}\")" | sed 's/ /" "/g' >>supported_versions

DIFF=$(diff supported_versions supported_versions.bak | wc -l | tr -d ' ')
rm supported_versions.bak
echo "$DIFF"
