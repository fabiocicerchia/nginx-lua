"""
Common utilities for nginx-lua Docker image management.
"""

import glob
import os
import re
import shutil
import sys
from pathlib import Path

# Configuration
SUPPORTED_OS = ["almalinux", "alpine", "amazonlinux", "debian", "fedora", "ubuntu"]
DEFAULT_DISTRO = "alpine"
IMAGE_REPO = "fabiocicerchia/nginx-lua"

# File and path constants
DIST_DIR = "dist"
MULTIARCH_PREFIX = "multiarch"
TARBALL_EXTENSION = ".tar"
SUPPORTED_VERSIONS_FILE = "supported_versions"
SRC_DIR = "src"
TPL_DIR = "tpl"
PATCHES_DIR = "patches"
LICENSES_DIR = "licenses"

# String constants
LATEST_TAG = "latest"

# Regex patterns
SAFE_NAME_PATTERN = r"[^0-9a-zA-Z]+"
SAFE_NAME_REPLACEMENT = "-"

# Environment file
ENV_DIST_FILE = ".env.dist"

# Configuration files
CONFIG_FILES = ["default.conf", "Makefile", "nginx.conf"]


def read_file(file_path):
    """Read file content."""
    with open(file_path, encoding="utf8") as f:
        return f.read()


def write_file(file_path, content):
    """Write content to file."""
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)


def get_version_parts(version):
    """Extract major, minor, and patch from version string."""
    parts = version.split(".")
    major = parts[0]
    minor = f"{parts[0]}.{parts[1]}"
    patch = version
    return [major, minor, patch]


def generate_tags(nginx_version, os_distro, os_version, arch=""):
    """Generate Docker tags for the image."""
    arch_suffix = f"-{arch}" if arch else ""

    major, minor, patch = get_version_parts(nginx_version)
    is_default = os_distro == DEFAULT_DISTRO
    # Tags that only encode the major version ("1") are ambiguous between
    # mainline and stable, since both track the same major (e.g. 1.31.x and
    # 1.30.x are both "1"). Granting those tags to both builds makes them
    # fight over the same tag name — whichever gets built/pushed last
    # silently wins, orphaning the cosign signature made against the
    # specific per-version tag from whatever "latest"/the bare distro tag
    # actually resolves to. Minor/patch-qualified tags are never ambiguous
    # (mainline and stable always differ there), so they don't need gating.
    is_mainline = nginx_version == load_supported_versions()["nginx_mainline"]

    tags = []

    # Add default tags for alpine (default distro)
    if is_default:
        if is_mainline:
            tags.extend(
                [
                    f"{major}{arch_suffix}",
                    f"{LATEST_TAG}{arch_suffix}",
                ]
            )
        tags.extend(
            [
                f"{minor}{arch_suffix}",
                f"{patch}{arch_suffix}",
            ]
        )

    # Add OS-specific tags
    if is_mainline:
        tags.extend(
            [
                f"{os_distro}{arch_suffix}",
                f"{major}-{os_distro}{arch_suffix}",
                f"{major}-{os_distro}{os_version}{arch_suffix}",
            ]
        )
    tags.extend(
        [
            f"{minor}-{os_distro}{arch_suffix}",
            f"{patch}-{os_distro}{arch_suffix}",
            f"{patch}-{os_distro}{os_version}{arch_suffix}",
            f"{minor}-{os_distro}{os_version}{arch_suffix}",
        ]
    )

    # Add repository prefix and remove duplicates
    full_tags = [f"{IMAGE_REPO}:{tag}" for tag in tags]
    unique_tags = list(set(full_tags))

    # Sort by length and then alphabetically
    unique_tags.sort(key=lambda x: (len(x), x))

    return unique_tags


def get_dockerfile_path(nginx_version, os_distro, os_version):
    """Get Dockerfile path for given configuration."""
    return f"nginx/{nginx_version}/{os_distro}/{os_version}/Dockerfile"


def get_tarball_path(dockerfile_path):
    """Generate tarball path from Dockerfile path."""
    safe_name = re.sub(SAFE_NAME_PATTERN, SAFE_NAME_REPLACEMENT, dockerfile_path)
    return f"{DIST_DIR}/{MULTIARCH_PREFIX}-{safe_name}{TARBALL_EXTENSION}"


def load_supported_versions():
    """Load supported versions from file."""
    versions = {}
    with open(SUPPORTED_VERSIONS_FILE, encoding="utf8") as f:
        for line in f:
            if "=" in line:
                key, value = line.strip().split("=", 1)
                versions[key] = value
    return versions


def get_supported_versions():
    """Get all supported Dockerfile paths."""
    versions = load_supported_versions()
    nginx_mainline = versions["nginx_mainline"]
    nginx_stable = versions["nginx_stable"]

    dockerfiles = []
    for os_distro in SUPPORTED_OS:
        os_version = versions[os_distro]
        dockerfiles.extend(
            [
                get_dockerfile_path(nginx_mainline, os_distro, os_version),
                get_dockerfile_path(nginx_stable, os_distro, os_version),
            ]
        )

    return dockerfiles


def patch_dockerfile(dockerfile_path, nginx_version, os_distro, os_version):
    """Replace placeholders in Dockerfile template."""
    content = read_file(dockerfile_path)

    # Replace basic placeholders
    replacements = {
        "{{DOCKER_IMAGE}}": IMAGE_REPO,
        "{{DOCKER_IMAGE_OS}}": os_distro,
        "{{DOCKER_IMAGE_TAG}}": os_version,
        "{{VER_NGINX}}": nginx_version,
    }

    for placeholder, value in replacements.items():
        content = content.replace(placeholder, value)

    # Replace environment variables
    env_file = Path(dockerfile_path).parent / TPL_DIR / ENV_DIST_FILE
    if env_file.exists():
        for line in read_file(env_file).split("\n"):
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, value = line.split("=", 1)
                content = content.replace(f"{{{{{key}}}}}", value)

    write_file(dockerfile_path, content)


def setup_dockerfile(nginx_version, os_distro, os_version):
    """Set up Dockerfile and related files."""
    dockerfile_path = get_dockerfile_path(nginx_version, os_distro, os_version)
    folder = Path(dockerfile_path).parent
    tpl_folder = folder / TPL_DIR

    # Create template directory
    tpl_folder.mkdir(parents=True, exist_ok=True)

    # Copy environment file
    shutil.copyfile(f"{SRC_DIR}/{ENV_DIST_FILE}", tpl_folder / ENV_DIST_FILE)

    # Copy Dockerfile template
    shutil.copyfile(f"{SRC_DIR}/Dockerfile.{os_distro}", dockerfile_path)
    patch_dockerfile(dockerfile_path, nginx_version, os_distro, os_version)

    # Copy shell scripts
    for script_file in glob.glob(f"{SRC_DIR}/*.sh"):
        dest = tpl_folder / Path(script_file).name
        shutil.copyfile(script_file, dest)
        os.chmod(dest, 0o750)

    # Copy patches
    patches_folder = tpl_folder / PATCHES_DIR
    patches_folder.mkdir(exist_ok=True)
    for patch_file in glob.glob(f"{SRC_DIR}/{PATCHES_DIR}/*.patch"):
        shutil.copyfile(patch_file, patches_folder / Path(patch_file).name)

    # Copy licenses
    licenses_folder = tpl_folder / LICENSES_DIR
    licenses_folder.mkdir(exist_ok=True)
    for license_file in glob.glob(f"{SRC_DIR}/{LICENSES_DIR}/*.LICENSE"):
        shutil.copyfile(license_file, licenses_folder / Path(license_file).name)

    # Copy configuration files
    for config in CONFIG_FILES:
        shutil.copyfile(f"{SRC_DIR}/{config}", tpl_folder / config)


def print_tags(nginx_version, os_distro, os_version):
    """Print markdown-formatted tags for documentation."""
    tags = generate_tags(nginx_version, os_distro, os_version, "")
    tag_names = [tag.replace(f"{IMAGE_REPO}:", "") for tag in tags]
    tag_list = "`, `".join(tag_names)
    dockerfile_path = get_dockerfile_path(nginx_version, os_distro, os_version)

    print(
        f"- [`{tag_list}`](https://github.com/fabiocicerchia/nginx-lua/blob/main/{dockerfile_path})"
    )


def get_supported_os():
    return SUPPORTED_OS


def for_mainline_and_stable(fn, versions, os_distro, *extra_args):
    """Call fn(nginx_version, os_distro, os_version, *extra_args) once for the
    mainline version then once for the stable version; sys.exit(1) on the
    first failure."""
    for version_key in ("nginx_mainline", "nginx_stable"):
        exit_code = fn(
            versions[version_key], os_distro, versions[os_distro], *extra_args
        )
        if exit_code > 0:
            sys.exit(1)
