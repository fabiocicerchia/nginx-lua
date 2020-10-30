#!/bin/bash
# shellcheck disable=SC2207,SC2129

fetch_latest() {
    DISTRO=$1
    FILTER=${2-}
    if [ "$FILTER" == "" ]; then
        FILTER=".+"
    fi
    DIGEST=$(curl "https://hub.docker.com/v2/repositories/library/$DISTRO/tags/latest" | jq -rc '.images[] | select( .architecture == "amd64") | .digest')
    curl "https://hub.docker.com/v2/repositories/library/$DISTRO/tags" > /tmp/latest.$DISTRO
    VER=$(cat /tmp/latest.$DISTRO | jq -rc '.results[] | select( .images[].digest == "'$DIGEST'" and .name != "latest" ) | .name' | grep -E "$FILTER" | sort -Vr | head -n 1)

    PAGE=2
    while [ "$VER" = "" -a $PAGE -lt 100 ]; do
        cat /tmp/latest.$DISTRO
        VER=$(curl "https://hub.docker.com/v2/repositories/library/$DISTRO/tags?page=$PAGE" | jq -rc '.results[] | select( .images[].digest == "'$DIGEST'" and .name != "latest" ) | .name' | grep -E "$FILTER" | sort -Vr | head -n 1)
        ((PAGE+=1))
    done

    echo $VER
}

set -eux

VER_NGINX=$(DISTRO=nginx; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O - | sed -e 's/ß[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | cut -d: -f3 | grep -E "[0-9]+\.[0-9]+\.[0-9]+" | grep -E -v "alpine|perl" | sort -Vr | head -n 1)
NGINX=()
for VER in $VER_NGINX; do
    NGINX+=("$VER")
done
if [ "${#NGINX[@]}" != "1" ]; then
    echo "Wrong version count in NGINX."
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

VER_CENTOS=$(fetch_latest "centos" "^\d$")
CENTOS=("$VER_CENTOS")
if [ "$VER_CENTOS" = "" ]; then
    echo "Wrong version count in CENTOS."
    exit 1
fi

VER_DEBIAN=$(fetch_latest "debian" "^\d{2}\.\d{1,2}")
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

VER_UBUNTU=$(fetch_latest "ubuntu" "^\d{2}\.\d{2}")
UBUNTU=("$VER_UBUNTU")
if [ "$VER_UBUNTU" = "" ]; then
    echo "Wrong version count in UBUNTU."
    exit 1
fi

IFS=$'\n'
NGINX=($(sort -Vu <<<"${NGINX[*]}"))
ALPINE=($(sort -Vu <<<"${ALPINE[*]}"))
AMAZONLINUX=($(sort -Vu <<<"${AMAZONLINUX[*]}"))
CENTOS=($(sort -Vu <<<"${CENTOS[*]}"))
DEBIAN=($(sort -Vu <<<"${DEBIAN[*]}"))
FEDORA=($(sort -Vu <<<"${FEDORA[*]}"))
UBUNTU=($(sort -Vu <<<"${UBUNTU[*]}"))
unset IFS

echo -n "" > supported_versions
echo "NGINX=(\"${NGINX[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "ALPINE=(\"${ALPINE[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "AMAZONLINUX=(\"${AMAZONLINUX[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "CENTOS=(\"${CENTOS[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "DEBIAN=(\"${DEBIAN[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "FEDORA=(\"${FEDORA[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "UBUNTU=(\"${UBUNTU[*]}\")" | sed 's/ /" "/g' >> supported_versions
