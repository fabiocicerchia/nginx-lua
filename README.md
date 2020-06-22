# nginx-lua

![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.png "Docker stars")
![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.png "Docker pulls")
![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
[![](https://images.microbadger.com/badges/image/fabiocicerchia/nginx-lua.svg)](https://microbadger.com/#/images/fabiocicerchia/nginx-lua "microbadger.com")

Nginx 1.17, 1.18 and 1.19 with LUA support based on Alpine Linux, Amazon Linux, CentOS, Debian, Fedora and Ubuntu.

## Supported Tags and Respective `Dockerfile` Links

- [`1`,`1.19`,`1-alpine`,`1.19-alpine`,`1.19.0-alpine`,`1-alpine3.12.0`,`1.19.0`,`latest`,`1.19-alpine3.12.0`,`1.19.0-alpine3.12.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.12.0/Dockerfile)
- [`1-ubuntu`,`1.19-ubuntu`,`1-ubuntu20.04`,`1.19.0-ubuntu`,`1.19-ubuntu20.04`,`1.19.0-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/20.04/Dockerfile)
- [`1-fedora`,`1-fedora31`,`1.19-fedora`,`1.19-fedora31`,`1.19.0-fedora`,`1.19.0-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/31/Dockerfile)
- [`1-debian`,`1.19-debian`,`1.19.0-debian`,`1-debian10.4-slim`,`1.19-debian10.4-slim`,`1.19.0-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.4-slim/Dockerfile)
- [`1-centos`,`1.19-centos`,`1.19.0-centos`,`1-centos8.2.2004`,`1.19-centos8.2.2004`,`1.19.0-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/8.2.2004/Dockerfile)
- [`1-amazonlinux`,`1.19-amazonlinux`,`1.19.0-amazonlinux`,`1-amazonlinux2.0.20200406.0`,`1.19-amazonlinux2.0.20200406.0`,`1.19.0-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.19.0-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/19.10/Dockerfile)
- [`1.19.0-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/18.04/Dockerfile)
- [`1.19.0-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/30/Dockerfile)
- [`1.19.0-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/29/Dockerfile)
- [`1.19.0-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/9.12-slim/Dockerfile)
- [`1.19.0-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/8.11-slim/Dockerfile)
- [`1.19.0-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/7.8.2003/Dockerfile)
- [`1.19.0-centos6.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/6.10/Dockerfile)
- [`1.19.0-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.19.0-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.11.6/Dockerfile)
- [`1.19.0-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.10.5/Dockerfile)
- [`1.18.0-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/19.10/Dockerfile)
- [`1.18.0-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/18.04/Dockerfile)
- [`1.18.0-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/30/Dockerfile)
- [`1.18.0-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/29/Dockerfile)
- [`1.18.0-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/9.12-slim/Dockerfile)
- [`1.18.0-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/8.11-slim/Dockerfile)
- [`1.18.0-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/7.8.2003/Dockerfile)
- [`1.18.0-centos6.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/6.10/Dockerfile)
- [`1.18.0-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.18.0-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.11.6/Dockerfile)
- [`1.18.0-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.10.5/Dockerfile)
- [`1.18-ubuntu`,`1.18.0-ubuntu`,`1.18-ubuntu20.04`,`1.18.0-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/20.04/Dockerfile)
- [`1.18-fedora`,`1.18-fedora31`,`1.18.0-fedora`,`1.18.0-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/31/Dockerfile)
- [`1.18-debian`,`1.18.0-debian`,`1.18-debian10.4-slim`,`1.18.0-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/10.4-slim/Dockerfile)
- [`1.18-centos`,`1.18.0-centos`,`1.18-centos8.2.2004`,`1.18.0-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/8.2.2004/Dockerfile)
- [`1.18-amazonlinux`,`1.18.0-amazonlinux`,`1.18-amazonlinux2.0.20200406.0`,`1.18.0-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.18-alpine`,`1.18.0-alpine`,`1.18-alpine3.12.0`,`1.18.0-alpine3.12.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.12.0/Dockerfile)
- [`1.17.10-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/19.10/Dockerfile)
- [`1.17.10-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/18.04/Dockerfile)
- [`1.17.10-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/30/Dockerfile)
- [`1.17.10-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/29/Dockerfile)
- [`1.17.10-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/9.12-slim/Dockerfile)
- [`1.17.10-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/8.11-slim/Dockerfile)
- [`1.17.10-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/7.8.2003/Dockerfile)
- [`1.17.10-centos6.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/6.10/Dockerfile)
- [`1.17.10-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.17.10-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.11.6/Dockerfile)
- [`1.17.10-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.10.5/Dockerfile)
- [`1.17-ubuntu`,`1.17.10-ubuntu`,`1.17-ubuntu20.04`,`1.17.10-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/20.04/Dockerfile)
- [`1.17-fedora`,`1.17-fedora31`,`1.17.10-fedora`,`1.17.10-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/31/Dockerfile)
- [`1.17-debian`,`1.17.10-debian`,`1.17-debian10.4-slim`,`1.17.10-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/10.4-slim/Dockerfile)
- [`1.17-centos`,`1.17.10-centos`,`1.17-centos8.2.2004`,`1.17.10-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/8.2.2004/Dockerfile)
- [`1.17-amazonlinux`,`1.17.10-amazonlinux`,`1.17-amazonlinux2.0.20200406.0`,`1.17.10-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.17-alpine`,`1.17.10-alpine`,`1.17-alpine3.12.0`,`1.17.10-alpine3.12.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.12.0/Dockerfile)

## Specs

 - OS
   - [Alpine Linux](https://hub.docker.com/_/alpine)
   - [Amazon Linux](https://hub.docker.com/_/amazonlinux)
   - [CentOS](https://hub.docker.com/_/centos)
   - [Debian](https://hub.docker.com/_/debian)
   - [Fedora](https://hub.docker.com/_/fedora)
   - [Ubuntu](https://hub.docker.com/_/ubuntu)
 - [nginx](https://nginx.org/en/download.html)
 - [OpenResty's Branch of LuaJIT 2](https://github.com/openresty/luajit2)
 - [Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module)
 - [New FFI-based API for lua-nginx-module](https://github.com/openresty/lua-resty-core)
 - [Lua-land LRU Cache based on LuaJIT FFI](https://github.com/openresty/lua-resty-lrucache)
 - [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit)
 - Additional Modules
   - [ngx_http_addition_module](http://nginx.org/en/docs/http/ngx_http_addition_module.html)
   - [ngx_http_auth_request_module](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html)
   - [ngx_http_dav_module](http://nginx.org/en/docs/http/ngx_http_dav_module.html)
   - [ngx_http_flv_module](http://nginx.org/en/docs/http/ngx_http_flv_module.html)
   - [ngx_http_geoip_module](http://nginx.org/en/docs/http/ngx_http_geoip_module.html)
   - [ngx_http_gunzip_module](http://nginx.org/en/docs/http/ngx_http_gunzip_module.html)
   - [ngx_http_gzip_static_module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html)
   - [ngx_http_mp4_module](http://nginx.org/en/docs/http/ngx_http_mp4_module.html)
   - [ngx_http_random_index_module](http://nginx.org/en/docs/http/ngx_http_random_index_module.html)
   - [ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html)
   - [ngx_http_secure_link_module](http://nginx.org/en/docs/http/ngx_http_secure_link_module.html)
   - [ngx_http_slice_module](http://nginx.org/en/docs/http/ngx_http_slice_module.html)
   - [ngx_http_ssl_module](http://nginx.org/en/docs/http/ngx_http_ssl_module.html)
   - [ngx_http_stub_status_module](http://nginx.org/en/docs/http/ngx_http_stub_status_module.html)
   - [ngx_http_sub_module](http://nginx.org/en/docs/http/ngx_http_sub_module.html)
   - [ngx_http_v2_module](http://nginx.org/en/docs/http/ngx_http_v2_module.html)
   - [ngx_mail_ssl_module](http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html)
   - [ngx_stream_realip_module](http://nginx.org/en/docs/stream/ngx_stream_realip_module.html)
   - [ngx_stream_ssl_module](http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html)
   - [ngx_stream_ssl_preread_module](http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html)

### Compiled Version Details

```
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' --add-module=/lua-nginx-module-0.10.15 --add-module=/ngx_devel_kit-0.3.1 --with-http_dav_module --with-http_geoip_module
```

## Run Container

```sh
docker run -it --rm -p 80:80 \
  --health-cmd='curl --fail http://example.com || exit 1' \
  --health-interval=30s \
  --health-timeout=3s \
  fabiocicerchia/nginx-lua:latest
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
