#!/bin/bash
# shellcheck disable=SC2086,SC2178,SC1091,SC2004,SC2044

for FILE in $(find nginx -type f); do
    docker run --rm -i hadolint/hadolint < $FILE || true
done
