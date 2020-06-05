FROM nginx:1.19.0-alpine

MAINTAINER Fabio Cicerchia <info@fabiocicerchia.it>
LABEL maintainer="info@fabiocicerchia.it"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="fabiocicerchia/nginx-lua"
LABEL org.label-schema.description="Nginx 1.19+ with LUA support based on Alpine Linux."
LABEL org.label-schema.url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-url="https://github.com/fabiocicerchia/nginx-lua"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -p 80:80 -d fabiocicerchia/nginx-lua"

# https://github.com/openresty/luajit2
ENV VER_LUAJIT 2.1-20200102

# https://github.com/openresty/lua-nginx-module
# Production ready.
ENV VER_LUA_NGINX_MODULE 0.10.15

# https://github.com/openresty/lua-resty-core
# This library is production ready.
ENV VER_LUA_RESTY_CORE 0.1.17

# https://github.com/openresty/lua-resty-lrucache
# This library is considered production ready.
ENV VER_LUA_RESTY_LRUCACHE 0.09

# https://nginx.org/en/download.html
ENV VER_NGINX 1.19.0

# https://github.com/vision5/ngx_devel_kit
# The NDK is now considered to be stable.
ENV VER_NGX_DEVEL_KIT 0.3.1

ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.1

RUN apk update \
    && apk add --no-cache --virtual .build-deps g++ make zlib-dev pcre-dev openssl-dev geoip-dev \
    && wget https://github.com/openresty/luajit2/archive/v${VER_LUAJIT}.tar.gz -O /luajit.tar.gz \
       && tar xvzf /luajit.tar.gz && rm /luajit.tar.gz \
       && cd /luajit2-${VER_LUAJIT} \
       && make -j $(nproc) \
       && make install \
       && cd / \
    && wget https://github.com/openresty/lua-resty-core/archive/v${VER_LUA_RESTY_CORE}.tar.gz -O /lua-resty-core.tar.gz \
       && tar xvzf /lua-resty-core.tar.gz && rm /lua-resty-core.tar.gz \
       && cd /lua-resty-core-${VER_LUA_RESTY_CORE} \
       && make -j $(nproc) \
       && make install \
       && cd / \
    && wget https://github.com/openresty/lua-resty-lrucache/archive/v${VER_LUA_RESTY_LRUCACHE}.tar.gz -O /lua-resty-lrucache.tar.gz \
       && tar xvzf /lua-resty-lrucache.tar.gz && rm /lua-resty-lrucache.tar.gz \
       && cd /lua-resty-lrucache-${VER_LUA_RESTY_LRUCACHE} \
       && make -j $(nproc) \
       && make install \
       && cd / \
    && wget https://github.com/vision5/ngx_devel_kit/archive/v${VER_NGX_DEVEL_KIT}.tar.gz -O /ngx_devel_kit.tar.gz \
       && tar xvzf /ngx_devel_kit.tar.gz && rm /ngx_devel_kit.tar.gz \
    && wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O /lua-nginx.tar.gz \
       && tar xvzf /lua-nginx.tar.gz && rm /lua-nginx.tar.gz \
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
    && rm -rf /lua-nginx-module-${VER_LUA_NGINX_MODULE} \
    && rm -rf /lua-resty-core-${VER_LUA_RESTY_CORE} \
    && rm -rf /luajit2-${VER_LUAJIT} \
    && rm -rf /nginx-${VER_NGINX} \
    && rm -rf /ngx_devel_kit-${VER_NGX_DEVEL_KIT} \
    && apk del .build-deps

EXPOSE 443
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
