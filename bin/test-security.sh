#!/bin/bash
# shellcheck disable=SC1091,SC2207

set -eux

docker run -it --net host --pid host --userns host --cap-add audit_control \
    -v /etc:/etc \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --label docker_bench_security \
    docker/docker-bench-security

for DOCKERFILE in $(find nginx/ -name "Dockerfile*" -type f | sort); do
    TAG=$(echo "$DOCKERFILE" | awk -F '/' '{print $2"-"$3$4}')
    docker scan fabiocicerchia/nginx-lua:"$TAG"
done

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
