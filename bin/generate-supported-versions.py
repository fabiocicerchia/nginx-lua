#!/usr/bin/env python3
"""
Generate supported versions script

This script fetches the latest Docker image versions for various distributions
and Nginx versions, then updates a supported_versions file.
"""

import os
import re
import subprocess
import sys
import tempfile
import shutil
from pathlib import Path
from typing import Optional, List
import json
import requests


def run_command(cmd: List[str], capture_output: bool = True) -> subprocess.CompletedProcess:
    """Run a shell command and return the result."""
    try:
        result = subprocess.run(cmd, capture_output=capture_output, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {' '.join(cmd)}")
        print(f"Error: {e}")
        sys.exit(1)


def fetch_specific(distro: str, filter_pattern: str = ".+", specific_tag: str = "latest") -> Optional[str]:
    """
    Fetch a specific version tag for a Docker image.
    
    Args:
        distro: Docker image name (e.g., 'nginx', 'alpine')
        filter_pattern: Regex pattern to filter tags
        specific_tag: Specific tag to look for (e.g., 'mainline', 'stable', 'latest')
    
    Returns:
        The matching version tag or None if not found
    """
    # First try to get tag from official-images library
    try:
        url = f"https://raw.githubusercontent.com/docker-library/official-images/master/library/{distro}"
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        
        # Parse the content to find the specific tag
        lines = response.text.split('\n')
        for line in lines:
            if specific_tag in line:
                # Extract tags from the line
                parts = line.split(':')
                if len(parts) > 1:
                    tags_part = parts[1].strip()
                    # Split by comma and clean up
                    tags = [tag.strip() for tag in tags_part.split(',')]
                    
                    # Filter tags by pattern and sort
                    matching_tags = []
                    for tag in tags:
                        if re.match(filter_pattern, tag):
                            matching_tags.append(tag)
                    
                    if matching_tags:
                        # Sort by version (reverse order) and return the first
                        matching_tags.sort(key=lambda x: [int(c) if c.isdigit() else c for c in re.split(r'([0-9]+)', x)], reverse=True)
                        return matching_tags[0]
    except Exception as e:
        print(f"Warning: Could not fetch from official-images library: {e}")
    
    # Fallback: use skopeo to inspect the image
    try:
        # Get digest for the specific tag
        cmd = ["skopeo", "inspect", "--override-arch", "amd64", f"docker://{distro}:{specific_tag}"]
        digest = json.loads(run_command(cmd)).get('Digest')
        if not digest:
            return None
        
        # List all tags
        cmd = ["skopeo", "list-tags", "--override-arch", "amd64", f"docker://{distro}"]
        all_tags = json.loads(run_command(cmd)).get('Tags', [])
        
        # Filter and sort tags
        matching_tags = []
        for tag in all_tags:
            if re.match(filter_pattern, tag):
                matching_tags.append(tag)
        
        matching_tags.sort(key=lambda x: [int(c) if c.isdigit() else c for c in re.split(r'([0-9]+)', x)], reverse=True)
        
        # Find the tag with matching digest
        for tag in matching_tags:
            cmd = ["skopeo", "inspect", "--override-arch", "amd64", f"docker://{distro}:{tag}"]
            if json.loads(run_command(cmd)).get('Digest') == digest:
                return tag
                
    except Exception as e:
        print(f"Error fetching version for {distro}: {e}")
    
    return None


def fetch_mainline(distro: str, filter_pattern: str = "") -> Optional[str]:
    """Fetch mainline version."""
    return fetch_specific(distro, filter_pattern, "mainline")


def fetch_stable(distro: str, filter_pattern: str = "") -> Optional[str]:
    """Fetch stable version."""
    return fetch_specific(distro, filter_pattern, "stable")


def fetch_latest(distro: str, filter_pattern: str = "") -> Optional[str]:
    """Fetch latest version."""
    return fetch_specific(distro, filter_pattern, "latest")


def main():
    """Main function to generate supported versions."""
    # Create temp directory if it doesn't exist
    temp_dir = Path("/tmp/generate-supported-versions")
    temp_dir.mkdir(exist_ok=True)
    
    print("Fetching Docker image versions...")
    
    # nginx stable vs mainline
    # Ref: https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
    #
    # Mainline version: Latest development version, updated every 1-2 months
    # Stable version: Updated once a year, even-numbered (e.g., 1.28.X)
    # `latest` for nginx is the `mainline`
    
    ver_nginx_mainline = fetch_mainline("nginx", r"^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
    if not ver_nginx_mainline:
        print("Wrong version count in NGINX (mainline).")
        sys.exit(1)
    
    ver_nginx_stable = fetch_stable("nginx", r"^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
    if not ver_nginx_stable:
        print("Wrong version count in NGINX (stable).")
        sys.exit(1)
    
    ver_almalinux = fetch_latest("almalinux", r"^[0-9]\.[0-9]{1,2}-[0-9]{8}$")
    if not ver_almalinux:
        print("Wrong version count in ALMALINUX.")
        sys.exit(1)
    
    ver_alpine = fetch_latest("alpine", r"^[0-9]\.[0-9]{1,2}\.[0-9]{1,2}$")
    if not ver_alpine:
        print("Wrong version count in ALPINE.")
        sys.exit(1)
    
    ver_amazonlinux = fetch_latest("amazonlinux", r"^202[3-9]\.[0-9]{1,2}\.[0-9]{8}(\.[0-9])?$")
    if not ver_amazonlinux:
        print("Wrong version count in AMAZONLINUX.")
        sys.exit(1)
    
    ver_debian = fetch_latest("debian", r"^[0-9]{2}\.[0-9]{1,2}")
    if not ver_debian:
        print("Wrong version count in DEBIAN.")
        sys.exit(1)
    
    ver_fedora = fetch_latest("fedora", r"^[0-9]{2}$")
    if not ver_fedora:
        print("Wrong version count in FEDORA.")
        sys.exit(1)
    
    ver_ubuntu = fetch_latest("ubuntu", r"^[0-9]{2}\.[0-9]{2}")
    if not ver_ubuntu:
        print("Wrong version count in UBUNTU.")
        sys.exit(1)
    
    supported_versions_file = Path("supported_versions")
    
    # Write new supported versions
    with open(supported_versions_file, 'w') as f:
        f.write(f"nginx_mainline={ver_nginx_mainline}\n")
        f.write(f"nginx_stable={ver_nginx_stable}\n")
        f.write(f"almalinux={ver_almalinux}\n")
        f.write(f"alpine={ver_alpine}\n")
        f.write(f"amazonlinux={ver_amazonlinux}\n")
        f.write(f"debian={ver_debian}\n")
        f.write(f"fedora={ver_fedora}\n")
        f.write(f"ubuntu={ver_ubuntu}\n")
    
    # Print the content of the file
    print(f"Generated supported versions:")
    with open(supported_versions_file, 'r') as f:
        file_content = f.read()
        print(file_content)

if __name__ == "__main__":
    main() 