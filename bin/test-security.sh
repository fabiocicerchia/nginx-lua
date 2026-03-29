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
        echo "FATAL: trivy is not installed. Install it before running this script."
        exit 1
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
