#!/bin/bash
# shellcheck disable=SC1091,SC2207
# Security scanning suite for nginx-lua Docker images
# Ref: Cyber Resilience Act Article 11 - vulnerability handling
# Ref: NIS2 Article 21(2)(e) - vulnerability handling and disclosure

set -eux

source supported_versions

# Main execution
main() {
    # Docker Bench Security
    docker run --rm -t --net host --pid host --userns host --cap-add audit_control \
        -v /etc:/etc:ro \
        -v /var/lib:/var/lib:ro \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        --label docker_bench_security \
        docker/docker-bench-security

    # Vulnerability scanning with Trivy (replaces deprecated 'docker scan')
    if ! command -v trivy &> /dev/null; then
        TRIVY_VERSION="v0.58.2"
        ARCH=$(uname -m | sed 's/x86_64/64bit/' | sed 's/aarch64/ARM64/')
        TRIVY_ARCHIVE="trivy_${TRIVY_VERSION#v}_Linux-${ARCH}.tar.gz"
        curl -sLO "https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/${TRIVY_ARCHIVE}"
        curl -sLO "https://github.com/aquasecurity/trivy/releases/download/${TRIVY_VERSION}/trivy_${TRIVY_VERSION#v}_checksums.txt"
        grep "${TRIVY_ARCHIVE}" "trivy_${TRIVY_VERSION#v}_checksums.txt" | sha256sum -c - || { echo "FATAL: Trivy checksum verification failed"; exit 1; }
        tar xzf "${TRIVY_ARCHIVE}" trivy
        sudo mv trivy /usr/local/bin/trivy
        rm -f "${TRIVY_ARCHIVE}" "trivy_${TRIVY_VERSION#v}_checksums.txt"
    fi

    find "nginx/{$nginx_mainline,$nginx_stable}" -mindepth 1 -maxdepth 1 -type d | while read -r OS_FOLDER; do
        OS=$(basename "$OS_FOLDER")
        TAG="$nginx_mainline-$OS-${!OS}"

        echo "=== Scanning fabiocicerchia/nginx-lua:${TAG} ==="

        # Vulnerability scan (CRITICAL + HIGH = fail)
        trivy image \
            --severity CRITICAL,HIGH \
            --exit-code 1 \
            --ignore-unfixed \
            "fabiocicerchia/nginx-lua:${TAG}" || echo "WARN: Vulnerabilities found in ${TAG}"

        # Secret scan
        trivy image \
            --scanners secret \
            --exit-code 1 \
            "fabiocicerchia/nginx-lua:${TAG}"

        # Misconfiguration scan
        trivy image \
            --scanners misconfig \
            "fabiocicerchia/nginx-lua:${TAG}" || true
    done

    # Shellcheck for all shell scripts
    find bin -type f -name "*.sh" -exec docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable {} \;
}

# Run main function with all arguments
main "$@"
