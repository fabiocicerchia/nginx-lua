#!/usr/bin/env python3
# Delete temporary per-arch tags from Docker Hub:
#   - -amd64 / -arm64v8 tags (single-arch, superseded by signed manifest lists)
# Usage: ./bin/cleanup-docker-images.py
# Requires: DOCKER_HUB_USER and DOCKER_HUB_TOKEN environment variables
#   DOCKER_HUB_TOKEN must be a Personal Access Token with "Delete" scope,
#   otherwise every delete returns HTTP 403.
import os
import sys
import time

import requests

REPO = "fabiocicerchia/nginx-lua"
SUFFIXES = ("-amd64", "-arm64v8")

API = "https://hub.docker.com/v2"
DELETE_DELAY = 0.5      # seconds between deletes, to stay under the rate limit
MAX_RETRIES = 5         # retries on HTTP 429
MAX_AUTH_FAILURES = 5   # abort after this many consecutive 403s (bad token scope)

session = requests.Session()


def request_with_backoff(method, url, **kwargs):
    """Issue a request, retrying on HTTP 429 and honouring Retry-After."""
    resp = None
    for attempt in range(MAX_RETRIES):
        resp = session.request(method, url, **kwargs)
        if resp.status_code != 429:
            return resp
        retry_after = int(resp.headers.get("Retry-After", 2 ** attempt))
        print(
            f"    Rate limited (429); sleeping {retry_after}s "
            f"(attempt {attempt + 1}/{MAX_RETRIES})"
        )
        time.sleep(retry_after)
    return resp  # last response, still 429


def get_token(username, password):
    resp = session.post(
        f"{API}/users/login/",
        json={"username": username, "password": password},
    )
    resp.raise_for_status()
    return resp.json()["token"]


def list_tags(token):
    url = f"{API}/repositories/{REPO}/tags/"
    params = {"page_size": 100}
    headers = {"Authorization": f"JWT {token}"}
    while url:
        resp = request_with_backoff("GET", url, headers=headers, params=params)
        resp.raise_for_status()
        data = resp.json()
        for tag in data.get("results", []):
            yield tag["name"]
        url = data.get("next")
        params = None  # next URL already contains query params


def should_delete(tag):
    return any(tag.endswith(suffix) for suffix in SUFFIXES)


def delete_tag(token, tag):
    resp = request_with_backoff(
        "DELETE",
        f"{API}/repositories/{REPO}/tags/{tag}/",
        headers={"Authorization": f"JWT {token}"},
    )
    return resp.status_code


def main():
    username = os.environ.get("DOCKER_HUB_USER", "")
    password = os.environ.get("DOCKER_HUB_TOKEN", "")
    if not username or not password:
        print("ERROR: DOCKER_HUB_USER and DOCKER_HUB_TOKEN must be set")
        sys.exit(1)

    print("=== Fetching Docker Hub token ===")
    token = get_token(username, password)

    # Collect the full list first, so listing isn't interleaved with the
    # (rate-limited) deletes and a later page can't crash a half-done run.
    print(f"=== Listing tags for {REPO} ===")
    tags = [tag for tag in list_tags(token) if should_delete(tag)]
    print(f"=== {len(tags)} temporary tags to delete ===")

    deleted = 0
    auth_failures = 0
    for tag in tags:
        print(f"  Deleting: {REPO}:{tag}")
        status = delete_tag(token, tag)
        if status == 204:
            print("    Deleted OK")
            deleted += 1
            auth_failures = 0
        elif status == 403:
            auth_failures += 1
            print("    WARN: HTTP 403 (token lacks delete permission?)")
            if auth_failures >= MAX_AUTH_FAILURES:
                print(
                    "ERROR: Aborting after repeated 403s. DOCKER_HUB_TOKEN must "
                    "be a Personal Access Token with 'Delete' scope, and the "
                    "account must own/admin the repository."
                )
                sys.exit(1)
        else:
            print(f"    WARN: Delete returned HTTP {status}")
        time.sleep(DELETE_DELAY)

    print(f"=== Done. Cleaned up {deleted} temporary tags. ===")


if __name__ == "__main__":
    main()
