#!/bin/bash
# shellcheck disable=SC1091,SC2207

set -e

# Script variables
OS=""
ARCH=""
MAX="1"
TYPE="docker"

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <os> <arch> [max] [type]

Test nginx-lua docker images for different operating systems and architectures.

ARGUMENTS:
    os              Operating system (alpine, almalinux, amazonlinux, debian, fedora, ubuntu)
    arch            Architecture (amd64, arm64)
    max             Maximum number of Dockerfiles to test (default: 1)
    type            Test type: docker or package (default: docker)

OPTIONS:
    -h, --help      Show this help message and exit
EOF
}

# Input validation function
validate_input() {
    # Check if required arguments are provided
    if [ -z "$OS" ] || [ -z "$ARCH" ]; then
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

    # Check if we have the minimum required arguments
    if [ $# -lt 2 ]; then
        echo "Error: Expected at least 2 arguments, got $#" >&2
        echo "Use '$(basename "$0") --help' for usage information" >&2
        exit 1
    fi

    # Assign positional arguments
    OS="$1"
    ARCH="$2"
    
    # Optional arguments
    if [ $# -ge 3 ]; then
        MAX="$3"
    fi
    
    if [ $# -ge 4 ]; then
        TYPE="$4"
    fi
}

function handle_error() {
    docker logs nginx_lua_test
    exit 1
}

function run_container() {
    DOCKER_TAG=$1

    docker rm -f nginx_lua_test 2>/dev/null || true

    FOUND=$(docker image ls -q fabiocicerchia/nginx-lua:"$DOCKER_TAG" | wc -l)
    if [ "$FOUND" -eq "0" ]; then
        return 0;
    fi

    docker run -d --name nginx_lua_test -p 8080:80 -e SKIP_TRACK=1 \
        -v "$PWD"/test/nginx-lua.conf:/etc/nginx/nginx.conf \
        -v "$PWD"/test/tests.conf.d:/etc/nginx/tests.conf.d \
        -v "$PWD"/test/geoip:/etc/nginx/geoip \
        fabiocicerchia/nginx-lua:"$DOCKER_TAG"
}

function inject_dependencies() {
    trap 'handle_error' ERR

    DOCKER_TAG=$1

    if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
        # Ref: https://github.com/luarocks/luarocks/issues/952
        docker exec nginx_lua_test apk add gcc musl-dev coreutils wget
    elif [[ "$DOCKER_TAG" == *"ubuntu"* ]] || [[ "$DOCKER_TAG" == *"debian"* ]]; then
        docker exec nginx_lua_test apt update
        docker exec nginx_lua_test apt install -y gcc musl-dev coreutils unzip
    elif [[ "$DOCKER_TAG" == *"almalinux"* ]] || [[ "$DOCKER_TAG" == *"fedora"* ]] || [[ "$DOCKER_TAG" == *"amazon"* ]]; then
        docker exec nginx_lua_test yum install -y gcc musl-devel coreutils unzip
    fi

    # cannot run on almalinux (which uses 5.1) :
    # 	/usr/lib64/lua/5.3/cjson.so: undefined symbol: lua_rotate
    docker exec nginx_lua_test luarocks install lua-cjson
}

function wait_for_nginx() {
    PORT=${1:-8080}

    COUNT=0
    until [ $COUNT -eq 20 ] || [ "$(curl --output /dev/null --silent --head --fail "http://localhost:${PORT}"; echo $?)" == "0" ]; do
        echo -n '.'
        sleep 1
        COUNT=$((COUNT + 1))
    done
}

function tear_down_containers() {
    docker logs nginx_lua_test
    docker logs nginx_lua_test_issue_151

    docker rm -f nginx_lua_test 2>/dev/null || true
    docker rm -f nginx_lua_test_issue_151 2>/dev/null || true
}

function exec_tests() {
    trap 'handle_error' ERR

    curl -v http://localhost:8080 | grep "Welcome to nginx"
    curl -v http://localhost:8080/lua_content | grep "Hello world"
    docker exec nginx_lua_test curl -v --fail http://localhost:80/status | grep "Nginx Worker PID"
    docker exec nginx_lua_test curl -v --fail http://localhost:80/metrics
    curl -H'Connection: upgrade' -H'Upgrade: websocket' -H'Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==' -H'Sec-WebSocket-Version: 13' http://localhost:8080/socket | grep -a "Hello world"
    curl -v --fail http://localhost:8080/shell | grep "ok" | grep -v "not ok"
    curl -v --fail http://localhost:8080/dns | grep "www.google.com"
    curl -v --fail --cookie 'lang=en' http://localhost:8080/cookie 2>&1 | grep "Set-Cookie: Name=Bob"
    curl -v --fail http://localhost:8080/headers 2>&1 | grep "X-MyHeader: blah"
    curl -v --fail http://localhost:8080/type 2>&1 | grep "Content-Type: text/plain"

    curl -v --fail http://localhost:8080/memcached
    # TODO: missing https://github.com/openresty/lua-resty-string
    # curl -v --fail http://localhost:8080/mysql
    curl -v --fail http://localhost:8080/redis
    curl -v --fail http://localhost:8080/foo
    curl -v --fail http://localhost:8080/bar-mysql
    curl -v --fail http://localhost:8080/bar-pgsql
    curl -v --fail http://localhost:8080/json
    curl -v --fail http://localhost:8080/baz
    curl -v --fail http://localhost:8080/foo-hash
    curl -v --fail http://localhost:8080/base32
    curl -v --fail http://localhost:8080/base64
    curl -v --fail http://localhost:8080/hex
    curl -v --fail http://localhost:8080/sha1
    curl -v --fail http://localhost:8080/sha1-2
    curl -v --fail http://localhost:8080/today
    curl -v --fail http://localhost:8080/signature
    curl -v --fail http://localhost:8080/rand
    curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/country | grep "US" # OPENDNS IP
    curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/city | egrep "Wright City|San Francisco"
    curl -v --fail http://localhost:8080/limit-1
    curl -v --fail http://localhost:8080/limit-2
    curl -v --fail http://localhost:8080/limit-3
    echo "hello world" > /tmp/a.txt
    curl -v --fail -F "file1=@/tmp/a.txt" http://localhost:8080/upload
    curl -v --fail http://localhost:8080/lrucache
    curl -v --fail http://localhost:8080/signal
    curl -v --fail http://localhost:8080/tablepool
    curl -v --fail http://localhost:8080/lock
    curl -v --fail http://localhost:8080/string
    curl -v --fail http://localhost:8080/cjson

    test_issue_151
}

function test_issue_151() {
    docker rm -f nginx_lua_test_issue_151 2>/dev/null || true
    docker run -d --name nginx_lua_test_issue_151 -p 8081:80 -e SKIP_TRACK=1 \
        -v "$PWD"/test/tests.conf.d/regressions/issue-151.conf:/etc/nginx/nginx.conf \
        fabiocicerchia/nginx-lua:"$DOCKER_TAG"
    wait_for_nginx 8081

    # Ref: https://github.com/fabiocicerchia/nginx-lua/issues/151
    curl -v http://localhost:8081/metrics
    LOGS_FOUND=$(docker logs nginx_lua_test_issue_151 | grep "ngx.sleep(0) called without delayed events patch, this will hurt performance" || true)
    if [ "$LOGS_FOUND" != "" ]; then
        handle_error
    fi
}

function do_test() {
    DOCKER_TAG=$1

    RET=$(run_container "$DOCKER_TAG")
    if [ "$RET" = "0" ]; then
        return;
    fi

    inject_dependencies "$DOCKER_TAG"
    wait_for_nginx
    exec_tests
    tear_down_containers
}

# Main execution
main() {
    # Parse arguments
    parse_arguments "$@"
    
    # Validate inputs
    validate_input

    set -eux

    docker images

    for DOCKERFILE in $(find nginx/*/"$OS" -name "Dockerfile" -type f | sort -Vr | head -n "$MAX"); do
        TAG=$(echo "$DOCKERFILE" | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/Dockerfile_\1-\2\3_')

        TESTING_TAG="$TAG-$ARCH"

        echo "TESTING TAG: ${TESTING_TAG}"
        do_test "$TESTING_TAG"
    done
}

# Run main function with all arguments
main "$@"
