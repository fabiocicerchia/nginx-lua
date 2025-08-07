#!/usr/bin/env python3
"""
Test nginx-lua Docker images and system packages.

This script tests nginx-lua Docker images by running containers and executing
various test cases to verify functionality. It supports both Docker images and
system packages, and can test different operating system distributions.
"""

import argparse
import os
import subprocess
import time
import glob
import re
import sys
from pathlib import Path

# Constants
CONTAINER_NAME = "nginx_lua_test"
TEST_PORT = "8080"
MAX_WAIT_ATTEMPTS = 20
WAIT_INTERVAL = 1


def run_command(cmd, check=True, capture_output=False):
    """Run a shell command and return the result."""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            check=check, 
            capture_output=capture_output,
            text=True
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {cmd}")
        print(f"Error: {e}")
        if check:
            sys.exit(1)
        return e


def handle_error():
    """Handle test errors by showing container logs."""
    print("Test failed. Container logs:")
    run_command(f"docker logs {CONTAINER_NAME}", check=False)
    sys.exit(1)


def get_architecture():
    """Get the current system architecture."""
    result = run_command("dpkg --print-architecture", capture_output=True)
    return result.stdout.strip()


def run_container(docker_tag):
    """Run a container with the specified Docker tag."""
    # Remove existing container
    run_command(f"docker rm -f {CONTAINER_NAME}", check=False)
    
    # Check if image exists
    result = run_command(
        f'docker image ls -q fabiocicerchia/nginx-lua:"{docker_tag}" | wc -l',
        capture_output=True
    )
    if result.stdout.strip() == "0":
        print(f"Image fabiocicerchia/nginx-lua:{docker_tag} not found")
        return 0
    
    # Run container
    cmd = f"""
        docker run -d --name {CONTAINER_NAME} -p {TEST_PORT}:80 -e SKIP_TRACK=1 \
        -v "{os.getcwd()}/test/nginx-lua.conf:/etc/nginx/nginx.conf" \
        -v "{os.getcwd()}/test/tests.conf.d:/etc/nginx/tests.conf.d" \
        -v "{os.getcwd()}/test/geoip:/etc/nginx/geoip" \
        fabiocicerchia/nginx-lua:"{docker_tag}"
    """
    run_command(cmd)
    return 1


def run_container_base(docker_tag):
    """Run a base container and install the nginx-lua package."""
    arch = get_architecture()
    
    # Determine base image and install command based on OS
    if "alpine" in docker_tag:
        image = "alpine"
        install_cmd = "apk add -v --allow-untrusted /app/*_noarch.apk"
    elif "ubuntu" in docker_tag:
        image = "ubuntu"
        install_cmd = f"apt update && apt install -yf /app/*_{arch}.deb"
    elif "debian" in docker_tag:
        image = "debian"
        install_cmd = f"apt update && apt install -yf /app/*_{arch}.deb"
    elif "almalinux" in docker_tag:
        image = "almalinux"
        if arch == "arm64":
            install_cmd = "yum localinstall -y /app/*.aarch64.rpm"
        else:
            install_cmd = "yum localinstall -y /app/*.x86_64.rpm"
    elif "fedora" in docker_tag:
        image = "fedora"
        if arch == "arm64":
            install_cmd = "yum localinstall -y /app/*.aarch64.rpm"
        else:
            install_cmd = "yum localinstall -y /app/*.x86_64.rpm"
    elif "amazon" in docker_tag:
        image = "amazonlinux"
        if arch == "arm64":
            install_cmd = "yum localinstall -y /app/*.aarch64.rpm"
        else:
            install_cmd = "yum localinstall -y /app/*.x86_64.rpm"
    else:
        print(f"Unsupported OS in tag: {docker_tag}")
        return 0
    
    # Remove existing container
    run_command(f"docker rm -f {CONTAINER_NAME}", check=False)
    
    # Run base container
    cmd = f"""
        docker run -d --name {CONTAINER_NAME} -p {TEST_PORT}:80 -e SKIP_TRACK=1 \
        -v "{os.getcwd()}/test/nginx-lua.conf:/etc/nginx/nginx.conf.new" \
        -v "{os.getcwd()}/test/tests.conf.d:/etc/nginx/tests.conf.d" \
        -v "{os.getcwd()}/test/geoip:/etc/nginx/geoip" \
        -v "{os.getcwd()}/dist:/app" \
        {image}:latest sleep infinity
    """
    run_command(cmd)
    
    # Install package and start nginx
    run_command(f"docker exec {CONTAINER_NAME} /bin/sh -c '{install_cmd}'")
    run_command(f"docker exec {CONTAINER_NAME} /bin/sh -c 'cp /etc/nginx/nginx.conf.new /etc/nginx/nginx.conf'")
    run_command(f"docker exec {CONTAINER_NAME} /bin/sh -c '/usr/sbin/nginx'")
    
    return 1


def inject_dependencies(docker_tag):
    """Install dependencies based on the OS distribution."""
    if "alpine" in docker_tag:
        run_command(f"docker exec {CONTAINER_NAME} apk add gcc musl-dev coreutils wget")
    elif "ubuntu" in docker_tag or "debian" in docker_tag:
        run_command(f"docker exec {CONTAINER_NAME} apt update")
        run_command(f"docker exec {CONTAINER_NAME} apt install -y gcc musl-dev coreutils unzip")
    elif "almalinux" in docker_tag:
        run_command(f"docker exec {CONTAINER_NAME} yum install -y gcc unzip")
    elif "fedora" in docker_tag:
        run_command(f"docker exec {CONTAINER_NAME} yum install -y gcc musl-devel coreutils unzip")
    elif "amazon" in docker_tag:
        run_command(f"docker exec {CONTAINER_NAME} yum install -y gcc")
    
    # Install lua-cjson
    run_command(f"docker exec {CONTAINER_NAME} luarocks install lua-cjson")


def wait_for_nginx():
    """Wait for nginx to start and be ready."""
    count = 0
    while count < MAX_WAIT_ATTEMPTS:
        try:
            result = run_command(
                f"curl --output /dev/null --silent --head --fail http://localhost:{TEST_PORT}",
                check=False,
                capture_output=True
            )
            if result.returncode == 0:
                print("Nginx is ready!")
                return
        except:
            pass
        
        print(".", end="", flush=True)
        time.sleep(WAIT_INTERVAL)
        count += 1
    
    print("\nNginx failed to start within timeout")
    handle_error()


def tear_down_container():
    """Remove the test container."""
    run_command(f"docker rm -f {CONTAINER_NAME}", check=False)


def exec_tests():
    """Execute all test cases."""
    test_cases = [
        ("curl -v http://localhost:8080", "Welcome to nginx"),
        ("curl -v http://localhost:8080/lua_content", "Hello world"),
        ("docker exec nginx_lua_test curl -v --fail http://localhost:80/status", "Nginx Worker PID"),
        ("docker exec nginx_lua_test curl -v --fail http://localhost:80/metrics", ""),
        ("curl -H'Connection: upgrade' -H'Upgrade: websocket' -H'Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==' -H'Sec-WebSocket-Version: 13' http://localhost:8080/socket", "Hello world"),
        ("curl -v --fail http://localhost:8080/shell", "ok"),
        ("curl -v --fail http://localhost:8080/dns", "www.google.com"),
        ("curl -v --fail --cookie 'lang=en' http://localhost:8080/cookie", "Set-Cookie: Name=Bob"),
        ("curl -v --fail http://localhost:8080/headers", "X-MyHeader: blah"),
        ("curl -v --fail http://localhost:8080/type", "Content-Type: text/plain"),
        ("curl -v --fail http://localhost:8080/memcached", ""),
        ("curl -v --fail http://localhost:8080/redis", ""),
        ("curl -v --fail http://localhost:8080/foo", ""),
        ("curl -v --fail http://localhost:8080/bar-mysql", ""),
        ("curl -v --fail http://localhost:8080/bar-pgsql", ""),
        ("curl -v --fail http://localhost:8080/json", ""),
        ("curl -v --fail http://localhost:8080/baz", ""),
        ("curl -v --fail http://localhost:8080/foo-hash", ""),
        ("curl -v --fail http://localhost:8080/base32", ""),
        ("curl -v --fail http://localhost:8080/base64", ""),
        ("curl -v --fail http://localhost:8080/hex", ""),
        ("curl -v --fail http://localhost:8080/sha1", ""),
        ("curl -v --fail http://localhost:8080/sha1-2", ""),
        ("curl -v --fail http://localhost:8080/today", ""),
        ("curl -v --fail http://localhost:8080/signature", ""),
        ("curl -v --fail http://localhost:8080/rand", ""),
        ("curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/country", "US"),
        ("curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/city", "Wright City|San Francisco"),
        ("curl -v --fail http://localhost:8080/limit-1", ""),
        ("curl -v --fail http://localhost:8080/limit-2", ""),
        ("curl -v --fail http://localhost:8080/limit-3", ""),
        ("curl -v --fail -F 'file1=@/tmp/a.txt' http://localhost:8080/upload", ""),
        ("curl -v --fail http://localhost:8080/lrucache", ""),
        ("curl -v --fail http://localhost:8080/signal", ""),
        ("curl -v --fail http://localhost:8080/tablepool", ""),
        ("curl -v --fail http://localhost:8080/lock", ""),
        ("curl -v --fail http://localhost:8080/string", ""),
        ("curl -v --fail http://localhost:8080/cjson", ""),
    ]
    
    # Create test file for upload test
    with open("/tmp/a.txt", "w") as f:
        f.write("hello world")
    
    for cmd, expected in test_cases:
        try:
            result = run_command(cmd, check=False, capture_output=True)
            if expected and expected not in result.stdout:
                print(f"Test failed: {cmd}")
                print(f"Expected: {expected}")
                print(f"Got: {result.stdout}")
                handle_error()
        except Exception as e:
            print(f"Test failed: {cmd}")
            print(f"Error: {e}")
            handle_error()
    
    print("All tests passed!")


def test_docker_image(docker_tag):
    """Test a Docker image."""
    ret = run_container(docker_tag)
    if ret == 0:
        return
    
    inject_dependencies(docker_tag)
    wait_for_nginx()
    exec_tests()
    tear_down_container()


def test_system_package(docker_tag):
    """Test a system package."""
    ret = run_container_base(docker_tag)
    if ret == 0:
        return
    
    inject_dependencies(docker_tag)
    wait_for_nginx()
    exec_tests()
    tear_down_container()


def main():
    """Main function."""
    parser = argparse.ArgumentParser(
        description="Test nginx-lua Docker images and system packages",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s alpine amd64
  %(prog)s ubuntu arm64 3 docker
  %(prog)s debian amd64 1 package

Test types:
  docker   - Test Docker images (default)
  package  - Test system packages
        """
    )
    
    parser.add_argument("os", help="Operating system (alpine, ubuntu, debian, etc.)")
    parser.add_argument("arch", help="Architecture (amd64, arm64)")
    parser.add_argument("max", nargs="?", default=1, type=int, help="Maximum number of images to test (default: 1)")
    parser.add_argument("type", nargs="?", default="docker", choices=["docker", "package"], help="Test type (default: docker)")
    
    args = parser.parse_args()
    
    # Show Docker images
    run_command("docker images", check=False)
    
    # Find Dockerfiles
    pattern = f"nginx/*/{args.os}/**/Dockerfile"
    dockerfiles = glob.glob(pattern, recursive=True)
    dockerfiles.sort(reverse=True)
    dockerfiles = dockerfiles[:args.max]
    
    for dockerfile in dockerfiles:
        # Extract tag from Dockerfile path
        match = re.search(r'nginx/(.+)/(.+)/(.+)/Dockerfile', dockerfile)
        if match:
            nginx_version, os_distro, os_version = match.groups()
            tag = f"{nginx_version}-{os_distro}{os_version}"
            
            if args.type == "docker":
                print(f"TESTING TAG: {tag}-{args.arch}")
                test_docker_image(f"{tag}-{args.arch}")
            elif args.type == "package":
                saved_tag = os.environ.get('SAVED_TAG', f"{tag}-{args.arch}")
                print(f"TESTING TAG: {saved_tag}")
                test_system_package(saved_tag)


if __name__ == "__main__":
    main() 