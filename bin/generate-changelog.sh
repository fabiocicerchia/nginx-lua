#!/bin/bash

# Script variables
GH_USERNAME=""
PREVIOUS_TAG=""
TAG_VER=""

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <gh_username> <previous_tag> <tag_ver>

Generates a changelog.

ARGUMENTS:
    gh_username     GitHub username
    previous_tag    Last known tag
    tag_ver         Current tag

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
    GH_USERNAME="$1"
    PREVIOUS_TAG="$2"
    TAG_VER="$3"
}

# Main execution
main() {
    # Parse arguments
    parse_arguments "$@"
    
    # Validate inputs
    validate_input

    git fetch --all --tags > /dev/null
    echo "## What's Changed"
    git log --pretty=format:"- %B" "${PREVIOUS_TAG}..HEAD" | tr '\r' '\n' | tr 'A-Z' 'a-z' | grep -Ev '^$$' | sed 's/ *[-*]/ -/' | uniq | tee CHANGELOG
    cat CHANGELOG | egrep -v "Automated (metadata|updates)" | sed -e 's/^*/-/' -e 's/"/\\"/g' -e 's/^[ \t]*//' -e 's/^-[ \t]*//' -e 's/^-[ \t]*//' -e 's/^/ - /' | awk '!x[$$0]++' | tee CHANGELOG
    echo ""
    echo "**Full Changelog**: https://github.com/${GH_USERNAME}/nginx-lua/compare/${PREVIOUS_TAG}...${TAG_VER}"
    echo ""
    echo "## Supported Versions"
    cat supported_versions | sed 's/[()"]//g' | tr 'A-Z' 'a-z' | sed 's/^/ - /'
}

# Run main function with all arguments
main "$@"