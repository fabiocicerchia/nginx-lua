#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004,SC2207,SC2206

set -x

VER_NGINX=$(DISTRO=nginx; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E "\d+\.\d+\.\d+" | grep -E -v "alpine|perl" | sort -Vr | head -n1)
NGINX=()
for VER in $VER_NGINX; do
    NGINX+=($VER)
done
if [ "$#NGINX[@]" != "1" ]; then
    echo "Wrong version count in NGINX."
    exit 1
fi

VER_ALPINE=$(DISTRO=alpine; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E "\d+\.\d+\.\d+" | sort -Vr | head -n 2)
ALPINE=()
for VER in $VER_ALPINE; do
    ALPINE+=($VER)
done
if [ "$#ALPINE[@]" != "2" ]; then
    echo "Wrong version count in ALPINE."
    exit 1
fi

VER_AMAZONLINUX=$(DISTRO=amazonlinux; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E -v "with-|^201" | grep -E "\d+\." | sort -Vr | head -n 2)
AMAZONLINUX=()
for VER in $VER_AMAZONLINUX; do
    AMAZONLINUX+=($VER)
done
if [ "$#AMAZONLINUX[@]" != "2" ]; then
    echo "Wrong version count in AMAZONLINUX."
    exit 1
fi

VER_CENTOS=$(DISTRO=centos; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | grep -v centos | sort -Vr | head -n 2)
CENTOS=()
for VER in $VER_CENTOS; do
    CENTOS+=($VER)
done
if [ "$#CENTOS[@]" != "2" ]; then
    echo "Wrong version count in CENTOS."
    exit 1
fi

VER_DEBIAN=$(DISTRO=debian; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | grep slim | sort -Vr | head -n 2)
DEBIAN=()
for VER in $VER_DEBIAN; do
    DEBIAN+=($VER)
done
if [ "$#DEBIAN[@]" != "2" ]; then
    echo "Wrong version count in DEBIAN."
    exit 1
fi

VER_FEDORA=$(DISTRO=fedora; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | sort -nr | head -n 2)
FEDORA=()
for VER in $VER_FEDORA; do
    FEDORA+=($VER)
done
if [ "$#FEDORA[@]" != "2" ]; then
    echo "Wrong version count in FEDORA."
    exit 1
fi

VER_UBUNTU=$(DISTRO=ubuntu; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | sort -nr | head -n 2)
UBUNTU=()
for VER in $VER_UBUNTU; do
    UBUNTU+=($VER)
done
if [ "$#UBUNTU[@]" != "2" ]; then
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

echo "NGINX=(\"${NGINX[*]}\")" | sed 's/ /" "/g' > supported_versions
echo "ALPINE=(\"${ALPINE[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "AMAZONLINUX=(\"${AMAZONLINUX[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "CENTOS=(\"${CENTOS[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "DEBIAN=(\"${DEBIAN[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "FEDORA=(\"${FEDORA[*]}\")" | sed 's/ /" "/g' >> supported_versions
echo "UBUNTU=(\"${UBUNTU[*]}\")" | sed 's/ /" "/g' >> supported_versions
