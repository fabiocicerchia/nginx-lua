#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2022 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

ARG ARCH=
ARG DISTRO=alpine
ARG DISTRO_VER=3.16.0

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

# lua
ARG VER_LUA=5.4
ENV VER_LUA=$VER_LUA

# ngx_devel_kit
# https://github.com/vision5/ngx_devel_kit/releases
# The NDK is now considered to be stable.
ARG VER_NGX_DEVEL_KIT=0.3.1
ENV VER_NGX_DEVEL_KIT=$VER_NGX_DEVEL_KIT

# luajit2
# https://github.com/openresty/luajit2/tags
# Note: LuaJIT2 is stuck on Lua 5.1 since 2009.
ARG VER_LUAJIT=2.1-20220310
ENV VER_LUAJIT=$VER_LUAJIT
ARG LUAJIT_LIB=/usr/local/lib
ENV LUAJIT_LIB=$LUAJIT_LIB
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ENV LUAJIT_INC=$LUAJIT_INC
ARG LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# lua-nginx-module
# https://github.com/openresty/lua-nginx-module/tags
# Production ready.
ARG VER_LUA_NGINX_MODULE=0.10.20
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core/tags
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.22
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.4
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# lua-resty-lrucache
# https://github.com/openresty/lua-resty-lrucache/tags
# This library is considered production ready.
ARG VER_LUA_RESTY_LRUCACHE=0.11
ENV VER_LUA_RESTY_LRUCACHE=$VER_LUA_RESTY_LRUCACHE

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module/commits/master
ARG VER_OPENRESTY_HEADERS=a4a0686605161a6777d7d612d5aef79b9e7c13e0
ENV VER_OPENRESTY_HEADERS=$VER_OPENRESTY_HEADERS

# lua-resty-cookie
# https://github.com/cloudflare/lua-resty-cookie/commits/master
ARG VER_CLOUDFLARE_COOKIE=99be1005e38ce19ace54515272a2be1b9fdc5da2
ENV VER_CLOUDFLARE_COOKIE=$VER_CLOUDFLARE_COOKIE

# lua-resty-dns
# https://github.com/openresty/lua-resty-dns/tags
ARG VER_OPENRESTY_DNS=0.22
ENV VER_OPENRESTY_DNS=$VER_OPENRESTY_DNS

# lua-resty-memcached
# https://github.com/openresty/lua-resty-memcached/tags
ARG VER_OPENRESTY_MEMCACHED=0.16
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql/tags
ARG VER_OPENRESTY_MYSQL=0.24
ENV VER_OPENRESTY_MYSQL=$VER_OPENRESTY_MYSQL

# lua-resty-redis
# https://github.com/openresty/lua-resty-redis/releases
ARG VER_OPENRESTY_REDIS=0.29
ENV VER_OPENRESTY_REDIS=$VER_OPENRESTY_REDIS

# lua-resty-shell
# https://github.com/openresty/lua-resty-shell/tags
ARG VER_OPENRESTY_SHELL=0.03
ENV VER_OPENRESTY_SHELL=$VER_OPENRESTY_SHELL

# lua-resty-signal
# https://github.com/openresty/lua-resty-signal/tags
ARG VER_OPENRESTY_SIGNAL=0.03
ENV VER_OPENRESTY_SIGNAL=$VER_OPENRESTY_SIGNAL

# lua-tablepool
# https://github.com/openresty/lua-tablepool/tags
ARG VER_OPENRESTY_TABLEPOOL=0.02
ENV VER_OPENRESTY_TABLEPOOL=$VER_OPENRESTY_TABLEPOOL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck/tags
ARG VER_OPENRESTY_HEALTHCHECK=0.06
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket/tags
ARG VER_OPENRESTY_WEBSOCKET=0.08
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-rocks
# https://luarocks.github.io/luarocks/releases/
ARG VER_LUAROCKS=3.8.0
ENV VER_LUAROCKS=$VER_LUAROCKS

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module/tags
ARG VER_LUA_UPSTREAM=0.07
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus/tags
ARG VER_PROMETHEUS=0.20220127
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module/tags
ARG VER_OPENRESTY_STREAMLUA=0.0.10
ENV VER_OPENRESTY_STREAMLUA=$VER_OPENRESTY_STREAMLUA

# https://github.com/nginx/nginx/releases
ARG VER_NGINX=1.21.6
ENV VER_NGINX=$VER_NGINX
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
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
            --user=nginx \
            --group=nginx \
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
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
            --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
            --add-module=/lua-upstream-nginx-module-${VER_LUA_UPSTREAM} \
            --add-module=/headers-more-nginx-module-${VER_OPENRESTY_HEADERS} \
            --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
"
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS_BASE="\
        curl \
        geoip-dev \
        gzip \
        lua${VER_LUA} \
        lua${VER_LUA}-dev \
        make \
        openssl-dev \
        patch \
        pcre-dev \
        tar \
        zlib-dev \
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
        gd-dev \
        libedit-dev \
        libxslt-dev \
        linux-headers \
        perl-dev \
"
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

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
    org.label-schema.description="Nginx ${VER_NGINX} with Lua support based on ${DOCKER_IMAGE_OS} ${DOCKER_IMAGE_TAG}." \
    org.label-schema.docker.cmd="docker run -p 80:80 -d ${DOCKER_IMAGE}:${VER_NGINX}-${DOCKER_IMAGE_OS}${DOCKER_IMAGE_TAG}" \
    org.label-schema.name="${DOCKER_IMAGE}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/${DOCKER_IMAGE}" \
    org.label-schema.version="${VER_NGINX}-${DOCKER_IMAGE_OS}${DOCKER_IMAGE_TAG}" \
    image.target.platform="${TARGETPLATFORM}" \
    image.target.os="${TARGETOS}" \
    image.target.arch="${ARCH}" \
    versions.headers-more-nginx-module="${VER_OPENRESTY_HEADERS}" \
    versions.lua="${VER_LUA}" \
    versions.luarocks="${VER_LUAROCKS}" \
    versions.lua-nginx-module="${VER_LUA_NGINX_MODULE}" \
    versions.lua-resty-cookie="${VER_CLOUDFLARE_COOKIE}" \
    versions.lua-resty-core="${VER_LUA_RESTY_CORE}" \
    versions.lua-resty-dns="${VER_OPENRESTY_DNS}" \
    versions.lua-resty-lrucache="${VER_LUA_RESTY_LRUCACHE}" \
    versions.lua-resty-memcached="${VER_OPENRESTY_MEMCACHED}" \
    versions.lua-resty-mysql="${VER_OPENRESTY_MYSQL}" \
    versions.lua-resty-redis="${VER_OPENRESTY_REDIS}" \
    versions.lua-resty-shell="${VER_OPENRESTY_SHELL}" \
    versions.lua-resty-signal="${VER_OPENRESTY_SIGNAL}" \
    versions.lua-resty-tablepool="${VER_OPENRESTY_TABLEPOOL}" \
    versions.lua-resty-upstream-healthcheck="${VER_OPENRESTY_HEALTHCHECK}" \
    versions.lua-resty-websocket="${VER_OPENRESTY_WEBSOCKET}" \
    versions.lua-upstream="${VER_LUA_UPSTREAM}" \
    versions.luajit2="${VER_LUAJIT}" \
    versions.nginx-lua-prometheus="${VER_PROMETHEUS}" \
    versions.nginx="${VER_NGINX}" \
    versions.ngx_devel_kit="${VER_NGX_DEVEL_KIT}" \
    versions.os="${DOCKER_IMAGE_TAG}" \
    versions.stream-lua-nginx-module="${VER_OPENRESTY_STREAMLUA}"

ARG PKG_DEPS="\
        geoip-dev \
        lua${VER_LUA} \
        lua${VER_LUA}-dev \
        openssl-dev \
        pcre-dev \
        unzip \
        zlib-dev \
"
ENV PKG_DEPS=$PKG_DEPS

COPY --from=builder --chown=101:101 /etc/nginx /etc/nginx
COPY --from=builder --chown=101:101 /usr/local/lib /usr/local/lib
COPY --from=builder --chown=101:101 /usr/local/share/lua /usr/local/share/lua
COPY --from=builder --chown=101:101 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder --chown=101:101 /usr/sbin/nginx-debug /usr/sbin/nginx-debug
COPY --from=builder --chown=101:101 /var/cache/nginx /var/cache/nginx
COPY --from=builder --chown=101:101 /usr/local/bin/luarocks /usr/local/bin/luarocks
COPY --from=builder --chown=101:101 /usr/local/etc/luarocks /usr/local/etc/luarocks

COPY --chown=101:101 tpl/support.sh /
COPY --chown=101:101 tpl/docker-entrypoint.sh /
COPY --chown=101:101 tpl/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d/
COPY --chown=101:101 tpl/20-envsubst-on-templates.sh /docker-entrypoint.d/
COPY --chown=101:101 tpl/nginx.conf /etc/nginx/nginx.conf
COPY --chown=101:101 tpl/default.conf /etc/nginx/conf.d/default.conf

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=SC2086
RUN set -eux \
    && apk update \
    && apk add --no-cache --virtual .pkg_deps \
        $PKG_DEPS \
# Fix LUA alias
    && ln -sf /usr/bin/lua${VER_LUA} /usr/local/bin/lua \
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .run_deps $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && apk add --no-cache --virtual pkg_tz tzdata \
# Bring in curl and ca-certificates to make registering on DNS SD easier
    && apk add --no-cache --virtual pkg_dns curl ca-certificates \
# forward request and error logs to docker log collector
    && mkdir -p /var/log/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
# Upgrade software to latest version
# ##############################################################################
    && apk upgrade

# smoke test
# ##############################################################################
RUN envsubst -V \
    && nginx -V \
    && nginx -t \
    && lua -v \
    && luarocks --version

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=3s CMD curl --fail http://localhost/ || exit 1

# Override stop signal to stop process gracefully
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
