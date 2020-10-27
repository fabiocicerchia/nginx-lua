#!/bin/bash
# shellcheck disable=SC1091

source supported_versions

function lint() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    PWD=$(pwd)

    docker run --rm -i -v "$PWD"/"$DOCKERFILE":/tmp/Dockerfile -v "$PWD"/.hadolint.yaml:/tmp/.hadolint.yaml hadolint/hadolint hadolint -c /tmp/.hadolint.yaml /tmp/Dockerfile || true
}

set -eux

for NGINX_VER in "${NGINX[@]}"; do

    OS=alpine
    for OS_VER in "${ALPINE[@]}"; do lint; done

    OS=amazonlinux
    for OS_VER in "${AMAZONLINUX[@]}"; do lint; done

    OS=centos
    for OS_VER in "${CENTOS[@]}"; do lint; done

    OS=debian
    for OS_VER in "${DEBIAN[@]}"; do lint; done

    OS=fedora
    for OS_VER in "${FEDORA[@]}"; do lint; done

    OS=ubuntu
    for OS_VER in "${UBUNTU[@]}"; do lint; done

done

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;