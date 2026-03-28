"""
Common utilities for nginx-lua Docker image management.
"""

import glob
import os
import re
import shlex
import shutil
import subprocess
from datetime import datetime
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
DOCS_METADATA_DIR = "docs/metadata"
SRC_DIR = "src"
TPL_DIR = "tpl"
PATCHES_DIR = "patches"
LICENSES_DIR = "licenses"

# Docker constants
DOCKER_BUILD_COMMAND = "docker build"
DOCKER_PUSH_COMMAND = "docker push"
DOCKER_PULL_COMMAND = "docker pull"
DOCKER_INSPECT_COMMAND = "docker image inspect"
DOCKER_MANIFEST_CREATE = "docker manifest create"
DOCKER_MANIFEST_PUSH = "docker manifest push"
DOCKER_IMAGES_COMMAND = "docker images"

# Git constants
GIT_REV_PARSE_COMMAND = "git rev-parse --short HEAD"

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

# String constants
LATEST_TAG = "latest"

# Regex patterns
SAFE_NAME_PATTERN = r"[^0-9a-zA-Z]+"
SAFE_NAME_REPLACEMENT = "-"

# Environment file
ENV_DIST_FILE = ".env.dist"

# Configuration files
CONFIG_FILES = ["default.conf", "Makefile", "nginx.conf"]


def run_command(command, print_stdout=True):
    """Run a shell command and return exit code and output."""
    print(f"Running: {command}")

    process = subprocess.Popen(
        shlex.split(command),
        shell=False, 
        stdout=subprocess.PIPE
    )

    streamdata = process.communicate()[0]
    output_lines = streamdata.decode("utf-8")
    if print_stdout:
        print(output_lines)

    return [process.returncode, output_lines]


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

    tags = []

    # Add default tags for alpine (default distro)
    if is_default:
        tags.extend([
            f"{major}{arch_suffix}",
            f"{minor}{arch_suffix}",
            f"{patch}{arch_suffix}",
            f"{LATEST_TAG}{arch_suffix}"
        ])

    # Add OS-specific tags
    tags.extend([
        f"{os_distro}{arch_suffix}",
        f"{major}-{os_distro}{arch_suffix}",
        f"{major}-{os_distro}{os_version}{arch_suffix}",
        f"{minor}-{os_distro}{arch_suffix}",
        f"{patch}-{os_distro}{arch_suffix}",
        f"{patch}-{os_distro}{os_version}{arch_suffix}",
        f"{minor}-{os_distro}{os_version}{arch_suffix}",
        f"{major}-{os_distro}{os_version}{arch_suffix}"
    ])

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


def build_docker_image(vcs_ref, tags, dockerfile_path, arch):
    """Build Docker image with given parameters."""
    tag_params = " ".join([f"-t {tag}" for tag in tags])
    build_date = datetime.now().strftime(BUILD_DATE_FORMAT)

    tarball_path = get_tarball_path(dockerfile_path)
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
    dockerfile_path = get_dockerfile_path(nginx_version, os_distro, os_version)
    tags = generate_tags(nginx_version, os_distro, os_version, arch)
    vcs_ref = subprocess.getoutput(GIT_REV_PARSE_COMMAND).strip()

    return build_docker_image(vcs_ref, tags, dockerfile_path, arch)


def push_docker_image(tag):
    """Push Docker image to registry with retry."""
    cmd = f"{DOCKER_PUSH_COMMAND} {tag}"
    exit_code = run_command(cmd, True)[0]

    # Retry once if failed
    if exit_code != 0:
        exit_code = run_command(cmd, True)[0]

    return exit_code


def push_images(nginx_version, os_distro, os_version):
    """Push images for all architectures."""
    for arch in ARCHITECTURES:
        tags = generate_tags(nginx_version, os_distro, os_version, arch)
        for tag in tags:
            push_docker_image(tag)

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
    tags = generate_tags(nginx_version, os_distro, os_version, "")

    for tag in tags:
        exit_code = create_manifest(tag)
        if exit_code != 0:
            return 1

    return 0


def generate_metadata(tag):
    """Generate metadata documentation for image tag."""
    pull_cmd = f"{DOCKER_PULL_COMMAND} {IMAGE_REPO}:{tag}"
    pull_output = run_command(pull_cmd, False)[1]

    if pull_output:
        inspect_cmd = f"{DOCKER_INSPECT_COMMAND} {IMAGE_REPO}:{tag}"
        exit_code, inspect_output = run_command(inspect_cmd, False)

        if exit_code == 0:
            content = f"# {IMAGE_REPO}:{tag}\n```json\n{inspect_output}\n```"
            write_file(f"{DOCS_METADATA_DIR}/{tag}.md", content)

    return 0


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
        dockerfiles.extend([
            get_dockerfile_path(nginx_mainline, os_distro, os_version),
            get_dockerfile_path(nginx_stable, os_distro, os_version)
        ])

    return dockerfiles


def patch_dockerfile(dockerfile_path, nginx_version, os_distro, os_version):
    """Replace placeholders in Dockerfile template."""
    content = read_file(dockerfile_path)

    # Replace basic placeholders
    replacements = {
        "{{DOCKER_IMAGE}}": IMAGE_REPO,
        "{{DOCKER_IMAGE_OS}}": os_distro,
        "{{DOCKER_IMAGE_TAG}}": os_version,
        "{{VER_NGINX}}": nginx_version
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
        os.chmod(dest, 0o755)

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

    print(f"- [`{tag_list}`](https://github.com/fabiocicerchia/nginx-lua/blob/main/{dockerfile_path})")


# Backward compatibility aliases
def get_tags(nginx_ver, os_distro, os_ver, arch):
    return generate_tags(nginx_ver, os_distro, os_ver, arch)

def get_dockerfile(nginx_ver, os_distro, os_ver):
    return get_dockerfile_path(nginx_ver, os_distro, os_ver)

def get_supported_os():
    return SUPPORTED_OS

def build(nginx_ver, os_distro, os_ver, arch):
    return build_image(nginx_ver, os_distro, os_ver, arch)

def push(nginx_ver, os_distro, os_ver):
    return push_images(nginx_ver, os_distro, os_ver)

def bundle(nginx_ver, os_distro, os_ver):
    return bundle_images(nginx_ver, os_distro, os_ver)

def metadata(tag):
    return generate_metadata(tag)

def get_all_versions():
    return load_supported_versions()

def init_dockerfile(nginx_ver, os_distro, os_ver):
    return setup_dockerfile(nginx_ver, os_distro, os_ver)

def tag(nginx_ver, os_distro, os_ver):
    return print_tags(nginx_ver, os_distro, os_ver)
