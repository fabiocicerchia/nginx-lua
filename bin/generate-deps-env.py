#!/usr/bin/env python3
"""
Generate dependencies environment file for nginx-lua.

This script fetches the latest versions of all dependencies used in the nginx-lua
project and generates an environment file with version variables. It queries
the GitHub API to get the latest tags and commits.
"""

import hashlib
import re
import sys
from pathlib import Path
from urllib.parse import urlparse

import requests

from deps_manifest import DEPENDENCIES


def compute_sha256(url):
    """Download a file and compute its SHA256 hash. Returns 'RECOMPUTE_REQUIRED' on failure."""
    try:
        resp = requests.get(url, timeout=60, stream=True, allow_redirects=True)
        resp.raise_for_status()
        h = hashlib.sha256()
        for chunk in resp.iter_content(chunk_size=8192):
            h.update(chunk)
        return h.hexdigest()
    except Exception as e:
        print(f"WARNING: Could not download {url} for SHA256 computation: {e}", file=sys.stderr)
        return "RECOMPUTE_REQUIRED"


def github_owner_repo(repo_url):
    """Extract owner/repo from a GitHub URL."""
    parsed = urlparse(repo_url)
    parts = parsed.path.strip("/").split("/")
    return f"{parts[0]}/{parts[1]}"


def get_latest_tag(repo_url):
    """Get the latest non-prerelease tag from a GitHub repository via API."""
    owner_repo = github_owner_repo(repo_url)
    url = f"https://api.github.com/repos/{owner_repo}/tags"
    resp = requests.get(url, params={"per_page": 100}, timeout=30)
    resp.raise_for_status()

    for tag in resp.json():
        name = tag["name"]
        if any(x in name.lower() for x in ["rc", "alpha", "beta"]):
            continue
        # Strip leading 'v' if present
        return name.lstrip("v")

    return ""


def get_resty_core_required_lua_module(tag):
    """Return the lua-nginx-module version that lua-resty-core <tag> pins to.

    lua-resty-core enforces an EXACT lua-nginx-module version via an
    `ngx.config.ngx_lua_version ~= NNNNN` check in resty/core/base.lua. The
    HTTP-subsystem number (e.g. 10029) encodes the required version as
    major*1000000 + minor*1000 + patch, i.e. 10029 -> 0.10.29. Tracking the
    latest tags of each library independently can desync them (lua-nginx-module
    may ship a stable release before its matching lua-resty-core does), so we
    derive the module version from resty-core to keep the pair consistent.
    """
    url = (
        "https://raw.githubusercontent.com/openresty/lua-resty-core/"
        f"v{tag}/lib/resty/core/base.lua"
    )
    resp = requests.get(url, timeout=30)
    resp.raise_for_status()

    # The first `~= NNNNN` guard is the HTTP subsystem (ngx_http_lua_module).
    match = re.search(r"ngx_lua_version\s*~=\s*(\d+)", resp.text)
    if not match:
        raise RuntimeError(f"Could not find ngx_lua_version check in {url}")

    ver = int(match.group(1))
    major = ver // 1000000
    minor = (ver // 1000) % 1000
    patch = ver % 1000
    return f"{major}.{minor}.{patch}"


def get_latest_commit(repo_url):
    """Get the latest commit SHA from a GitHub repository's default branch via API."""
    owner_repo = github_owner_repo(repo_url)
    url = f"https://api.github.com/repos/{owner_repo}/commits"
    resp = requests.get(url, params={"per_page": 1}, timeout=30)
    resp.raise_for_status()

    commits = resp.json()
    if commits:
        return commits[0]["sha"]

    return ""


def load_template():
    """Load the template file."""
    template_path = Path(__file__).parent / "templates" / "deps-env.template"

    if not template_path.exists():
        print(f"Error: Template file not found: {template_path}")
        sys.exit(1)

    with open(template_path, 'r') as f:
        return f.read()


def main():
    """Main function to generate dependencies environment file."""

    # Load template
    template = load_template()

    # Dependency list (repo, tarball URL pattern, ...) lives in deps_manifest.py,
    # shared with generate-fossa-deps.py so both stay in sync.
    deps = [
        (dep['key'], dep['repo_url'], dep['is_commit'], dep['tarball_pattern'])
        for dep in DEPENDENCIES
    ]

    template_vars = {}

    # lua-resty-core pins lua-nginx-module to an exact version (see
    # get_resty_core_required_lua_module), so resolve resty-core first and
    # derive the module version from it instead of fetching each library's
    # latest tag independently - that desyncs them whenever lua-nginx-module
    # ships a stable release before its matching lua-resty-core does.
    resty_core_ver = get_latest_tag("https://github.com/openresty/lua-resty-core")
    pinned_lua_nginx_module = get_resty_core_required_lua_module(resty_core_ver)
    print(
        f"lua-resty-core {resty_core_ver} pins lua-nginx-module to "
        f"{pinned_lua_nginx_module}",
        file=sys.stderr,
    )

    for name, repo_url, is_commit, tarball_pattern in deps:
        print(f"Fetching version for {name}...", file=sys.stderr)
        if name == "lua_nginx_module":
            ver = pinned_lua_nginx_module
        elif is_commit:
            ver = get_latest_commit(repo_url)
        else:
            ver = get_latest_tag(repo_url)

        template_vars[f'ver_{name}'] = ver

        # Compute SHA256 hash of the tarball
        tarball_url = tarball_pattern.format(ver=ver)
        print(f"  Computing SHA256 for {tarball_url}...", file=sys.stderr)
        sha256 = compute_sha256(tarball_url)
        template_vars[f'sha256_{name}'] = sha256
        print(f"  {name} v{ver}: {sha256}", file=sys.stderr)

    # Format template with versions and hashes
    output = template.format(**template_vars)

    # Print the result
    print(output)

if __name__ == "__main__":
    main()
