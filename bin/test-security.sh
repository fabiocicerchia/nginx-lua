#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function runtest() {
    NGINX_VER=$1
    OS=$2
    OS_VER=$3

    snyk test \
        --project-name=fabiocicerchia/nginx-lua:"$NGINX_VER-$OS$OS_VER" \
        --severity-threshold=medium \
        --exclude-base-image-vulns \
        --docker fabiocicerchia/nginx-lua:"$NGINX_VER-$OS$OS_VER" \
        --file="nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile" || true

    snyk monitor \
        --project-name=fabiocicerchia/nginx-lua:"$NGINX_VER-$OS$OS_VER" \
        --severity-threshold=medium \
        --exclude-base-image-vulns \
        --docker fabiocicerchia/nginx-lua:"$NGINX_VER-$OS$OS_VER" \
        --file="nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile"
}

set -eux

OS=$1
VERSIONS=($(get_versions "$OS"))

docker run -it --net host --pid host --userns host --cap-add audit_control \
    -v /etc:/etc \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security

loop_over_nginx_with_os "$OS" "runtest"
