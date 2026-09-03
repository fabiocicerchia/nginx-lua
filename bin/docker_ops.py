"""
Docker build, push, manifest and inspect plumbing for nginx-lua images.

Everything here shells out to `docker` (or `git`, for the build metadata that
goes into the image). The tag vocabulary, the Dockerfile templating and the
supported-version knowledge it works from live in common.py.
"""

import os
import shlex
import subprocess
from datetime import datetime, timezone

import common

# Docker constants
DOCKER_BUILD_COMMAND = "docker build"
DOCKER_PUSH_COMMAND = "docker push"
DOCKER_PULL_COMMAND = "docker pull"
DOCKER_INSPECT_COMMAND = "docker image inspect"
DOCKER_MANIFEST_CREATE = "docker manifest create"
DOCKER_MANIFEST_PUSH = "docker manifest push"
DOCKER_TAG_COMMAND = "docker tag"
DOCKER_IMAGES_COMMAND = "docker images"

# Git constants
GIT_REV_PARSE_COMMAND = "git rev-parse --short HEAD"
GIT_COMMIT_DATE_COMMAND = "git log -1 --format=%ct"

# Architecture constants
AMD64_ARCH = "amd64"
ARM64V8_ARCH = "arm64v8"
ARCHITECTURES = [AMD64_ARCH, ARM64V8_ARCH]

# Build arguments
ARCH_BUILD_ARG = "ARCH"
BUILD_DATE_BUILD_ARG = "BUILD_DATE"
VCS_REF_BUILD_ARG = "VCS_REF"

# Date format
BUILD_DATE_FORMAT = "%Y-%m-%dT00:00:00Z"

# Documentation
DOCS_METADATA_DIR = "docs/metadata"


def run_command(command, print_stdout=True):
    """Run a shell command and return exit code and output."""
    print(f"Running: {command}")

    process = subprocess.Popen(
        shlex.split(command), shell=False, stdout=subprocess.PIPE
    )

    streamdata = process.communicate()[0]
    output_lines = streamdata.decode("utf-8")
    if print_stdout:
        print(output_lines)

    return [process.returncode, output_lines]


def get_build_date():
    """Derive BUILD_DATE from the current commit's timestamp rather than
    wall-clock build time.

    Rebuilding the exact same commit (e.g. a CI rerun of a single job,
    whether same-day or not) then always produces the identical BUILD_DATE
    build-arg, so the resulting image digest is identical too. A rerun
    becomes a genuine no-op instead of silently pushing a new, unsigned
    digest under an already-signed tag and orphaning the earlier signature.
    """
    commit_epoch = subprocess.check_output(
        shlex.split(GIT_COMMIT_DATE_COMMAND), text=True
    ).strip()
    return datetime.fromtimestamp(int(commit_epoch), tz=timezone.utc).strftime(
        BUILD_DATE_FORMAT
    )


def build_docker_image(vcs_ref, tags, dockerfile_path, arch):
    """Build Docker image with given parameters."""
    tag_params = " ".join([f"-t {tag}" for tag in tags])
    build_date = get_build_date()

    tarball_path = common.get_tarball_path(dockerfile_path)
    os.makedirs(os.path.dirname(tarball_path), exist_ok=True)

    build_command = f"""
        {DOCKER_BUILD_COMMAND}
        --progress=plain
        --build-arg {ARCH_BUILD_ARG}="{arch}"
        --build-arg {BUILD_DATE_BUILD_ARG}="{build_date}"
        --build-arg {VCS_REF_BUILD_ARG}="{vcs_ref}"
        {tag_params}
        -f {dockerfile_path} {os.path.dirname(dockerfile_path)}
    """

    return run_command(build_command, True)[0]


def build_image(nginx_version, os_distro, os_version, arch):
    """Build Docker image for given configuration."""
    dockerfile_path = common.get_dockerfile_path(nginx_version, os_distro, os_version)
    tags = common.generate_tags(nginx_version, os_distro, os_version, arch)
    vcs_ref = subprocess.check_output(
        shlex.split(GIT_REV_PARSE_COMMAND), text=True
    ).strip()

    return build_docker_image(vcs_ref, tags, dockerfile_path, arch)


def push_docker_image(tag):
    """Push Docker image to registry with retry."""
    cmd = f"{DOCKER_PUSH_COMMAND} {tag}"
    exit_code = run_command(cmd, True)[0]

    # Retry once if failed
    if exit_code != 0:
        exit_code = run_command(cmd, True)[0]

    return exit_code


def push_images(nginx_version, os_distro, os_version, arch=None):
    """Push per-arch images to the registry.

    Pushes images directly (without -unsigned suffix) since signing is
    done on the multi-arch manifest list after bundling, not on per-arch
    images.

    If arch is provided, only images for that architecture are processed.
    This is the expected behaviour in CI where each runner builds only
    for its own architecture.
    """
    arches = [arch] if arch else ARCHITECTURES
    for current_arch in arches:
        tags = common.generate_tags(nginx_version, os_distro, os_version, current_arch)
        for tag in tags:
            exit_code = push_docker_image(tag)
            if exit_code != 0:
                print(f"FATAL: Failed to push image {tag}")
                return exit_code

    return 0


def create_manifest(tag):
    """Create and push multi-arch manifest."""
    tag_amd64 = f"{tag}-{AMD64_ARCH}"
    tag_arm64 = f"{tag}-{ARM64V8_ARCH}"

    # Create manifest
    create_cmd = f"""
        {DOCKER_MANIFEST_CREATE}
        {tag}
        --amend {tag_amd64}
        --amend {tag_arm64}
    """
    exit_code = run_command(create_cmd, True)[0]
    if exit_code != 0:
        return 1

    # Push manifest
    push_cmd = f"{DOCKER_MANIFEST_PUSH} {tag}"
    return run_command(push_cmd, True)[0]


def bundle_images(nginx_version, os_distro, os_version):
    """Create multi-arch manifests for all tags."""
    tags = common.generate_tags(nginx_version, os_distro, os_version, "")

    for tag in tags:
        exit_code = create_manifest(tag)
        if exit_code != 0:
            return 1

    return 0


def generate_metadata(tag):
    """Generate metadata documentation for image tag.

    Tries to inspect the image locally first to avoid unnecessary Docker Hub
    pulls (and the associated rate-limit pressure).  Falls back to pulling only
    when the image is not available in the local daemon.
    """
    image_ref = f"{common.IMAGE_REPO}:{tag}"
    inspect_cmd = f"{DOCKER_INSPECT_COMMAND} {image_ref}"

    # Try inspecting the local image first (no registry pull required).
    exit_code, inspect_output = run_command(inspect_cmd, False)

    if exit_code != 0:
        # Image not available locally – pull it.
        pull_cmd = f"{DOCKER_PULL_COMMAND} {image_ref}"
        pull_output = run_command(pull_cmd, False)[1]
        if not pull_output:
            return 0
        exit_code, inspect_output = run_command(inspect_cmd, False)

    if exit_code == 0:
        content = f"# {image_ref}\n```json\n{inspect_output}\n```"
        common.write_file(f"{DOCS_METADATA_DIR}/{tag}.md", content)

    return 0
