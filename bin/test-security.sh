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

for OS_FOLDER in $(find nginx/$nginx -mindepth 1 -maxdepth 1 -type d); do
    OS=$(echo "$OS_FOLDER" | awk -F '/' '{print $NF}')
    TAG=$(echo "$OS_FOLDER/${!OS}/Dockerfile" | awk -F '/' '{print $2"-"$3$4}')
    docker scan fabiocicerchia/nginx-lua:"$TAG"

    TAG=$(echo "$OS_FOLDER/${!OS}/Dockerfile-compat" | awk -F '/' '{print $2"-"$3$4}')
    docker scan fabiocicerchia/nginx-lua:"$TAG"
done

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
