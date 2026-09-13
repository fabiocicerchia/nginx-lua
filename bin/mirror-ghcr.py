#!/usr/bin/env python3
"""
Mirror the published multi-arch manifest lists from Docker Hub to GHCR.

Only the default distro (alpine) is mirrored — GHCR is a secondary channel,
not a full replica of Docker Hub.

Runs after `docker manifest push` (make bundle-alpine) has published the
manifest lists, and copies each tag with `docker buildx imagetools create`,
which re-points the tag at the very same manifest list (both architectures)
in the destination registry. Tags come from common.generate_tags(), so the
GHCR tag set can never drift from the one Docker Hub received.

Cosign signatures are not copied by imagetools — the caller signs the
mirrored index separately (see `make sign-manifest`).
"""

import argparse
import common

GHCR_REPO = "ghcr.io/fabiocicerchia/nginx-lua/nginx-lua"

IMAGETOOLS_CREATE_COMMAND = "docker buildx imagetools create"


def tag_name(image_ref):
    """Strip the repository prefix from a full image reference."""
    return image_ref.split(":", 1)[1]


def mirror_images(nginx_version, os_distro, os_version, dry_run=False):
    """Copy every tag of one (nginx_version, distro) pair to GHCR."""
    for source in common.generate_tags(nginx_version, os_distro, os_version):
        target = f"{GHCR_REPO}:{tag_name(source)}"
        cmd = f"{IMAGETOOLS_CREATE_COMMAND} -t {target} {source}"

        if dry_run:
            print(cmd)
            continue

        if common.run_command(cmd, True)[0] != 0:
            print(f"FATAL: Failed to mirror {source} to {target}")
            return 1

    return 0


def main():
    parser = argparse.ArgumentParser(
        description="Mirror nginx-lua images from Docker Hub to GHCR"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="print the commands that would run without touching any registry",
    )
    args = parser.parse_args()

    versions = common.load_supported_versions()

    common.for_mainline_and_stable(
        mirror_images, versions, common.DEFAULT_DISTRO, args.dry_run
    )


if __name__ == "__main__":
    main()
