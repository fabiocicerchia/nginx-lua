#!/bin/bash
# shellcheck disable=SC1091

set -eux

# Main execution
main() {
    find nginx/ -name "Dockerfile*" -type f -exec docker run --rm -i \
        -v "${PWD}/{}":/tmp/Dockerfile \
        -v "${PWD}.github/linters/.hadolint.yml:/tmp/.hadolint.yml \
        hadolint/hadolint \
        hadolint -c /tmp/.hadolint.yml /tmp/Dockerfile;

    find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
}

# Run main function with all arguments
main "$@"
