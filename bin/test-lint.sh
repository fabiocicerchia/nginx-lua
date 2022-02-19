#!/bin/bash
# shellcheck disable=SC1091

set -eux

for DOCKERFILE in $(find nginx/ -name "Dockerfile*" -type f | sort); do
    docker run --rm -i \
        -v "$PWD"/"$DOCKERFILE":/tmp/Dockerfile \
        -v "$PWD"/.github/linters/.hadolint.yml:/tmp/.hadolint.yml \
        hadolint/hadolint \
        hadolint -c /tmp/.hadolint.yml /tmp/Dockerfile || true
done

find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
