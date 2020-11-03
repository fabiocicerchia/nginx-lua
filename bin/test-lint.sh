#!/bin/bash
# shellcheck disable=SC1091

source ./bin/_common.sh
source supported_versions

function lint() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    PWD=$(pwd)

    docker run --rm -i \
        -v "$PWD"/"$DOCKERFILE":/tmp/Dockerfile \
        -v "$PWD"/.github/linters/.hadolint.yml:/tmp/.hadolint.yml \
        hadolint/hadolint \
        hadolint -c /tmp/.hadolint.yml /tmp/Dockerfile || true
}

set -eux

loop_over_nginx "lint"

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;