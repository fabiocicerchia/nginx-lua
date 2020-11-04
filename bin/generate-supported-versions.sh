#!/bin/bash
# shellcheck disable=SC2207,SC2129

fetch_latest() {
    DISTRO=$1
    FILTER=${2-}
    if [ "$FILTER" == "" ]; then
        FILTER=".+"
    fi
    DIGEST=$(wget -q "https://hub.docker.com/v2/repositories/library/$DISTRO/tags/latest" -O - | jq -rc '.images[] | select( .architecture == "amd64") | .digest')
    wget -q "https://hub.docker.com/v2/repositories/library/$DISTRO/tags" -O - > "/tmp/generate-supported-versions/latest.$DISTRO.p1"
    VER=$(jq -rc '.results[] < "/tmp/generate-supported-versions/latest.$DISTRO.p1" | select( .images[].digest == "'"$DIGEST"'" and .name != "latest" ) | .name' | grep -E "$FILTER" | sort -Vr | head -n 1)

    PAGE=2
    while [ "$VER" = "" ] && [ $PAGE -lt 100 ]; do
        wget -q "https://hub.docker.com/v2/repositories/library/$DISTRO/tags?page=$PAGE" -O - > "/tmp/generate-supported-versions/latest.$DISTRO.p$PAGE"
        VER=$(jq -rc '.results[] < "/tmp/generate-supported-versions/latest.$DISTRO.p$PAGE" | select( .images[].digest == "'"$DIGEST"'" and .name != "latest" ) | .name' | grep -E "$FILTER" | sort -Vr | head -n 1)
        ((PAGE+=1))
    done

    echo "$VER"
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

sleep 5

VER_ALPINE=$(fetch_latest "alpine")
ALPINE=("$VER_ALPINE")
if [ "$VER_ALPINE" = "" ]; then
    echo "Wrong version count in ALPINE."
    exit 1
fi

sleep 5

VER_AMAZONLINUX=$(fetch_latest "amazonlinux")
AMAZONLINUX=("$VER_AMAZONLINUX")
if [ "$VER_AMAZONLINUX" = "" ]; then
    echo "Wrong version count in AMAZONLINUX."
    exit 1
fi

sleep 5

VER_CENTOS=$(fetch_latest "centos" "^\d$")
CENTOS=("$VER_CENTOS")
if [ "$VER_CENTOS" = "" ]; then
    echo "Wrong version count in CENTOS."
    exit 1
fi

sleep 5

VER_DEBIAN=$(fetch_latest "debian" "^\d{2}\.\d{1,2}")
DEBIAN=("$VER_DEBIAN")
if [ "$VER_DEBIAN" = "" ]; then
    echo "Wrong version count in DEBIAN."
    exit 1
fi

sleep 5

VER_FEDORA=$(fetch_latest "fedora")
FEDORA=("$VER_FEDORA")
if [ "$VER_FEDORA" = "" ]; then
    echo "Wrong version count in FEDORA."
    exit 1
fi

sleep 5

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

cp supported_versions supported_versions.bak

echo -n "" > supported_versions
echo "NGINX=(\"${NGINX[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "ALPINE=(\"${ALPINE[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "AMAZONLINUX=(\"${AMAZONLINUX[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "CENTOS=(\"${CENTOS[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "DEBIAN=(\"${DEBIAN[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "FEDORA=(\"${FEDORA[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "UBUNTU=(\"${UBUNTU[*]}\")" | sed 's/ /" "/g' >> supported_versions

DIFF=$(diff supported_versions supported_versions.bak; echo $?)
rm supported_versions.bak
exit "$DIFF"