FROM debian:8.11-slim

MAINTAINER Fabio Cicerchia <info@fabiocicerchia.it>
LABEL maintainer="info@fabiocicerchia.it"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="fabiocicerchia/nginx-lua"
LABEL org.label-schema.description="Nginx 1.17.10 with LUA support based on Debian."
LABEL org.label-schema.url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.17.10-debian8.11-slim"

# https://github.com/openresty/luajit2
ENV VER_LUAJIT 2.1-20200102

# https://github.com/openresty/lua-nginx-module
# Production ready.
ENV VER_LUA_NGINX_MODULE 0.10.15

# https://github.com/openresty/lua-resty-core
# This library is production ready.
ENV VER_LUA_RESTY_CORE 0.1.17
ENV LUA_LIB_DIR /usr/local/share/lua/5.1

# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ENV VER_LUA_RESTY_LRUCACHE 0.09

# https://nginx.org/en/download.html
ENV VER_NGINX 1.17.10

# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ENV VER_NGX_DEVEL_KIT 0.3.1

ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.1
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
   && apt-get update \
   && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates \
      libgeoip-dev \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
   && apt-get install -y --no-install-recommends --no-install-suggests \
      g++ \
      make \
      wget \
# OpenResty LUAJIT2
# ##############################################################################
   && wget https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz -O /luajit.tar.gz \
      && tar xvzf /luajit.tar.gz && rm /luajit.tar.gz \
      && cd /luajit2-${VER_LUAJIT} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# LUA Resty Core
# ##############################################################################
   && wget https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz -O /lua-resty-core.tar.gz \
      && tar xvzf /lua-resty-core.tar.gz && rm /lua-resty-core.tar.gz \
      && cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# LUA Resty LRUCache
# ##############################################################################
   && wget https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz -O /lua-resty-lrucache.tar.gz \
      && tar xvzf /lua-resty-lrucache.tar.gz && rm /lua-resty-lrucache.tar.gz \
      && cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
      && make -j $(nproc) \
      && make install \
      && cd / \
# NGX Devel Kit
# ##############################################################################
   && wget https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz -O /ngx_devel_kit.tar.gz \
      && tar xvzf /ngx_devel_kit.tar.gz && rm /ngx_devel_kit.tar.gz \
# Lua Nginx Module
# ##############################################################################
   && wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O /lua-nginx.tar.gz \
      && tar xvzf /lua-nginx.tar.gz && rm /lua-nginx.tar.gz \
# NGINX
# ##############################################################################
# create nginx user/group first, to be consistent throughout docker variants
   && addgroup --system --gid 101 nginx \
   && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from the published packaging sources
      && wget https://nginx.org/download/nginx-${VER_NGINX}.tar.gz -O /nginx.tar.gz \
      && tar xvzf /nginx.tar.gz && rm /nginx.tar.gz \
      && cd /nginx-${VER_NGINX} \
      && ./configure \
         --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} \
         --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
         --conf-path=/etc/nginx/nginx.conf \
         --error-log-path=/var/log/nginx/error.log \
         --http-log-path=/var/log/nginx/access.log \
         --lock-path=/var/lock/nginx.lock \
         --pid-path=/run/nginx.pid \
         --prefix=/usr/share/nginx \
         --sbin-path=/usr/sbin/nginx \
         --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
         --with-http_addition_module \
         --with-http_auth_request_module \
         --with-http_dav_module \
         --with-http_geoip_module \
         --with-http_gzip_static_module \
         --with-http_realip_module \
         --with-http_ssl_module \
         --with-http_stub_status_module \
         --with-http_sub_module \
         --with-ipv6 \
         --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
         --with-pcre-jit \
      && make -j $(nproc) build \
      && make install \
# Bring in tzdata so users could set the timezones through the environment
# variables
   && apt-get install -y --no-install-recommends --no-install-suggests tzdata \
# Bring in curl and ca-certificates to make registering on DNS SD easier
   && apt-get install -y --no-install-recommends --no-install-suggests curl ca-certificates \
# forward request and error logs to docker log collector
   && ln -sf /dev/stdout /var/log/nginx/access.log \
   && ln -sf /dev/stderr /var/log/nginx/error.log \
# Cleanup
# ##############################################################################
   && rm -rf /lua-nginx-module-${VER_LUA_NGINX_MODULE} \
   && rm -rf /lua-resty-core-${VER_LUA_RESTY_CORE} \
   && rm -rf /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
   && rm -rf /luajit2-${VER_LUAJIT} \
   && rm -rf /nginx-${VER_NGINX} \
   && rm -rf /ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
   && apt-get remove -y \
      g++ \
      gcc \
      libc-dev \
      libedit-dev \
      libxslt-dev \
      linux-headers \
      make \
      mercurial \
      wget \
   && rm -rf /var/lib/apt/lists/*

EXPOSE 80
EXPOSE 443

COPY nginx.conf /etc/nginx/nginx.conf

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
