#               __                     __
# .-----.-----.|__|.-----.--.--.______|  |.--.--.---.-.
# |     |  _  ||  ||     |_   _|______|  ||  |  |  _  |
# |__|__|___  ||__||__|__|__.__|      |__||_____|___._|
#       |_____|
#
# Copyright (c) 2020 Fabio Cicerchia. https://fabiocicerchia.it. MIT License
# Repo: https://github.com/fabiocicerchia/nginx-lua

#############################
# Settings Common Variables #
#############################
FROM alpine:3.14.0 AS base

ARG DOCKER_IMAGE=fabiocicerchia/nginx-lua
ENV DOCKER_IMAGE=$DOCKER_IMAGE
ARG DOCKER_IMAGE_OS=alpine
ENV DOCKER_IMAGE_OS=$DOCKER_IMAGE_OS
ARG DOCKER_IMAGE_TAG=3.14.0
ENV DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG

ARG BUILD_DATE
ENV BUILD_DATE=$BUILD_DATE
ARG VCS_REF
ENV VCS_REF=$VCS_REF

ARG EXTENDED_IMAGE=1
ENV EXTENDED_IMAGE=$EXTENDED_IMAGE

# lua
ARG VER_LUA=5.4
ENV VER_LUA=$VER_LUA

# ngx_devel_kit
# https://github.com/vision5/ngx_devel_kit/releases
# The NDK is now considered to be stable.
ARG VER_NGX_DEVEL_KIT=0.3.1
ENV VER_NGX_DEVEL_KIT=$VER_NGX_DEVEL_KIT

# misc_nginx
# https://github.com/openresty/set-misc-nginx-module/releases
ARG MISC_NGINX_MODULE_VERSION=0.31
ENV MISC_NGINX_MODULE_VERSION=$MISC_NGINX_MODULE_VERSION

# luajit2
# https://github.com/openresty/luajit2/releases
ARG VER_LUAJIT=2.1-20210510
ENV VER_LUAJIT=$VER_LUAJIT
ARG LUAJIT_LIB=/usr/local/lib
ENV LUAJIT_LIB=$LUAJIT_LIB
ARG LUAJIT_INC=/usr/local/include/luajit-2.1
ENV LUAJIT_INC=$LUAJIT_INC
ARG LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# lua-nginx-module
# https://github.com/openresty/lua-nginx-module/releases
# Production ready.
ARG VER_LUA_NGINX_MODULE=0.10.20
ENV VER_LUA_NGINX_MODULE=$VER_LUA_NGINX_MODULE

# lua-resty-core
# https://github.com/openresty/lua-resty-core/releases
# This library is production ready.
ARG VER_LUA_RESTY_CORE=0.1.22
ENV VER_LUA_RESTY_CORE=$VER_LUA_RESTY_CORE
ARG LUA_LIB_DIR=/usr/local/share/lua/5.1
ENV LUA_LIB_DIR=$LUA_LIB_DIR

# lua-resty-lrucache
# https://github.com/openresty/lua-resty-lrucache/releases
# This library is considered production ready.
ARG VER_LUA_RESTY_LRUCACHE=0.11
ENV VER_LUA_RESTY_LRUCACHE=$VER_LUA_RESTY_LRUCACHE

# headers-more-nginx-module
# https://github.com/openresty/headers-more-nginx-module/commits/master
ARG VER_OPENRESTY_HEADERS=d6d7ebab3c0c5b32ab421ba186783d3e5d2c6a17
ENV VER_OPENRESTY_HEADERS=$VER_OPENRESTY_HEADERS

# lua-resty-cookie
# https://github.com/cloudflare/lua-resty-cookie/commits/master
ARG VER_CLOUDFLARE_COOKIE=303e32e512defced053a6484bc0745cf9dc0d39e
ENV VER_CLOUDFLARE_COOKIE=$VER_CLOUDFLARE_COOKIE

# lua-resty-dns
# https://github.com/openresty/lua-resty-dns/releases
ARG VER_OPENRESTY_DNS=0.22
ENV VER_OPENRESTY_DNS=$VER_OPENRESTY_DNS

# lua-resty-memcached
# https://github.com/openresty/lua-resty-memcached/releases
ARG VER_OPENRESTY_MEMCACHED=0.16
ENV VER_OPENRESTY_MEMCACHED=$VER_OPENRESTY_MEMCACHED

# lua-resty-mysql
# https://github.com/openresty/lua-resty-mysql/releases
ARG VER_OPENRESTY_MYSQL=0.24
ENV VER_OPENRESTY_MYSQL=$VER_OPENRESTY_MYSQL

# lua-resty-redis
# https://github.com/openresty/lua-resty-redis/releases
ARG VER_OPENRESTY_REDIS=0.29
ENV VER_OPENRESTY_REDIS=$VER_OPENRESTY_REDIS

# lua-resty-shell
# https://github.com/openresty/lua-resty-shell/releases
ARG VER_OPENRESTY_SHELL=0.03
ENV VER_OPENRESTY_SHELL=$VER_OPENRESTY_SHELL

# lua-resty-upstream-healthcheck
# https://github.com/openresty/lua-resty-upstream-healthcheck/releases
ARG VER_OPENRESTY_HEALTHCHECK=0.06
ENV VER_OPENRESTY_HEALTHCHECK=$VER_OPENRESTY_HEALTHCHECK

# lua-resty-websocket
# https://github.com/openresty/lua-resty-websocket/releases
ARG VER_OPENRESTY_WEBSOCKET=0.08
ENV VER_OPENRESTY_WEBSOCKET=$VER_OPENRESTY_WEBSOCKET

# lua-rocks
# https://luarocks.github.io/luarocks/releases/
ARG VER_LUAROCKS=3.7.0
ENV VER_LUAROCKS=$VER_LUAROCKS

# lua-upstream-nginx-module
# https://github.com/openresty/lua-upstream-nginx-module/releases
ARG VER_LUA_UPSTREAM=0.07
ENV VER_LUA_UPSTREAM=$VER_LUA_UPSTREAM

# nginx-lua-prometheus
# https://github.com/knyar/nginx-lua-prometheus/releases
ARG VER_PROMETHEUS=0.20210206
ENV VER_PROMETHEUS=$VER_PROMETHEUS

# stream-lua-nginx-module
# https://github.com/openresty/stream-lua-nginx-module/releases
ARG VER_OPENRESTY_STREAMLUA=0.0.10
ENV VER_OPENRESTY_STREAMLUA=$VER_OPENRESTY_STREAMLUA

# https://github.com/nginx/nginx/releases
ARG VER_NGINX=1.21.1
ENV VER_NGINX=$VER_NGINX
ARG NGX_CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC"
ENV NGX_CFLAGS=$NGX_CFLAGS
ARG NGX_LDOPT="-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie"
ENV NGX_LDOPT=$NGX_LDOPT
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
            --add-module=/lua-upstream-nginx-module-${VER_LUA_UPSTREAM} \
            --add-module=/set-misc-nginx-module-${MISC_NGINX_MODULE_VERSION} \
"
ENV NGINX_BUILD_CONFIG=$NGINX_BUILD_CONFIG

ARG BUILD_DEPS="\
        curl \
        g++ \
        geoip-dev \
        gzip \
        lua${VER_LUA} \
        lua${VER_LUA}-dev \
        make \
        openssl-dev \
        pcre-dev \
        tar \
        zlib-dev \
"
ENV BUILD_DEPS=$BUILD_DEPS

ARG NGINX_BUILD_DEPS="\
# NGINX
        alpine-sdk \
        bash \
        findutils \
        gcc \
        gd-dev \
        geoip-dev \
        libc-dev \
        libedit-dev \
        libxslt-dev \
        linux-headers \
        make \
        openssl-dev \
        pcre-dev \
        perl-dev \
        zlib-dev \
"
ENV NGINX_BUILD_DEPS=$NGINX_BUILD_DEPS

####################################
# Build Nginx with support for LUA #
####################################
FROM base AS builder

COPY tpl/Makefile Makefile

# TODO: NGINX_BUILD_CONFIG not updated
# hadolint ignore=SC2086
RUN set -eux \
    && apk update \
    && apk add --no-cache \
        $BUILD_DEPS \
        $NGINX_BUILD_DEPS \
    && [ $EXTENDED_IMAGE -eq 1 ] && \
        NGINX_BUILD_CONFIG="${NGINX_BUILD_CONFIG} \
            --add-module=/headers-more-nginx-module-${VER_OPENRESTY_HEADERS} \
            --add-module=/stream-lua-nginx-module-${VER_OPENRESTY_STREAMLUA} \
        " \
    && make -j "$(nproc)" deps \
    && make -j "$(nproc)" core \
    && make -j "$(nproc)" luarocks

##########################################
# Combine everything with minimal layers #
##########################################
FROM base

# http://label-schema.org/rc1/
LABEL maintainer="Fabio Cicerchia <info@fabiocicerchia.it>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.description="Nginx $VER_NGINX with Lua support based on $DOCKER_IMAGE_OS $DOCKER_IMAGE_TAG." \
    org.label-schema.docker.cmd="docker run -p 80:80 -d $DOCKER_IMAGE:$VER_NGINX-$DOCKER_IMAGE_OS$DOCKER_IMAGE_TAG" \
    org.label-schema.name="$DOCKER_IMAGE" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/$DOCKER_IMAGE" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/$DOCKER_IMAGE" \
    org.label-schema.version="$VER_NGINX-$DOCKER_IMAGE_OS$DOCKER_IMAGE_TAG" \
    versions.extended=${EXTENDED_IMAGE} \
    versions.headers-more-nginx-module=${VER_OPENRESTY_HEADERS} \
    versions.lua=${VER_LUA} \
    versions.luarocks=${VER_LUAROCKS} \
    versions.lua-nginx-module=${VER_LUA_NGINX_MODULE} \
    versions.lua-resty-cookie=${VER_CLOUDFLARE_COOKIE} \
    versions.lua-resty-core=${VER_LUA_RESTY_CORE} \
    versions.lua-resty-dns=${VER_OPENRESTY_DNS} \
    versions.lua-resty-lrucache=${VER_LUA_RESTY_LRUCACHE} \
    versions.lua-resty-memcached=${VER_OPENRESTY_MEMCACHED} \
    versions.lua-resty-mysql=${VER_OPENRESTY_MYSQL} \
    versions.lua-resty-redis=${VER_OPENRESTY_REDIS} \
    versions.lua-resty-shell=${VER_OPENRESTY_SHELL} \
    versions.lua-resty-upstream-healthcheck=${VER_OPENRESTY_HEALTHCHECK} \
    versions.lua-resty-websocket=${VER_OPENRESTY_WEBSOCKET} \
    versions.lua-upstream=${VER_LUA_UPSTREAM} \
    versions.luajit2=${VER_LUAJIT} \
    versions.nginx-lua-prometheus=${VER_PROMETHEUS} \
    versions.nginx=${VER_NGINX} \
    versions.ngx_devel_kit=${VER_NGX_DEVEL_KIT} \
    versions.os=${DOCKER_IMAGE_TAG} \
    versions.stream-lua-nginx-module=${VER_OPENRESTY_STREAMLUA}

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

COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/share/lua /usr/local/share/lua
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /usr/sbin/nginx-debug /usr/sbin/nginx-debug
COPY --from=builder /var/cache/nginx /var/cache/nginx
COPY --from=builder /usr/local/bin/luarocks /usr/local/bin/luarocks
COPY --from=builder /usr/local/etc/luarocks /usr/local/etc/luarocks

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
    && mkdir /docker-entrypoint.d

COPY tpl/docker-entrypoint.sh /
COPY tpl/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d/
COPY tpl/20-envsubst-on-templates.sh /docker-entrypoint.d/
COPY tpl/nginx.conf /etc/nginx/nginx.conf
COPY tpl/default.conf /etc/nginx/conf.d/default.conf

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
