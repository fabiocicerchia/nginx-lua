# nginx-lua

![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.png "Docker stars")
![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.png "Docker pulls")
![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
[![](https://images.microbadger.com/badges/image/fabiocicerchia/nginx-lua.svg)](https://microbadger.com/#/images/fabiocicerchia/nginx-lua "microbadger.com")

Nginx 1.19+ with LUA support based on Alpine Linux.

## Supported Tags and Respective Dockerfile Links

 - [`1.19.0`, `1`, `1.19`, `latest`](https://github.com/fabiocicerchia/nginx-lua/blob/master/Dockerfile)

## Specs

 - [Alpine Linux](https://hub.docker.com/_/alpine) `v3.12.0`
 - Official [nginx](https://nginx.org/en/download.html) `v1.19.0`
 - [OpenResty's Branch of LuaJIT 2](https://github.com/openresty/luajit2) `v2.1-20200102`
 - [Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module) `v0.10.15`
 - [New FFI-based API for lua-nginx-module](https://github.com/openresty/lua-resty-core) `v0.1.17`
 - [Lua-land LRU Cache based on LuaJIT FFI](https://github.com/openresty/lua-resty-lrucache) `v0.09`
 - [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit) `v0.3.1`
 - Additional Modules
   - [ngx_http_addition_module](http://nginx.org/en/docs/http/ngx_http_addition_module.html)
   - [ngx_http_auth_request_module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html)
   - [ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html)
   - [ngx_http_geoip_module](http://nginx.org/en/docs/http/ngx_http_geoip_module.html)
   - [ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)
   - [ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html)
   - [ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html)
   - [ngx_http_stub_status_module](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html)
   - [ngx_http_sub_module](http://nginx.org/en/docs/http/ngx_http_sub_module.html)

### Build Flags

```
configure arguments: --add-module=/lua-nginx-module-0.10.15 --add-module=/ngx_devel_kit-0.3.1 --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-ipv6 --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' --with-pcre-jit
```

## Run Container

```sh
docker run -it --rm -p 80:80 fabiocicerchia/nginx-lua
```

## Example

```
server {
  server_name localhost;

  location /lua_content {
    default_type 'text/plain';

    content_by_lua_block {
      ngx.say('Hello world!')
    }
  }
}
```
