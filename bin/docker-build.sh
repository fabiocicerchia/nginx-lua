#!/bin/bash
# shellcheck disable=SC1091,SC2086,SC2207

source ./bin/_common.sh
source ./bin/_func_build.sh
source supported_versions

set -eux

OS=$1
FORCE=${2:-NO}
EXTENDED_IMAGE=${3:-YES}
VERSIONS=($(get_versions "$OS"))

MULTI_ARCH=1

loop_over_nginx_with_os "$OS" "build_classic"
loop_over_nginx_with_os "$OS" "build_compat"

docker images
