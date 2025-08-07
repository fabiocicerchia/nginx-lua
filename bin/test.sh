#!/bin/bash
# shellcheck disable=SC1091,SC2207

set -e

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

function run_container_base() {
    DOCKER_TAG=$1
    ARCH=$(dpkg --print-architecture)

    if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
        IMAGE=alpine
		INSTALL_CMD="apk add -v --allow-untrusted /app/*_noarch.apk"
    elif [[ "$DOCKER_TAG" == *"ubuntu"* ]]; then
        IMAGE=ubuntu
		INSTALL_CMD="apt update && apt install -yf /app/*_$ARCH.deb"
    elif [[ "$DOCKER_TAG" == *"debian"* ]]; then
        IMAGE=debian
		INSTALL_CMD="apt update && apt install -yf /app/*_$ARCH.deb"
    elif [[ "$DOCKER_TAG" == *"almalinux"* ]]; then
        IMAGE=almalinux
		INSTALL_CMD="yum localinstall -y /app/*.x86_64.rpm"
		if [ "$ARCH" = "arm64" ]; then
			INSTALL_CMD="yum localinstall -y /app/*.aarch64.rpm"
		fi
    elif [[ "$DOCKER_TAG" == *"fedora"* ]]; then
        IMAGE=fedora
		INSTALL_CMD="yum localinstall -y /app/*.x86_64.rpm"
		if [ "$ARCH" = "arm64" ]; then
			INSTALL_CMD="yum localinstall -y /app/*.aarch64.rpm"
		fi
    elif [[ "$DOCKER_TAG" == *"amazon"* ]]; then
        IMAGE=amazonlinux
		INSTALL_CMD="yum localinstall -y /app/*.x86_64.rpm"
		if [ "$ARCH" = "arm64" ]; then
			INSTALL_CMD="yum localinstall -y /app/*.aarch64.rpm"
		fi
    fi

    docker rm -f nginx_lua_test 2>/dev/null || true

    docker run -d --name nginx_lua_test -p 8080:80 -e SKIP_TRACK=1 \
        -v "$PWD"/test/nginx-lua.conf:/etc/nginx/nginx.conf.new \
        -v "$PWD"/test/tests.conf.d:/etc/nginx/tests.conf.d \
        -v "$PWD"/test/geoip:/etc/nginx/geoip \
        -v "$PWD"/dist:/app \
        "$IMAGE:latest" sleep infinity

    docker exec nginx_lua_test /bin/sh -c "$INSTALL_CMD"
    docker exec nginx_lua_test /bin/sh -c "cp /etc/nginx/nginx.conf.new /etc/nginx/nginx.conf"
    docker exec nginx_lua_test /bin/sh -c "/usr/sbin/nginx"
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
    elif [[ "$DOCKER_TAG" == *"almalinux"* ]]; then
        docker exec nginx_lua_test yum install -y gcc unzip
    elif [[ "$DOCKER_TAG" == *"fedora"* ]]; then
        docker exec nginx_lua_test yum install -y gcc musl-devel coreutils unzip
    elif [[ "$DOCKER_TAG" == *"amazon"* ]]; then
        docker exec nginx_lua_test yum install -y gcc
    fi
    # cannot run on almalinux (which uses 5.1) :
    # 	/usr/lib64/lua/5.3/cjson.so: undefined symbol: lua_rotate
    docker exec nginx_lua_test luarocks install lua-cjson
}

function wait_for_nginx() {
    COUNT=0
    until [ $COUNT -eq 20 ] || [ "$(curl --output /dev/null --silent --head --fail http://localhost:8080; echo $?)" == "0" ]; do
        echo -n '.'
        sleep 1
        COUNT=$((COUNT + 1))
    done
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
    docker rm -f nginx_lua_test # tear_down_container
}

set -eux

OS=$1
ARCH=$2
MAX=${3:-1}
TYPE=${4:-docker}

docker images

for DOCKERFILE in $(find nginx/*/"$OS" -name "Dockerfile" -type f | sort -Vr | head -n "$MAX"); do
    TAG=$(echo "$DOCKERFILE" | sed 's_nginx/\(.*\)/\(.*\)/\(.*\)/Dockerfile_\1-\2\3_')

    if [ "$TYPE" = "docker" ]; then
        SAVED_TAG=
    fi
    TESTING_TAG="${SAVED_TAG:-$TAG-$ARCH}"

    echo "TESTING TAG: ${TESTING_TAG}"
    do_test "$TESTING_TAG"
done
