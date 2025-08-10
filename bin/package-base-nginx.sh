#!/bin/bash

# Script variables
DISTRO=""
SUPPORTED_NGINX_VER=""
ARCH=""
PACKAGE_TYPE=""

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <distro> <nginx_version> <arch>

Build and extract nginx packages for different distributions.

ARGUMENTS:
    distro          Distribution name (alpine, almalinux, amazonlinux, debian, fedora, ubuntu)
    nginx_version   Nginx version to build
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
    # Check for help or version flags
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

    # Determine package type based on distribution
    if [ "${DISTRO}" = "alpine" ]; then
        PACKAGE_TYPE=apk
    elif [ "${DISTRO}" = "almalinux" -o "${DISTRO}" = "amazonlinux" -o "${DISTRO}" = "fedora" ]; then
        PACKAGE_TYPE=rpm
    elif [ "${DISTRO}" = "debian" -o "${DISTRO}" = "ubuntu" ]; then
        PACKAGE_TYPE=deb
    fi

    # Override nginx version if IMAGE_ID is set
    if [ "${IMAGE_ID}" != "" ]; then
        SUPPORTED_NGINX_VER=1
    fi

    # Create dist directory
    mkdir -p dist

    source supported_versions
    OS_VER=${!DISTRO}

    # Build Docker image
    docker build \
        -f src/packages/Dockerfile.$PACKAGE_TYPE \
        -t package-nginx-$PACKAGE_TYPE \
        --build-arg ARCH="${ARCH}" \
        --build-arg NGINX_VERSION="${SUPPORTED_NGINX_VER}" \
        --build-arg DISTRO="${DISTRO}" \
        --build-arg OS_VERSION="${OS_VER}" \
        --build-arg FPM_OUTPUT_TYPE="$PACKAGE_TYPE" \
        src/packages

    # Extract package from container
    docker inspect extract-$PACKAGE_TYPE > /dev/null 2>&1 && docker rm -f extract-$PACKAGE_TYPE
    docker run -d --name extract-$PACKAGE_TYPE package-nginx-$PACKAGE_TYPE
    docker exec extract-$PACKAGE_TYPE sh -c "ls -1 /nginx-lua*.$PACKAGE_TYPE"
    docker cp extract-$PACKAGE_TYPE:$(docker exec extract-$PACKAGE_TYPE sh -c "ls -1 /nginx-lua*.$PACKAGE_TYPE") dist/
    docker rm -f extract-$PACKAGE_TYPE

    # List files
    if [ "${DISTRO}" = "alpine" ]; then
        sudo apt install -y apktool
        apktool d dist/*.apk || true # TODO: To be fixed in https://github.com/fabiocicerchia/nginx-lua/issues/152
    elif [ "${DISTRO}" = "almalinux" -o "${DISTRO}" = "amazonlinux" -o "${DISTRO}" = "fedora" ]; then
        sudo apt install -y rpm2cpio cpio
        rpm2cpio dist/*.rpm | cpio -i --list
    elif [ "${DISTRO}" = "debian" -o "${DISTRO}" = "ubuntu" ]; then
        dpkg-deb -c dist/*.deb
    fi
}

# Run main function with all arguments
main "$@"