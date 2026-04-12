#!/usr/bin/env python3
"""
Generate dependencies environment file for nginx-lua.

This script fetches the latest versions of all dependencies used in the nginx-lua
project and generates an environment file with version variables. It queries
the GitHub API to get the latest tags and commits.
"""

import hashlib
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

    for name, repo_url, is_commit, tarball_pattern in deps:
        print(f"Fetching version for {name}...", file=sys.stderr)
        if is_commit:
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
