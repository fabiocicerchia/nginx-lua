#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004

source supported_versions

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    OS=alpine
    for OS_VER in "${ALPINE[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

    OS=amazonlinux
    for OS_VER in "${AMAZONLINUX[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

    OS=centos
    for OS_VER in "${CENTOS[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

    OS=debian
    for OS_VER in "${DEBIAN[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

    OS=fedora
    for OS_VER in "${FEDORA[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

    OS=ubuntu
    for OS_VER in "${UBUNTU[@]}"; do echo nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile; done

done
