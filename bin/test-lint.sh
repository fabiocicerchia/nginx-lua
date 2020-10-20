#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004,SC2044

for FILE in $(find nginx -type f); do
    echo $FILE
    docker run --rm -i -v $PWD/$FILE:/tmp/Dockerfile -v $PWD/.hadolint.yaml:/tmp/.hadolint.yaml hadolint/hadolint hadolint -c /tmp/.hadolint.yaml /tmp/Dockerfile || true
done
