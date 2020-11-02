#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function show_supported() {
    echo "nginx/$NGINX_VER/$OS/$OS_VER/Dockerfile"
}

loop_over_nginx "show_supported"