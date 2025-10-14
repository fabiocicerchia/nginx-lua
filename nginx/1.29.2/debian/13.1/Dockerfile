#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2025 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

ARG ARCH=
ARG DISTRO=debian
ARG DISTRO_VER=13.1

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
ARG VER_NGINX=1.29.2
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
ARG VER_NJS=0.9.3
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
ARG VER_LUAJIT=2.1-20250826
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
ARG VER_LUA_NGINX_MODULE=0.10.28
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.31
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.1
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# LUAROCKS
################################################################################

# lua-rocks
# https://luarocks.github.io/luarocks/releases/
ARG VER_LUAROCKS=3.12.2
ENV VER_LUAROCKS=$VER_LUAROCKS

# LUA ADDONS
################################################################################

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module
ARG VER_OPENRESTY_HEADERS=0.39
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
ARG VER_OPENRESTY_MEMCACHED=0.17
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql
ARG VER_OPENRESTY_MYSQL=0.28
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
ARG VER_OPENRESTY_SIGNAL=0.04
ENV VER_OPENRESTY_SIGNAL=$VER_OPENRESTY_SIGNAL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck
ARG VER_OPENRESTY_HEALTHCHECK=0.08
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket
ARG VER_OPENRESTY_WEBSOCKET=0.13
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-tablepool
# https://github.com/openresty/lua-tablepool
ARG VER_OPENRESTY_TABLEPOOL=0.03
ENV VER_OPENRESTY_TABLEPOOL=$VER_OPENRESTY_TABLEPOOL

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module
ARG VER_LUA_UPSTREAM=0.07
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus
ARG VER_PROMETHEUS=0.20240525
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# set-misc-nginx-module
# https://github.com/openresty/set-misc-nginx-module
ARG VER_MISC_NGINX=0.33
ENV VER_MISC_NGINX=$VER_MISC_NGINX

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module
ARG VER_OPENRESTY_STREAMLUA=63f4e2dac3eb4f00f2a03ae67b79739072a03fc1
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
ARG VER_OPENRESTY_STRING=0.16
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
            --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
"
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS_BASE="\
        ca-certificates \
        curl \
        g++ \
        libmaxminddb-dev \
        libpcre2-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        make \
        patch \
        unzip \
        zlib1g-dev \
"
ENV BUILD_DEPS_BASE=$BUILD_DEPS_BASE
ARG BUILD_DEPS_AMD64="\
        ${BUILD_DEPS_BASE} \
"
ENV BUILD_DEPS_AMD64=$BUILD_DEPS_AMD64
ARG BUILD_DEPS_ARM64V8="\
        ${BUILD_DEPS_BASE} \
"
ENV BUILD_DEPS_ARM64V8=$BUILD_DEPS_ARM64V8
ENV BUILD_DEPS=

ARG NGINX_BUILD_DEPS="\
# OPENRESTY PATCHES
        git \
"
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

ENV DEBIAN_FRONTEND noninteractive

####################################
# Build Nginx with support for LUA #
####################################
FROM base AS builder

# hadolint ignore=SC2086
RUN set -eux \
    && eval BUILD_DEPS="\$$(echo BUILD_DEPS_${ARCH} | tr '[:lower:]' '[:upper:]')" \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        apt-utils \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        $BUILD_DEPS \
        $NGINX_BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

COPY tpl/Makefile Makefile
COPY tpl/patches patches

RUN make deps \
    && make core \
    && make luarocks

##########################################
# Combine everything with minimal layers #
##########################################
FROM base

# http://label-schema.org/rc1/
LABEL maintainer="Fabio Cicerchia <info@fabiocicerchia.it>" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Nginx ${VER_NGINX} with Lua support based on debian (${ARCH}) 13.1." \
    org.label-schema.docker.cmd="docker run -p 80:80 -d ${DOCKER_IMAGE}:${VER_NGINX}-debian13.1" \
    org.label-schema.name="${DOCKER_IMAGE}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.version="${VER_NGINX}-debian13.1" \
    image.target.platform="${TARGETPLATFORM}" \
    image.target.os="${TARGETOS}" \
    image.target.arch="${ARCH}" \
    versions.os="13.1" \
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
    versions.stream-lua-nginx-module="${VER_OPENRESTY_STREAMLUA}"

ARG PKG_DEPS="\
        ca-certificates \
        libmaxminddb-dev \
        libpcre2-dev \
        libssl-dev \
        libxml2-dev \
        unzip \
        zlib1g-dev \
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

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=SC2086
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        $PKG_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/nginx \
# Fix LUA alias
    && ln -sf /usr/local/bin/luajit /usr/local/bin/lua

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && groupadd --system --gid 101 nginx \
    && useradd --system --gid nginx --no-create-home --home /nonexistent --comment "nginx user" --shell /bin/false --uid 101 nginx \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates \
# COMMENTED OUT FROM ORIGINAL DOCKERFILE: https://github.com/nginxinc/docker-nginx/blob/1.23.2/mainline/debian/Dockerfile
# REASON: No need to use the existing distributed package as the binary is recompiled.
#     && \
#     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
#     NGINX_GPGKEY_PATH=/usr/share/keyrings/nginx-archive-keyring.gpg; \
#     export GNUPGHOME="$(mktemp -d)"; \
#     found=''; \
#     for server in \
#         hkp://keyserver.ubuntu.com:80 \
#         pgp.mit.edu \
#     ; do \
#         echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
#         gpg1 --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
#     done; \
#     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
#     gpg1 --export "$NGINX_GPGKEY" > "$NGINX_GPGKEY_PATH" ; \
#     rm -rf "$GNUPGHOME"; \
#     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/* \
#     && dpkgArch="$(dpkg --print-architecture)" \
#     && nginxPackages=" \
#         nginx=${NGINX_VERSION}-${PKG_RELEASE} \
#         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
#         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
#         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
#         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE} \
#     " \
#     && case "$dpkgArch" in \
#         amd64|arm64) \
# # arches officialy built by upstream
#             echo "deb [signed-by=$NGINX_GPGKEY_PATH] https://nginx.org/packages/mainline/debian/ bullseye nginx" >> /etc/apt/sources.list.d/nginx.list \
#             && apt-get update \
#             ;; \
#         *) \
# # we're on an architecture upstream doesn't officially build for
# # let's build binaries from the published source packages
#             echo "deb-src [signed-by=$NGINX_GPGKEY_PATH] https://nginx.org/packages/mainline/debian/ bullseye nginx" >> /etc/apt/sources.list.d/nginx.list \
#             \
# # new directory for storing sources and .deb files
#             && tempDir="$(mktemp -d)" \
#             && chmod 777 "$tempDir" \
# # (777 to ensure APT's "_apt" user can access it too)
#             \
# # save list of currently-installed packages so build dependencies can be cleanly removed later
#             && savedAptMark="$(apt-mark showmanual)" \
#             \
# # build .deb files from upstream's source packages (which are verified by apt-get)
#             && apt-get update \
#             && apt-get build-dep -y $nginxPackages \
#             && ( \
#                 cd "$tempDir" \
#                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)" \
#                     apt-get source --compile $nginxPackages \
#             ) \
# # we don't remove APT lists here because they get re-downloaded and removed later
#             \
# # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
# # (which is done after we install the built packages so we don't have to redownload any overlapping dependencies)
#             && apt-mark showmanual | xargs apt-mark auto > /dev/null \
#             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; } \
#             \
# # create a temporary local APT repo to install from (so that dependency resolution can be handled by APT, as it should be)
#             && ls -lAFh "$tempDir" \
#             && ( cd "$tempDir" && dpkg-scanpackages . > Packages ) \
#             && grep '^Package: ' "$tempDir/Packages" \
#             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list \
# # work around the following APT issue by using "Acquire::GzipIndexes=false" (overriding "/etc/apt/apt.conf.d/docker-gzip-indexes")
# #   Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
# #   ...
# #   E: Failed to fetch store:/var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages  Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
#             && apt-get -o Acquire::GzipIndexes=false update \
#             ;; \
#     esac \
#     \
    && apt-get install --no-install-recommends --no-install-suggests -y \
#                         $nginxPackages \
                        gettext-base \
                        curl \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
    \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
#    && if [ -n "$tempDir" ]; then \
#        apt-get purge -y --auto-remove \
#        && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
#    fi \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Upgrade software to latest version
# ##############################################################################
RUN apt-get upgrade -y \
# Cleanup
# ##############################################################################
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

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
