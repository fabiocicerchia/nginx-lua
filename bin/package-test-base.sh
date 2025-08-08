#!/bin/bash

# Script variables
DISTRO=""
SUPPORTED_NGINX_VER=""
ARCH=""
PACKAGE_TYPE=""
INSTALL_CMD=""

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <distro> <nginx_version> <arch>

Test nginx package installation for different distributions.

ARGUMENTS:
    distro          Distribution name (alpine, almalinux, amazonlinux, debian, fedora, ubuntu)
    nginx_version   Nginx version to test
    arch            Architecture (amd64, arm64)

OPTIONS:
    -h, --help      Show this help message and exit
EOF
}

# Input validation function
validate_input() {
    # Check if all required arguments are provided
    if [ -z "$DISTRO" ] || [ -z "$SUPPORTED_NGINX_VER" ] || [ -z "$ARCH" ]; then
        echo "Error: Missing required arguments" >&2
        echo "Use '$(basename "$0") --help' for usage information" >&2
        exit 1
    fi
}

# Parse command line arguments
parse_arguments() {
    # Check for help flag
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                show_help
                exit 0
                ;;
        esac
    done

    # Check if we have the right number of positional arguments
    if [ $# -ne 3 ]; then
        echo "Error: Expected 3 arguments, got $#" >&2
        echo "Use '$(basename "$0") --help' for usage information" >&2
        exit 1
    fi

    # Assign positional arguments
    DISTRO="$1"
    SUPPORTED_NGINX_VER="$2"
    ARCH="$3"
}

# Main execution
main() {
    # Parse arguments
    parse_arguments "$@"
    
    # Validate inputs
    validate_input

    # Determine package type and install command based on distribution
    if [ "${DISTRO}" = "alpine" ]; then
        PACKAGE_TYPE=apk
        INSTALL_CMD="apk add -v --allow-untrusted /app/*_noarch.apk"
    elif [ "${DISTRO}" = "almalinux" -o "${DISTRO}" = "amazonlinux" -o "${DISTRO}" = "fedora" ]; then
        PACKAGE_TYPE=rpm
        INSTALL_CMD="yum localinstall -y /app/*_x86_64.rpm"
        if [ "${ARCH}" = "arm64" ]; then
            INSTALL_CMD="yum localinstall -y /app/*.aarch64.rpm"
        fi
    elif [ "${DISTRO}" = "debian" -o "${DISTRO}" = "ubuntu" ]; then
        PACKAGE_TYPE=deb
        INSTALL_CMD="apt update && apt install -yf /app/*_${ARCH}.deb"
    fi

    # Test package installation
    docker rm -f test-$$PACKAGE_TYPE || true
    docker run --name test-$$PACKAGE_TYPE -v $$PWD/dist:/app -d ${DISTRO}:latest sleep infinity
    docker exec test-$$PACKAGE_TYPE /bin/sh -c "ls -lah /app"
    docker exec test-$$PACKAGE_TYPE /bin/sh -c "$$INSTALL_CMD"
    docker exec test-$$PACKAGE_TYPE /bin/sh -c "envsubst -V
        && nginx -V
        && nginx -t
        && luajit -v
        && lua -v
        && luarocks --version"
    docker rm -f test-$$PACKAGE_TYPE

    ./bin/test.sh "${DISTRO}" "${ARCH}" "" "package"
}

# Run main function with all arguments
main "$@"