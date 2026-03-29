#!/bin/bash
# Vulnerability scanning gate - blocks push if CRITICAL/HIGH CVEs found
# Ref: Cyber Resilience Act Article 11 - vulnerability handling
# Ref: NIS2 Article 21(2)(e) - vulnerability disclosure and handling
set -euo pipefail

IMAGE_REF="$1"
SEVERITY_THRESHOLD="${2:-CRITICAL,HIGH}"
EXIT_CODE_ON_VULN="${3:-1}"

if [ -z "$IMAGE_REF" ]; then
    echo "Usage: $0 <image-reference> [severity-threshold] [exit-code-on-vuln]"
    echo "Example: $0 fabiocicerchia/nginx-lua:latest CRITICAL,HIGH 1"
    exit 1
fi

if ! command -v trivy &> /dev/null; then
    echo "FATAL: trivy is not installed. Install it before running this script."
    exit 1
fi

echo "=== Scanning image: ${IMAGE_REF} ==="
echo "Severity threshold: ${SEVERITY_THRESHOLD}"

# Create output directory
REPORT_DIR="/tmp/trivy-reports"
mkdir -p "$REPORT_DIR"

SAFE_NAME=$(echo "$IMAGE_REF" | tr '/:' '-')

# Scan for vulnerabilities (table output for CI logs)
echo ""
echo "--- OS and Library Vulnerabilities ---"
trivy image \
    --severity "$SEVERITY_THRESHOLD" \
    --exit-code "$EXIT_CODE_ON_VULN" \
    --format table \
    --ignore-unfixed \
    "$IMAGE_REF" | tee "${REPORT_DIR}/${SAFE_NAME}-vuln.txt"

VULN_EXIT=$?

# Also generate JSON report for audit trail
trivy image \
    --severity "$SEVERITY_THRESHOLD" \
    --format json \
    --ignore-unfixed \
    --output "${REPORT_DIR}/${SAFE_NAME}-vuln.json" \
    "$IMAGE_REF" || true

# Scan for misconfigurations
echo ""
echo "--- Dockerfile/Config Misconfigurations ---"
trivy image \
    --scanners misconfig \
    --format table \
    "$IMAGE_REF" | tee "${REPORT_DIR}/${SAFE_NAME}-misconfig.txt" || true

# Scan for secrets
echo ""
echo "--- Secret Detection ---"
trivy image \
    --scanners secret \
    --format table \
    "$IMAGE_REF" | tee "${REPORT_DIR}/${SAFE_NAME}-secrets.txt"

SECRET_EXIT=$?

if [ "$SECRET_EXIT" -ne 0 ]; then
    echo "FAIL: Secrets detected in image!"
    exit 1
fi

if [ "$VULN_EXIT" -ne 0 ]; then
    echo "FAIL: ${SEVERITY_THRESHOLD} vulnerabilities found in ${IMAGE_REF}"
    echo "Review the report at ${REPORT_DIR}/${SAFE_NAME}-vuln.json"
    exit 1
fi

echo ""
echo "=== PASS: No ${SEVERITY_THRESHOLD} vulnerabilities found ==="
