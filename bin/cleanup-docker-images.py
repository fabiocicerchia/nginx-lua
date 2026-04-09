#!/usr/bin/env python3
# Delete temporary per-arch tags from Docker Hub:
#   - -amd64 / -arm64v8 tags (single-arch, superseded by signed manifest lists)
# Usage: ./bin/cleanup-docker-images.py
# Requires: DOCKER_HUB_USER and DOCKER_HUB_TOKEN environment variables
import os
import sys

import requests

REPO = "fabiocicerchia/nginx-lua"
SUFFIXES = ("-amd64", "-arm64v8")


def get_token(username, password):
    resp = requests.post(
        "https://hub.docker.com/v2/users/login/",
        json={"username": username, "password": password},
    )
    resp.raise_for_status()
    return resp.json()["token"]


def list_tags(token):
    url = f"https://hub.docker.com/v2/repositories/{REPO}/tags/"
    params = {"page_size": 100}
    while url:
        resp = requests.get(url, headers={"Authorization": f"JWT {token}"}, params=params)
        resp.raise_for_status()
        data = resp.json()
        for tag in data.get("results", []):
            yield tag["name"]
        url = data.get("next")
        params = None  # next URL already contains query params


def should_delete(tag):
    return any(tag.endswith(suffix) for suffix in SUFFIXES)


def delete_tag(token, tag):
    resp = requests.delete(
        f"https://hub.docker.com/v2/repositories/{REPO}/tags/{tag}/",
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

    print(f"=== Listing tags for {REPO} ===")
    deleted = 0
    for tag in list_tags(token):
        if not should_delete(tag):
            continue
        print(f"  Deleting: {REPO}:{tag}")
        status = delete_tag(token, tag)
        if status == 204:
            print("    Deleted OK")
            deleted += 1
        else:
            print(f"    WARN: Delete returned HTTP {status}")

    print(f"=== Done. Cleaned up {deleted} temporary tags. ===")


if __name__ == "__main__":
    main()
