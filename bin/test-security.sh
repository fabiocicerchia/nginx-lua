#!/bin/bash
# shellcheck disable=SC1091,SC2207

set -eux

docker run -it --net host --pid host --userns host --cap-add audit_control \
    -v /etc:/etc \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security

source supported_versions

find nginx/{$nginx_mainline,$nginx_stable} -mindepth 1 -maxdepth 1 -type d | while read OS_FOLDER; do
    OS=$(basename "$OS_FOLDER")
    TAG="$nginx_mainline-$OS-${!OS}"
    docker scan fabiocicerchia/nginx-lua:"$TAG"
done

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
