#!/usr/bin/env python3
"""
Generate dependencies environment file for nginx-lua.

This script fetches the latest versions of all dependencies used in the nginx-lua
project and generates an environment file with version variables. It queries
GitHub repositories to get the latest tags and commits.
"""

import subprocess
import re
import sys
from pathlib import Path


def run_command(cmd):
    """Run a shell command and return the output."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {cmd}")
        print(f"Error: {e}")
        sys.exit(1)


def get_latest_tag(repo_url):
    """Get the latest tag from a Git repository."""
    cmd = f"git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' {repo_url}"
    output = run_command(cmd)
    
    # Filter out rc, alpha, beta versions and get the latest
    lines = output.split('\n')
    for line in reversed(lines):
        if line and not any(x in line for x in ['rc', 'alpha', 'beta', '{}']):
            # Extract tag name from refs/tags/v? format
            match = re.search(r'refs/tags/v?(.+)$', line)
            if match:
                return match.group(1)
    
    return ""


def get_latest_commit(repo_url):
    """Get the latest commit from a Git repository."""
    cmd = f"git -c 'versionsort.suffix=-' ls-remote --sort='v:refname' {repo_url} HEAD"
    output = run_command(cmd)
    
    # Extract commit hash
    lines = output.split('\n')
    for line in lines:
        if line and '\t' in line:
            return line.split('\t')[0]
    
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
    
    # Fetch all versions
    versions = {
        'ver_ngx_devel_kit': get_latest_tag("https://github.com/vision5/ngx_devel_kit"),
        'ver_njs': get_latest_tag("https://github.com/nginx/njs"),
        'ver_geoip': get_latest_tag("https://github.com/leev/ngx_http_geoip2_module"),
        'ver_luajit': get_latest_tag("https://github.com/openresty/luajit2"),
        'ver_lua_nginx_module': get_latest_tag("https://github.com/openresty/lua-nginx-module"),
        'ver_lua_resty_core': get_latest_tag("https://github.com/openresty/lua-resty-core"),
        'ver_luarocks': get_latest_tag("https://github.com/luarocks/luarocks"),
        'ver_lua_resty_lrucache': get_latest_tag("https://github.com/openresty/lua-resty-lrucache"),
        'ver_openresty_headers': get_latest_tag("https://github.com/openresty/headers-more-nginx-module"),
        'ver_cloudflare_cookie': get_latest_commit("https://github.com/cloudflare/lua-resty-cookie"),
        'ver_openresty_dns': get_latest_tag("https://github.com/openresty/lua-resty-dns"),
        'ver_openresty_memcached': get_latest_tag("https://github.com/openresty/lua-resty-memcached"),
        'ver_openresty_mysql': get_latest_tag("https://github.com/openresty/lua-resty-mysql"),
        'ver_openresty_redis': get_latest_tag("https://github.com/openresty/lua-resty-redis"),
        'ver_openresty_shell': get_latest_tag("https://github.com/openresty/lua-resty-shell"),
        'ver_openresty_signal': get_latest_tag("https://github.com/openresty/lua-resty-signal"),
        'ver_openresty_tablepool': get_latest_tag("https://github.com/openresty/lua-tablepool"),
        'ver_openresty_healthcheck': get_latest_tag("https://github.com/openresty/lua-resty-upstream-healthcheck"),
        'ver_openresty_websocket': get_latest_tag("https://github.com/openresty/lua-resty-websocket"),
        'ver_lua_upstream': get_latest_tag("https://github.com/openresty/lua-upstream-nginx-module"),
        'ver_prometheus': get_latest_tag("https://github.com/knyar/nginx-lua-prometheus"),
        'ver_misc_nginx': get_latest_tag("https://github.com/openresty/set-misc-nginx-module"),
        'ver_openresty_streamlua': get_latest_commit("https://github.com/openresty/stream-lua-nginx-module"),
        'ver_openresty_limittraffic': get_latest_tag("https://github.com/openresty/lua-resty-limit-traffic"),
        'ver_openresty_upload': get_latest_tag("https://github.com/openresty/lua-resty-upload"),
        'ver_openresty_lock': get_latest_tag("https://github.com/openresty/lua-resty-lock"),
        'ver_openresty_balancer': get_latest_tag("https://github.com/openresty/lua-resty-balancer"),
        'ver_openresty_string': get_latest_tag("https://github.com/openresty/lua-resty-string"),
    }
    
    # Format template with versions
    output = template.format(**versions)
    
    # Print the result
    print(output)

if __name__ == "__main__":
    main() 