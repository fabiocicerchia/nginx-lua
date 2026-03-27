#!/bin/bash
# Secure dependency downloader with integrity verification
# Ref: SLSA Level 2 - verified source integrity
# Ref: Cyber Resilience Act Article 47 - supply chain integrity
set -euo pipefail

URL="$1"
OUTPUT="$2"
EXPECTED_SHA256="${3:-}"

echo "Downloading: ${URL}"
echo "  -> ${OUTPUT}"

# Download with fail-on-error
curl -sfLo "$OUTPUT" "$URL"

if [ ! -f "$OUTPUT" ]; then
    echo "ERROR: Download failed for ${URL}"
    exit 1
fi

ACTUAL_SHA256=$(sha256sum "$OUTPUT" | awk '{print $1}')
echo "  SHA256: ${ACTUAL_SHA256}"

if [ -n "$EXPECTED_SHA256" ]; then
    if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
        echo "ERROR: Checksum mismatch!"
        echo "  Expected: ${EXPECTED_SHA256}"
        echo "  Actual:   ${ACTUAL_SHA256}"
        rm -f "$OUTPUT"
        exit 1
    fi
    echo "  Checksum verified OK"
else
    echo "  WARNING: No expected checksum provided - recording for future verification"
    echo "  To pin this dependency, add SHA256=${ACTUAL_SHA256} to checksums.sha256"
fi
