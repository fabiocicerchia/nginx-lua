#!/bin/bash
# Delete temporary tags from Docker Hub:
#   - -unsigned tags (pre-signing staging tags)
#   - -amd64 / -arm64v8 tags (single-arch, superseded by manifest lists)
# Usage: ./bin/cleanup-unsigned-tags.sh
# Requires: DOCKER_HUB_USER and DOCKER_HUB_TOKEN environment variables
set -euo pipefail

REPO="fabiocicerchia/nginx-lua"

if [ -z "${DOCKER_HUB_USER:-}" ] || [ -z "${DOCKER_HUB_TOKEN:-}" ]; then
    echo "ERROR: DOCKER_HUB_USER and DOCKER_HUB_TOKEN must be set"
    exit 1
fi

echo "=== Fetching Docker Hub token ==="
TOKEN=$(curl -s -H "Content-Type: application/json" \
    -X POST -d "{\"username\":\"${DOCKER_HUB_USER}\",\"password\":\"${DOCKER_HUB_TOKEN}\"}" \
    "https://hub.docker.com/v2/users/login/" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

echo "=== Listing tags for ${REPO} ==="

PAGE=1
DELETED=0

while true; do
    RESPONSE=$(curl -s -H "Authorization: JWT ${TOKEN}" \
        "https://hub.docker.com/v2/repositories/${REPO}/tags/?page_size=100&page=${PAGE}")

    TAGS=$(echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for tag in data.get('results', []):
    print(tag['name'])
" 2>/dev/null || true)

    if [ -z "$TAGS" ]; then
        break
    fi

    echo "$TAGS" | while read -r TAG; do
        DELETE=false
        # Match -unsigned tags (staging tags before signing)
        if [[ "$TAG" == *"-unsigned" ]]; then
            DELETE=true
        fi
        # Match single-arch tags (superseded by manifest lists after bundle)
        if [[ "$TAG" == *"-amd64" ]] || [[ "$TAG" == *"-arm64v8" ]]; then
            DELETE=true
        fi

        if [ "$DELETE" = true ]; then
            echo "  Deleting: ${REPO}:${TAG}"
            HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
                -X DELETE -H "Authorization: JWT ${TOKEN}" \
                "https://hub.docker.com/v2/repositories/${REPO}/tags/${TAG}/")
            if [ "$HTTP_CODE" = "204" ]; then
                echo "    Deleted OK"
                DELETED=$((DELETED + 1))
            else
                echo "    WARN: Delete returned HTTP ${HTTP_CODE}"
            fi
        fi
    done

    # Check if there are more pages
    NEXT=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('next') or '')" 2>/dev/null || true)
    if [ -z "$NEXT" ]; then
        break
    fi
    PAGE=$((PAGE + 1))
done

echo "=== Done. Cleaned up unsigned and single-arch tags. ==="
