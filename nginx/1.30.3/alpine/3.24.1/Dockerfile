#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

ARG ARCH=
ARG DISTRO=alpine
ARG DISTRO_VER=3.24.1

#############################
# Settings Common Variables #
#############################
FROM ${ARCH}/$DISTRO:$DISTRO_VER AS base

ARG ARCH=
ENV ARCH=$ARCH

ENV DOCKER_IMAGE=fabiocicerchia/nginx-lua
ENV DOCKER_IMAGE_OS=${DISTRO}
ENV DOCKER_IMAGE_TAG=${DISTRO_VER}

ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
ARG VCS_REF
ENV VCS_REF=$VCS_REF

# NGINX
################################################################################

# nginx
# https://github.com/nginx/nginx/releases
ARG VER_NGINX=1.30.3
ENV VER_NGINX=$VER_NGINX

# NGINX MODULES
################################################################################

# ngx_devel_kit
# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ARG VER_NGX_DEVEL_KIT=0.3.4
ENV VER_NGX_DEVEL_KIT=$VER_NGX_DEVEL_KIT

# njs
# https://github.com/nginx/njs
ARG VER_NJS=1.0.0
ENV VER_NJS=$VER_NJS

# geoip2
# https://github.com/leev/ngx_http_geoip2_module
ARG VER_GEOIP=3.4
ENV VER_GEOIP=$VER_GEOIP

# LUA
################################################################################

# luajit2
# https://github.com/openresty/luajit2
# Note: LuaJIT2 is stuck on Lua 5.1 since 2009.
# OpenResty's LuaJIT headers will be used.
# The `lua` interpreter is an alias of `luajit` to maintain the same version
# consistently in the system. If needed to use the latest Lua version (ie >=5.4)
# the os system package would be required, resulting in a system with multiple
# versions available.
ARG VER_LUAJIT=2.1-20260701
ENV VER_LUAJIT=$VER_LUAJIT
ARG LUAJIT_LIB=/usr/local/lib
ENV LUAJIT_LIB=$LUAJIT_LIB
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ENV LUAJIT_INC=$LUAJIT_INC
ARG LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# lua-nginx-module
# https://github.com/openresty/lua-nginx-module
# Production ready.
ARG VER_LUA_NGINX_MODULE=0.10.31
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.34rc2
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.1
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# LUAROCKS
################################################################################

# lua-rocks
# https://luarocks.github.io/luarocks/releases/
ARG VER_LUAROCKS=3.13.0
ENV VER_LUAROCKS=$VER_LUAROCKS

# LUA ADDONS
################################################################################

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module
ARG VER_OPENRESTY_HEADERS=0.40
ENV VER_OPENRESTY_HEADERS=$VER_OPENRESTY_HEADERS

# lua-resty-cookie
# https://github.com/cloudflare/lua-resty-cookie
ARG VER_CLOUDFLARE_COOKIE=f418d77082eaef48331302e84330488fdc810ef4
ENV VER_CLOUDFLARE_COOKIE=$VER_CLOUDFLARE_COOKIE

# lua-resty-dns
# https://github.com/openresty/lua-resty-dns
ARG VER_OPENRESTY_DNS=0.23
ENV VER_OPENRESTY_DNS=$VER_OPENRESTY_DNS

# lua-resty-lrucache
# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ARG VER_LUA_RESTY_LRUCACHE=0.15
ENV VER_LUA_RESTY_LRUCACHE=$VER_LUA_RESTY_LRUCACHE

# lua-resty-memcached
# https://github.com/openresty/lua-resty-memcached
ARG VER_OPENRESTY_MEMCACHED=0.18
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql
ARG VER_OPENRESTY_MYSQL=0.31
ENV VER_OPENRESTY_MYSQL=$VER_OPENRESTY_MYSQL

# lua-resty-redis
# https://github.com/openresty/lua-resty-redis
ARG VER_OPENRESTY_REDIS=0.33
ENV VER_OPENRESTY_REDIS=$VER_OPENRESTY_REDIS

# lua-resty-shell
# https://github.com/openresty/lua-resty-shell
ARG VER_OPENRESTY_SHELL=0.03
ENV VER_OPENRESTY_SHELL=$VER_OPENRESTY_SHELL

# lua-resty-signal
# https://github.com/openresty/lua-resty-signal
ARG VER_OPENRESTY_SIGNAL=0.05
ENV VER_OPENRESTY_SIGNAL=$VER_OPENRESTY_SIGNAL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck
ARG VER_OPENRESTY_HEALTHCHECK=0.10
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket
ARG VER_OPENRESTY_WEBSOCKET=0.14
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-tablepool
# https://github.com/openresty/lua-tablepool
ARG VER_OPENRESTY_TABLEPOOL=0.03
ENV VER_OPENRESTY_TABLEPOOL=$VER_OPENRESTY_TABLEPOOL

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module
ARG VER_LUA_UPSTREAM=0.08
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus
ARG VER_PROMETHEUS=0.20240525
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# set-misc-nginx-module
# https://github.com/openresty/set-misc-nginx-module
ARG VER_MISC_NGINX=0.34
ENV VER_MISC_NGINX=$VER_MISC_NGINX

# echo-nginx-module
# https://github.com/openresty/echo-nginx-module
# Provides the echo/echo_sleep directives this project's own test: target
# depends on: lua-resty-core, lua-resty-upstream-healthcheck, lua-resty-redis,
# and lua-resty-memcached's own vendored test suites all use them.
ARG VER_ECHO_NGINX=0.65
ENV VER_ECHO_NGINX=$VER_ECHO_NGINX

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module
ARG VER_OPENRESTY_STREAMLUA=889cb589150a261811dc1b6d0d19e8a252ff3081
ENV VER_OPENRESTY_STREAMLUA=$VER_OPENRESTY_STREAMLUA

# lua-resty-limit-traffic
# https://github.com/openresty/lua-resty-limit-traffic/tags
ARG VER_OPENRESTY_LIMITTRAFFIC=0.09
ENV VER_OPENRESTY_LIMITTRAFFIC=$VER_OPENRESTY_LIMITTRAFFIC

# lua-resty-upload
# https://github.com/openresty/lua-resty-upload/tags
ARG VER_OPENRESTY_UPLOAD=0.11
ENV VER_OPENRESTY_UPLOAD=$VER_OPENRESTY_UPLOAD

# lua-resty-lock
# https://github.com/openresty/lua-resty-lock/tags
ARG VER_OPENRESTY_LOCK=0.09
ENV VER_OPENRESTY_LOCK=$VER_OPENRESTY_LOCK

# lua-resty-balancer
# https://github.com/openresty/lua-resty-balancer/tags
ARG VER_OPENRESTY_BALANCER=0.05
ENV VER_OPENRESTY_BALANCER=$VER_OPENRESTY_BALANCER

# lua-resty-string
# https://github.com/openresty/lua-resty-string/tags
ARG VER_OPENRESTY_STRING=0.19
ENV VER_OPENRESTY_STRING=$VER_OPENRESTY_STRING

################################################################################

# Replicate same official env variable
ENV NGINX_VERSION   $VER_NGINX
ENV NJS_VERSION     $VER_NJS
ENV PKG_RELEASE     1~$DISTRO_VER

# References:
#  - https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
#  - https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
# -g                        Generate debugging information
# -O2                       Recommended optimizations
# -fstack-protector-strong  Stack smashing protector
# -Wformat                  Check calls to make sure that the arguments supplied have types appropriate to the format string specified
# -Werror=format-security   Reject potentially unsafe format string arguents
# -Wp,-D_FORTIFY_SOURCE=2   Run-time buffer overflow detection
# -fPIC                     No text relocations
# ORIGINAL VALUE: -g -O2 -ffile-prefix-map=/home/builder/debuild/nginx-1.27.5/debian/debuild-base/nginx-1.27.5=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC
ARG NGX_CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC"
ENV NGX_CFLAGS=$NGX_CFLAGS
# References
#  - https://developers.redhat.com/blog/2018/03/21/compiler-and-linker-flags-gcc
#  - https://wiki.debian.org/ToolChain/DSOLinking#Unresolved_symbols_in_shared_libraries
#  - https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_3.html
#  - https://linux.die.net/man/1/ld
# -Wl,-rpath,/usr/local/lib   Add a directory to the runtime library search path
# -Wl,-z,relro                Read-only segments after relocation
# -Wl,-z,now                  Disable lazy binding
# -Wl,--as-needed             Only link with needed libraries
# -pie                        Full ASLR for executables
# ORIGINAL VALUE: -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie
ARG NGX_LDOPT="-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie"
ENV NGX_LDOPT=$NGX_LDOPT
# Reference: http://nginx.org/en/docs/configure.html
ARG NGINX_BUILD_CONFIG="\
            --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/run/nginx.pid \
            --lock-path=/run/nginx.lock \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
            --user=nginx \
            --group=nginx \
            `# OFFICIAL MODULES` \
            --with-compat \
            --with-file-aio \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-http_v3_module \
            --with-poll_module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            `# CUSTOM MODULES` \
            --add-module=/headers-more-nginx-module-${VER_OPENRESTY_HEADERS} \
            --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
            --add-module=/lua-upstream-nginx-module-${VER_LUA_UPSTREAM} \
            --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
            --add-module=/ngx_http_geoip2_module-${VER_GEOIP} \
            --add-module=/njs-${VER_NJS}/nginx \
            --add-module=/set-misc-nginx-module-${VER_MISC_NGINX} \
            --add-module=/echo-nginx-module-${VER_ECHO_NGINX} \
            --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
"
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS_BASE="\
        curl \
        gzip \
        libmaxminddb-dev \
        make \
        openssl-dev \
        patch \
        pcre2-dev \
        perl \
        perl-app-cpanminus \
        perl-dev \
        tar \
        zlib-dev \
# TEST-ONLY: real daemons for lua-resty-memcached/mysql/redis suites.
# A second, TLS-enabled memcached is built from source (see .prereq-test)
# since packaged builds aren't consistently TLS-enabled across distros.
# perl-lwp-protocol-https: once Test::Nginx::Socket pulls in LWP::UserAgent,
# cpanm's own cpanmetadb lookups need https support too, and cpanm can't
# bootstrap that module itself (see .prereq-test).
# openssl: the CLI binary - openssl-dev's headers don't pull it in - needed
# to generate the throwaway CA+leaf cert chains for memcached/redis TLS tests.
        libevent-dev \
        mariadb \
        mariadb-client \
        memcached \
        openssl \
        perl-lwp-protocol-https \
        redis \
"
ENV BUILD_DEPS_BASE=$BUILD_DEPS_BASE
ARG BUILD_DEPS_AMD64="\
        ${BUILD_DEPS_BASE} \
        g++ \
"
ENV BUILD_DEPS_AMD64=$BUILD_DEPS_AMD64
ARG BUILD_DEPS_ARM64V8="\
        ${BUILD_DEPS_BASE} \
        gcc-aarch64-none-elf \
"
ENV BUILD_DEPS_ARM64V8=$BUILD_DEPS_ARM64V8
ENV BUILD_DEPS=

ARG NGINX_BUILD_DEPS="\
# NGINX
        alpine-sdk \
        bash \
        findutils \
        gcc \
        libc-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        openssl-dev \
# pcre2-dev (not pcre-dev): nginx's configure auto-detects and prefers
# whichever is present, silently linking the old PCRE1 if only pcre-dev is
# installed. lua-resty-core's own upstream CI explicitly builds against
# PCRE2 (PCRE2_VER pin in .travis.yml), and several of its t/re-*.t tests
# assert on PCRE2-specific error strings (e.g. "pcre2_compile() failed:
# missing closing parenthesis" vs PCRE1's "pcre_compile() failed: missing )").
        pcre2-dev \
        zlib-dev \
# OPENRESTY PATCHES
        git \
"
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

# Create nginx user/group in the shared base stage (not just the final stage)
# so it also exists in the builder stage: `make test` spawns nested nginx
# processes whose config has `user nginx;`, and nginx resolves that via
# getpwnam() at startup even before the builder stage's own COPY/final split -
# without this the tests failed with "getpwnam(\"nginx\") failed".
RUN set -x \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx

####################################
# Build Nginx with support for LUA #
####################################
FROM base AS builder

# hadolint ignore=SC2086
RUN set -eux \
    && eval BUILD_DEPS="\$$(echo BUILD_DEPS_${ARCH} | tr '[:lower:]' '[:upper:]')" \
    && apk update \
    && apk add --no-cache \
        $BUILD_DEPS \
        $NGINX_BUILD_DEPS

COPY tpl/Makefile Makefile
COPY tpl/.env.dist .env.dist
COPY tpl/patches patches

RUN make deps \
    && make core \
    && make luarocks

# Test prerequisites: install the heavier Perl deps of Test::Nginx from Alpine's
# repos instead of letting cpanm build them from CPAN source. Building these in
# the minimal builder is flaky (Module::Build::Tiny / libwww-perl / List::MoreUtils
# fail), which previously aborted `make test`. With these present, cpanm only has
# to build the pure-Perl Test-Nginx itself. util-linux: lua-resty-core's
# t/pipe-cpu-affinity.t execvp()s `taskset`, not present in Alpine's base image.
RUN apk add --no-cache \
        perl-libwww \
        perl-http-message \
        perl-http-daemon \
        perl-list-moreutils \
        util-linux

RUN make test

##########################################
# Combine everything with minimal layers #
##########################################
FROM base

# http://label-schema.org/rc1/
LABEL maintainer="Fabio Cicerchia <info@fabiocicerchia.it>" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Nginx ${VER_NGINX} with Lua support based on alpine (${ARCH}) 3.24.1." \
    org.label-schema.docker.cmd="docker run -p 80:80 -d ${DOCKER_IMAGE}:${VER_NGINX}-alpine3.24.1" \
    org.label-schema.name="${DOCKER_IMAGE}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.version="${VER_NGINX}-alpine3.24.1" \
    image.target.platform="${TARGETPLATFORM}" \
    image.target.os="${TARGETOS}" \
    image.target.arch="${ARCH}" \
    versions.os="3.24.1" \
    versions.luajit2="${VER_LUAJIT}" \
    versions.luarocks="${VER_LUAROCKS}" \
    versions.nginx="${VER_NGINX}" \
    versions.ngx_devel_kit="${VER_NGX_DEVEL_KIT}" \
    versions.njs="${VER_NJS}" \
    versions.geoip="${VER_GEOIP}" \
    versions.headers-more-nginx-module="${VER_OPENRESTY_HEADERS}" \
    versions.lua-nginx-module="${VER_LUA_NGINX_MODULE}" \
    versions.lua-resty-balancer="${VER_OPENRESTY_BALANCER}" \
    versions.lua-resty-cookie="${VER_CLOUDFLARE_COOKIE}" \
    versions.lua-resty-core="${VER_LUA_RESTY_CORE}" \
    versions.lua-resty-dns="${VER_OPENRESTY_DNS}" \
    versions.lua-resty-limit-traffic="${VER_OPENRESTY_LIMITTRAFFIC}" \
    versions.lua-resty-lock="${VER_OPENRESTY_LOCK}" \
    versions.lua-resty-lrucache="${VER_LUA_RESTY_LRUCACHE}" \
    versions.lua-resty-memcached="${VER_OPENRESTY_MEMCACHED}" \
    versions.lua-resty-mysql="${VER_OPENRESTY_MYSQL}" \
    versions.lua-resty-redis="${VER_OPENRESTY_REDIS}" \
    versions.lua-resty-shell="${VER_OPENRESTY_SHELL}" \
    versions.lua-resty-signal="${VER_OPENRESTY_SIGNAL}" \
    versions.lua-resty-string="${VER_OPENRESTY_STRING}" \
    versions.lua-resty-tablepool="${VER_OPENRESTY_TABLEPOOL}" \
    versions.lua-resty-upload="${VER_OPENRESTY_UPLOAD}" \
    versions.lua-resty-upstream-healthcheck="${VER_OPENRESTY_HEALTHCHECK}" \
    versions.lua-resty-websocket="${VER_OPENRESTY_WEBSOCKET}" \
    versions.lua-upstream="${VER_LUA_UPSTREAM}" \
    versions.nginx-lua-prometheus="${VER_PROMETHEUS}" \
    versions.set-misc-nginx=${VER_MISC_NGINX} \
    versions.echo-nginx=${VER_ECHO_NGINX} \
    versions.stream-lua-nginx-module="${VER_OPENRESTY_STREAMLUA}"

# wget is required due to https://github.com/luarocks/luarocks/issues/952
ARG PKG_DEPS="\
        curl \
        libmaxminddb-dev \
        libxml2-dev \
        openssl-dev \
        pcre2-dev \
        unzip \
        wget \
        zlib-dev \
"
ENV PKG_DEPS=$PKG_DEPS

COPY --from=builder --chown=101:101 /etc/nginx /etc/nginx
COPY --from=builder --chown=101:101 /usr/local/lib /usr/local/lib
COPY --from=builder --chown=101:101 /usr/local/share/lua /usr/local/share/lua
COPY --from=builder --chown=101:101 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder --chown=101:101 /usr/sbin/nginx-debug /usr/sbin/nginx-debug
COPY --from=builder --chown=101:101 /var/cache/nginx /var/cache/nginx
# luajit
COPY --from=builder --chown=101:101 /usr/local/lib/libluajit* /usr/local/lib/
COPY --from=builder --chown=101:101 /usr/local/lib/pkgconfig/luajit* /usr/local/lib/pkgconfig/
COPY --from=builder --chown=101:101 $LUAJIT_INC $LUAJIT_INC
COPY --from=builder --chown=101:101 /usr/local/bin/luajit* /usr/local/bin/
COPY --from=builder --chown=101:101 /usr/local/share/luajit* /usr/local/share/
COPY --from=builder --chown=101:101 /usr/local/share/man/man1/luajit* /usr/local/share/man/man1/
# luarocks
COPY --from=builder --chown=101:101 /usr/local/share/lua/5.1/luarocks /usr/local/share/lua/5.1/luarocks
COPY --from=builder --chown=101:101 /usr/local/bin/luarocks* /usr/local/bin/
COPY --from=builder --chown=101:101 /usr/local/etc/luarocks /usr/local/etc/luarocks

COPY --chown=101:101 tpl/??-*.sh /docker-entrypoint.d/
COPY --chown=101:101 tpl/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=101:101 tpl/docker-entrypoint.sh /
COPY --chown=101:101 tpl/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 tpl/support.sh /
COPY --chown=101:101 tpl/licenses /licenses

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=SC2086
RUN set -eux \
    && apk update \
    && apk add --no-cache --virtual .pkg_deps \
        $PKG_DEPS \
    && mkdir -p /var/log/nginx \
# Fix LUA alias
    && ln -sf /usr/local/bin/luajit /usr/local/bin/lua

RUN set -x \
# nginx user/group already created in the shared base stage above
# COMMENTED OUT FROM ORIGINAL DOCKERFILE: https://github.com/nginxinc/docker-nginx/blob/1.31.1/mainline/alpine/Dockerfile
# REASON: No need to use the existing distributed package as the binary is recompiled.
#     && apkArch="$(cat /etc/apk/arch)" \
#     && nginxPackages=" \
#         nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
#         nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
#     " \
# # install prerequisites for public key and pkg-oss checks
#     && apk add --no-cache --virtual .checksum-deps \
#         openssl \
#     && case "$apkArch" in \
#         x86_64|aarch64) \
# # arches officially built by upstream
#             apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
#             ;; \
#         *) \
# # we're on an architecture upstream doesn't officially build for
# # let's build binaries from the published packaging sources
#             set -x \
#             && tempDir="$(mktemp -d)" \
#             && chown nobody:nobody $tempDir \
#             && apk add --no-cache --virtual .build-deps \
#                 gcc \
#                 libc-dev \
#                 make \
#                 openssl-dev \
#                 pcre2-dev \
#                 zlib-dev \
#                 linux-headers \
#                 libxslt-dev \
#                 gd-dev \
#                 geoip-dev \
#                 libedit-dev \
#                 bash \
#                 alpine-sdk \
#                 findutils \
#                 curl \
#                 cargo \
#                 clang-libclang \
#             && su nobody -s /bin/sh -c " \
#                 export HOME=${tempDir} \
#                 && cd ${tempDir} \
#                 && curl -f -L -O https://github.com/nginx/pkg-oss/archive/b151aac903a6fc121d57f0909415381d0a1c1bbd.tar.gz \
#                 && PKGOSSCHECKSUM=\"72c13cfedc25a6c1e01c24dd1f736b0fefd1ef7f73ef569e2726fc99c0137327d2e71c8694bd8b0157be2a7247ec1769904746a852e7698caf7df8a5b0040440 *b151aac903a6fc121d57f0909415381d0a1c1bbd.tar.gz\" \
#                 && if [ \"\$(openssl sha512 -r b151aac903a6fc121d57f0909415381d0a1c1bbd.tar.gz)\" = \"\$PKGOSSCHECKSUM\" ]; then \
#                     echo \"pkg-oss tarball checksum verification succeeded!\"; \
#                 else \
#                     echo \"pkg-oss tarball checksum verification failed!\"; \
#                     exit 1; \
#                 fi \
#                 && tar xzvf b151aac903a6fc121d57f0909415381d0a1c1bbd.tar.gz \
#                 && cd pkg-oss-b151aac903a6fc121d57f0909415381d0a1c1bbd \
#                 && cd alpine \
#                 && export BUILDTARGET=\"module-geoip module-image-filter module-njs module-xslt module-acme\" \
#                 && if [ \"\$(apk --print-arch)\" = \"armhf\" ]; then BUILDTARGET=\"\$( echo \$BUILDTARGET | sed 's,module-acme,,' )\"; fi \
#                 && make \$BUILDTARGET \
#                 && apk index --allow-untrusted -o ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz ${tempDir}/packages/alpine/${apkArch}/*.apk \
#                 && abuild-sign -k ${tempDir}/.abuild/abuild-key.rsa ${tempDir}/packages/alpine/${apkArch}/APKINDEX.tar.gz \
#                 " \
#             && cp ${tempDir}/.abuild/abuild-key.rsa.pub /etc/apk/keys/ \
#             && apk del --no-network .build-deps \
#             && if [ "$apkArch" = "armhf" ]; then nginxPackages="$( echo $nginxPackages | sed 's,nginx-module-acme=.*,,')"; fi \
#             && apk add -X ${tempDir}/packages/alpine/ --no-cache $nginxPackages \
#             ;; \
#     esac \
# # remove checksum deps
#     && apk del --no-network .checksum-deps \
# # if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
#     && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
#     && if [ -f "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
# Bring in curl and ca-certificates to make registering on DNS SD easier
    && apk add --no-cache curl ca-certificates \
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && apk add --no-cache tzdata \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Upgrade software to latest version
# ##############################################################################
RUN apk upgrade

# smoke test
# ##############################################################################
RUN envsubst -V \
    && nginx -V \
    && nginx -t \
    && luajit -v \
    && lua -v \
    && luarocks --version

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1

# Override stop signal to stop process gracefully
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
