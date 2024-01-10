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
    DOCKER_TAG=$1

    if [[ "$DOCKER_TAG" == *"alpine"* ]]; then
        # Ref: https://github.com/luarocks/luarocks/issues/952
        docker exec nginx_lua_test apk add gcc musl-dev coreutils wget || handle_error
    elif [[ "$DOCKER_TAG" == *"ubuntu"* ]] || [[ "$DOCKER_TAG" == *"debian"* ]]; then
        docker exec nginx_lua_test apt update || handle_error
        docker exec nginx_lua_test apt install -y gcc musl-dev coreutils unzip || handle_error
    elif [[ "$DOCKER_TAG" == *"almalinux"* ]]; then
        docker exec nginx_lua_test yum install -y gcc unzip || handle_error
    elif [[ "$DOCKER_TAG" == *"fedora"* ]]; then
        docker exec nginx_lua_test yum install -y gcc musl-devel coreutils unzip || handle_error
    elif [[ "$DOCKER_TAG" == *"amazon"* ]]; then
        docker exec nginx_lua_test yum install -y gcc || handle_error
    fi
    # cannot run on almalinux (which uses 5.1) :
    # 	/usr/lib64/lua/5.3/cjson.so: undefined symbol: lua_rotate
    docker exec nginx_lua_test luarocks install lua-cjson || handle_error
}

function wait_for_nginx() {
    COUNT=0
    until [ $COUNT -eq 20 ] || [ "$(
        curl --output /dev/null --silent --head --fail http://localhost:8080
        echo $?
    )" == "0" ]; do
        echo -n '.'
        sleep 1
        COUNT=$((COUNT + 1))
    done
}

function tear_down_container() {
    docker rm -f nginx_lua_test
}

function exec_tests() {
    curl -v http://localhost:8080 | grep "Welcome to nginx" || handle_error
    curl -v http://localhost:8080/lua_content | grep "Hello world" || handle_error
    docker exec nginx_lua_test curl -v --fail http://localhost:80/status | grep "Nginx Worker PID" || handle_error
    docker exec nginx_lua_test curl -v --fail http://localhost:80/metrics || handle_error
    curl -H'Connection: upgrade' -H'Upgrade: websocket' -H'Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==' -H'Sec-WebSocket-Version: 13' http://localhost:8080/socket | grep -a "Hello world" || handle_error
    curl -v --fail http://localhost:8080/shell | grep "ok" | grep -v "not ok" || handle_error
    curl -v --fail http://localhost:8080/dns | grep "www.google.com" || handle_error
    curl -v --fail --cookie 'lang=en' http://localhost:8080/cookie 2>&1 | grep "Set-Cookie: Name=Bob" || handle_error
    curl -v --fail http://localhost:8080/headers 2>&1 | grep "X-MyHeader: blah" || handle_error
    curl -v --fail http://localhost:8080/type 2>&1 | grep "Content-Type: text/plain" || handle_error

    curl -v --fail http://localhost:8080/memcached || handle_error
    # TODO: missing https://github.com/openresty/lua-resty-string
    # curl -v --fail http://localhost:8080/mysql || handle_error
    curl -v --fail http://localhost:8080/redis || handle_error
    curl -v --fail http://localhost:8080/foo || handle_error
    curl -v --fail http://localhost:8080/bar-mysql || handle_error
    curl -v --fail http://localhost:8080/bar-pgsql || handle_error
    curl -v --fail http://localhost:8080/json || handle_error
    curl -v --fail http://localhost:8080/baz || handle_error
    curl -v --fail http://localhost:8080/foo-hash || handle_error
    curl -v --fail http://localhost:8080/base32 || handle_error
    curl -v --fail http://localhost:8080/base64 || handle_error
    curl -v --fail http://localhost:8080/hex || handle_error
    curl -v --fail http://localhost:8080/sha1 || handle_error
    curl -v --fail http://localhost:8080/sha1-2 || handle_error
    curl -v --fail http://localhost:8080/today || handle_error
    curl -v --fail http://localhost:8080/signature || handle_error
    curl -v --fail http://localhost:8080/rand || handle_error
    curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/country | grep "US" || handle_error # OPENDNS IP
    curl -v --fail -H 'X-Fake-Source: 208.67.222.222' http://localhost:8080/geo/city | grep "Wright City" || handle_error
    curl -v --fail http://localhost:8080/limit-1 || handle_error
    curl -v --fail http://localhost:8080/limit-2 || handle_error
    curl -v --fail http://localhost:8080/limit-3 || handle_error
    echo "hello world" > /tmp/a.txt
    curl -v --fail -F "file1=@/tmp/a.txt" http://localhost:8080/upload || handle_error
    curl -v --fail http://localhost:8080/lrucache || handle_error
    curl -v --fail http://localhost:8080/signal || handle_error
    curl -v --fail http://localhost:8080/tablepool || handle_error
    curl -v --fail http://localhost:8080/lock || handle_error
}

function test_docker_image() {
    DOCKER_TAG=$1

    RET=$(run_container "$DOCKER_TAG")
    if [ "$RET" = "0" ]; then
        return;
    fi
    inject_dependencies "$DOCKER_TAG"
    wait_for_nginx
    exec_tests
    tear_down_container
}

function test_system_package() {
    DOCKER_TAG=$1

    RET=$(run_container "$DOCKER_TAG")
    if [ "$RET" = "0" ]; then
        return;
    fi
    inject_dependencies "$DOCKER_TAG"
    wait_for_nginx
    exec_tests
    tear_down_container
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
        echo "TESTING TAG: $TAG-$ARCH"
        test_docker_image "$TAG-$ARCH"
    elif [ "$TYPE" = "package" ]; then
        echo "TESTING TAG: ${SAVED_TAG:-$TAG-$ARCH}"
        test_system_package "${SAVED_TAG:-$TAG-$ARCH}"
    fi
done
