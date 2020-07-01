#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004,SC2207,SC2206

VER_NGINX=$(DISTRO=nginx; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E "\d+\.\d+\.\d+" | grep -E -v "alpine|perl" | sort -Vr | head -n1)
NGINX=()
for VER in $VER_NGINX; do
    NGINX+=($VER)
done

VER_ALPINE=$(DISTRO=alpine; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E "\d+\.\d+\.\d+" | sort -Vr | head -n 2)
ALPINE=()
for VER in $VER_ALPINE; do
    ALPINE+=($VER)
done

VER_AMAZONLINUX=$(DISTRO=amazonlinux; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep -E -v "with-|^201" | grep -E "\d+\." | sort -Vr | head -n 2)
AMAZONLINUX=()
for VER in $VER_AMAZONLINUX; do
    AMAZONLINUX+=($VER)
done

VER_CENTOS=$(DISTRO=centos; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | grep -v centos | sort -Vr | head -n 2)
CENTOS=()
for VER in $VER_CENTOS; do
    CENTOS+=($VER)
done

VER_DEBIAN=$(DISTRO=debian; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | grep slim | sort -Vr | head -n 2)
DEBIAN=()
for VER in $VER_DEBIAN; do
    DEBIAN+=($VER)
done

VER_FEDORA=$(DISTRO=fedora; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | sort -nr | head -n 2)
FEDORA=()
for VER in $VER_FEDORA; do
    FEDORA+=($VER)
done

VER_UBUNTU=$(DISTRO=ubuntu; wget -q https://registry.hub.docker.com/v1/repositories/$DISTRO/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep "\." | sort -nr | head -n 2)
UBUNTU=()
for VER in $VER_UBUNTU; do
    UBUNTU+=($VER)
done

IFS=$'\n'
NGINX=($(sort -Vu <<<"${NGINX[*]}"))
ALPINE=($(sort -Vu <<<"${ALPINE[*]}"))
AMAZONLINUX=($(sort -Vu <<<"${AMAZONLINUX[*]}"))
CENTOS=($(sort -Vu <<<"${CENTOS[*]}"))
DEBIAN=($(sort -Vu <<<"${DEBIAN[*]}"))
FEDORA=($(sort -Vu <<<"${FEDORA[*]}"))
UBUNTU=($(sort -Vu <<<"${UBUNTU[*]}"))
unset IFS

echo "NGINX=(\"${NGINX[*]}\")" | sed 's/ /" "/g'
echo "ALPINE=(\"${ALPINE[*]}\")" | sed 's/ /" "/g'
echo "AMAZONLINUX=(\"${AMAZONLINUX[*]}\")" | sed 's/ /" "/g'
echo "CENTOS=(\"${CENTOS[*]}\")" | sed 's/ /" "/g'
echo "DEBIAN=(\"${DEBIAN[*]}\")" | sed 's/ /" "/g'
echo "FEDORA=(\"${FEDORA[*]}\")" | sed 's/ /" "/g'
echo "UBUNTU=(\"${UBUNTU[*]}\")" | sed 's/ /" "/g'
