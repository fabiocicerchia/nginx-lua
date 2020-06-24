#!/bin/bash

for FILE in $(find nginx -type f); do
    docker run --rm -i hadolint/hadolint < $FILE || true
done
