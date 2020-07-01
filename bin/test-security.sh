#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004

source supported_versions

function runtest() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3

    snyk test \
        --project-name=fabiocicerchia/nginx-lua:$NGINX_VER-$OS$OS_VER \
        --severity-threshold=medium \
        --exclude-base-image-vulns \
        --docker fabiocicerchia/nginx-lua:$NGINX_VER-$OS$OS_VER \
        --file=nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile || true

    snyk monitor \
        --project-name=fabiocicerchia/nginx-lua:$NGINX_VER-$OS$OS_VER \
        --severity-threshold=medium \
        --exclude-base-image-vulns \
        --docker fabiocicerchia/nginx-lua:$NGINX_VER-$OS$OS_VER \
        --file=nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile
}

set -x

OS=$1
VERSIONS=()
if [ "$OS" == "alpine" ]; then VERSIONS=$ALPINE
elif [ "$OS" == "amazonlinux" ]; then VERSIONS=$AMAZONLINUX
elif [ "$OS" == "centos" ]; then VERSIONS=$CENTOS
elif [ "$OS" == "debian" ]; then VERSIONS=$DEBIAN
elif [ "$OS" == "fedora" ]; then VERSIONS=$FEDORA
elif [ "$OS" == "ubuntu" ]; then VERSIONS=$UBUNTU
fi

docker run -it --net host --pid host --userns host --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /etc:/etc \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security

NLEN=${#NGINX[@]}
for (( I=0; I<$NLEN; I++ )); do
    NGINX_VER="${NGINX[$I]}"

    DLEN=${#VERSIONS[@]}
    for (( J=0; J<$DLEN; J++ )); do
        OS_VER="${VERSIONS[$J]}"
        runtest $NGINX_VER $OS $OS_VER
    done

done
