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


def get_resty_core_required_stream_lua_api_version(tag):
    """Return the ngx_stream_lua_version lua-resty-core <tag> pins to.

    Same exact-version lock as get_resty_core_required_lua_module(), but for
    the stream subsystem: resty/core/base.lua checks
    `ngx.config.ngx_lua_version ~= NNNNN` under `subsystem == 'stream'` (a
    raw ngx_stream_lua_version int, not the http subsystem's encoded
    major*1e6+minor*1e3+patch number - stream-lua-nginx-module doesn't
    version its releases that way).
    """
    url = (
        "https://raw.githubusercontent.com/openresty/lua-resty-core/"
        f"v{tag}/lib/resty/core/base.lua"
    )
    resp = requests.get(url, timeout=30)
    resp.raise_for_status()

    match = re.search(
        r"subsystem == 'stream'.*?ngx_lua_version\s*~=\s*(\d+)", resp.text, re.S
    )
    if not match:
        raise RuntimeError(f"Could not find stream ngx_lua_version check in {url}")

    return int(match.group(1))


def get_stream_lua_commit_for_api_version(required_version):
    """Return the newest stream-lua-nginx-module commit at ngx_stream_lua_version
    == required_version.

    The module bumps src/api/ngx_stream_lua_api.h's #define in its own commits
    (e.g. "bumped api version to 18"), so the commit tracking the *latest*
    fixes at our required version is the parent of whichever commit bumps the
    define to required_version + 1. Auto-tracking the latest commit on the
    default branch (as for other is_commit deps) desyncs from whatever
    ngx_stream_lua_version lua-resty-core actually requires - this is the
    stream-subsystem equivalent of get_resty_core_required_lua_module().
    """
    owner_repo = "openresty/stream-lua-nginx-module"
    api_path = "src/api/ngx_stream_lua_api.h"
    resp = requests.get(
        f"https://api.github.com/repos/{owner_repo}/commits",
        params={"path": api_path, "per_page": 100},
        timeout=30,
    )
    resp.raise_for_status()
    bump_commits = resp.json()

    def api_version_at(sha):
        raw = requests.get(
            f"https://raw.githubusercontent.com/{owner_repo}/{sha}/{api_path}",
            timeout=30,
        )
        raw.raise_for_status()
        m = re.search(r"ngx_stream_lua_version\s+(\d+)", raw.text)
        if not m:
            raise RuntimeError(f"Could not find ngx_stream_lua_version in {sha}:{api_path}")
        return int(m.group(1))

    for commit in bump_commits:
        sha = commit["sha"]
        if api_version_at(sha) == required_version + 1:
            parents = commit.get("parents", [])
            if not parents:
                raise RuntimeError(f"Commit {sha} bumping to {required_version + 1} has no parent")
            return parents[0]["sha"]

    raise RuntimeError(
        f"Could not find the commit bumping ngx_stream_lua_version to "
        f"{required_version + 1} (needed to pin the commit before it)"
    )


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

    # Define dependencies: key -> (repo_url, is_commit, tarball_url_pattern)
    # tarball_url_pattern uses {ver} as placeholder for the version
    deps = [
        ('ngx_devel_kit', "https://github.com/vision5/ngx_devel_kit", False,
         "https://github.com/vision5/ngx_devel_kit/archive/v{ver}.tar.gz"),
        ('njs', "https://github.com/nginx/njs", False,
         "https://github.com/nginx/njs/archive/{ver}.tar.gz"),
        ('geoip', "https://github.com/leev/ngx_http_geoip2_module", False,
         "https://github.com/leev/ngx_http_geoip2_module/archive/{ver}.tar.gz"),
        ('luajit', "https://github.com/openresty/luajit2", False,
         "https://github.com/openresty/luajit2/archive/v{ver}.tar.gz"),
        ('lua_nginx_module', "https://github.com/openresty/lua-nginx-module", False,
         "https://github.com/openresty/lua-nginx-module/archive/v{ver}.tar.gz"),
        ('lua_resty_core', "https://github.com/openresty/lua-resty-core", False,
         "https://github.com/openresty/lua-resty-core/archive/v{ver}.tar.gz"),
        ('luarocks', "https://github.com/luarocks/luarocks", False,
         "https://github.com/luarocks/luarocks/archive/refs/tags/v{ver}.tar.gz"),
        ('lua_resty_lrucache', "https://github.com/openresty/lua-resty-lrucache", False,
         "https://github.com/openresty/lua-resty-lrucache/archive/v{ver}.tar.gz"),
        ('openresty_headers', "https://github.com/openresty/headers-more-nginx-module", False,
         "https://github.com/openresty/headers-more-nginx-module/archive/v{ver}.tar.gz"),
        ('cloudflare_cookie', "https://github.com/cloudflare/lua-resty-cookie", True,
         "https://github.com/cloudflare/lua-resty-cookie/archive/{ver}.tar.gz"),
        ('openresty_dns', "https://github.com/openresty/lua-resty-dns", False,
         "https://github.com/openresty/lua-resty-dns/archive/v{ver}.tar.gz"),
        ('openresty_memcached', "https://github.com/openresty/lua-resty-memcached", False,
         "https://github.com/openresty/lua-resty-memcached/archive/v{ver}.tar.gz"),
        ('openresty_mysql', "https://github.com/openresty/lua-resty-mysql", False,
         "https://github.com/openresty/lua-resty-mysql/archive/v{ver}.tar.gz"),
        ('openresty_redis', "https://github.com/openresty/lua-resty-redis", False,
         "https://github.com/openresty/lua-resty-redis/archive/v{ver}.tar.gz"),
        ('openresty_shell', "https://github.com/openresty/lua-resty-shell", False,
         "https://github.com/openresty/lua-resty-shell/archive/v{ver}.tar.gz"),
        ('openresty_signal', "https://github.com/openresty/lua-resty-signal", False,
         "https://github.com/openresty/lua-resty-signal/archive/v{ver}.tar.gz"),
        ('openresty_tablepool', "https://github.com/openresty/lua-tablepool", False,
         "https://github.com/openresty/lua-tablepool/archive/v{ver}.tar.gz"),
        ('openresty_healthcheck', "https://github.com/openresty/lua-resty-upstream-healthcheck", False,
         "https://github.com/openresty/lua-resty-upstream-healthcheck/archive/v{ver}.tar.gz"),
        ('openresty_websocket', "https://github.com/openresty/lua-resty-websocket", False,
         "https://github.com/openresty/lua-resty-websocket/archive/v{ver}.tar.gz"),
        ('lua_upstream', "https://github.com/openresty/lua-upstream-nginx-module", False,
         "https://github.com/openresty/lua-upstream-nginx-module/archive/v{ver}.tar.gz"),
        ('prometheus', "https://github.com/knyar/nginx-lua-prometheus", False,
         "https://github.com/knyar/nginx-lua-prometheus/archive/{ver}.tar.gz"),
        ('misc_nginx', "https://github.com/openresty/set-misc-nginx-module", False,
         "https://github.com/openresty/set-misc-nginx-module/archive/v{ver}.tar.gz"),
        ('echo_nginx', "https://github.com/openresty/echo-nginx-module", False,
         "https://github.com/openresty/echo-nginx-module/archive/v{ver}.tar.gz"),
        ('openresty_streamlua', "https://github.com/openresty/stream-lua-nginx-module", True,
         "https://github.com/openresty/stream-lua-nginx-module/archive/{ver}.tar.gz"),
        ('openresty_limittraffic', "https://github.com/openresty/lua-resty-limit-traffic", False,
         "https://github.com/openresty/lua-resty-limit-traffic/archive/v{ver}.tar.gz"),
        ('openresty_upload', "https://github.com/openresty/lua-resty-upload", False,
         "https://github.com/openresty/lua-resty-upload/archive/v{ver}.tar.gz"),
        ('openresty_lock', "https://github.com/openresty/lua-resty-lock", False,
         "https://github.com/openresty/lua-resty-lock/archive/v{ver}.tar.gz"),
        ('openresty_balancer', "https://github.com/openresty/lua-resty-balancer", False,
         "https://github.com/openresty/lua-resty-balancer/archive/v{ver}.tar.gz"),
        ('openresty_string', "https://github.com/openresty/lua-resty-string", False,
         "https://github.com/openresty/lua-resty-string/archive/v{ver}.tar.gz"),
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

    # Same lock as lua-nginx-module above, for the stream subsystem.
    required_stream_api_version = get_resty_core_required_stream_lua_api_version(resty_core_ver)
    pinned_stream_lua = get_stream_lua_commit_for_api_version(required_stream_api_version)
    print(
        f"lua-resty-core {resty_core_ver} pins ngx_stream_lua_version to "
        f"{required_stream_api_version} -> commit {pinned_stream_lua}",
        file=sys.stderr,
    )

    for name, repo_url, is_commit, tarball_pattern in deps:
        print(f"Fetching version for {name}...", file=sys.stderr)
        if name == "lua_nginx_module":
            ver = pinned_lua_nginx_module
        elif name == "openresty_streamlua":
            ver = pinned_stream_lua
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
