# Nginx & LUA

![nginx logo](docs/logo-nginx.png)
![lua logo](docs/logo-lua.png)

---

![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.svg "Docker pulls")
![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.svg "Docker stars")
![Known Vulnerabilities](https://img.shields.io/badge/vulnerabilities-snyk-4b45a9)


Nginx 1.17, 1.18 and 1.19 with LUA support based on Alpine Linux, Amazon Linux, CentOS, Debian, Fedora and Ubuntu.

## Quick reference

 - **Maintained by**: [Fabio Cicerchia](https://github.com/fabiocicerchia)
 - **Where to get help**: [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

## Supported tags and respective `Dockerfile` links

- [`1`,`1.19`,`1.19.0`,`1-alpine`,`1.19-alpine`,`1.19.0-alpine`,`1-alpine3.12.0`,`1.19-alpine3.12.0`,`1.19.0-alpine3.12.0`,`latest`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.12.0/Dockerfile)
- [`1-ubuntu`,`1.19-ubuntu`,`1-ubuntu20.10`,`1.19.0-ubuntu`,`1.19-ubuntu20.10`,`1.19.0-ubuntu20.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/20.10/Dockerfile)
- [`1-fedora`,`1-fedora33`,`1.19-fedora`,`1.19-fedora33`,`1.19.0-fedora`,`1.19.0-fedora33`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/33/Dockerfile)
- [`1-debian`,`1.19-debian`,`1.19.0-debian`,`1-debian10.4-slim`,`1.19-debian10.4-slim`,`1.19.0-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.4-slim/Dockerfile)
- [`1-centos`,`1.19-centos`,`1.19.0-centos`,`1-centos8.2.2004`,`1.19-centos8.2.2004`,`1.19.0-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/8.2.2004/Dockerfile)
- [`1-amazonlinux`,`1.19-amazonlinux`,`1.19.0-amazonlinux`,`1-amazonlinux2.0.20180622.1`,`1.19-amazonlinux2.0.20180622.1`,`1.19.0-amazonlinux2.0.20180622.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20180622.1/Dockerfile)

<details><summary>More tags available</summary>

- [`1.19-ubuntu20.04`,`1.19.0-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/20.04/Dockerfile)
- [`1.19-ubuntu19.10`,`1.19.0-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/19.10/Dockerfile)
- [`1.19-ubuntu18.04`,`1.19.0-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/18.04/Dockerfile)
- [`1.19-fedora32`,`1.19.0-fedora32`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/32/Dockerfile)
- [`1.19-fedora31`,`1.19.0-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/31/Dockerfile)
- [`1.19-fedora30`,`1.19.0-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/30/Dockerfile)
- [`1.19-fedora29`,`1.19.0-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/29/Dockerfile)
- [`1.19-debian9.12-slim`,`1.19.0-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/9.12-slim/Dockerfile)
- [`1.19-debian8.11-slim`,`1.19.0-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/8.11-slim/Dockerfile)
- [`1.19-debian10.3-slim`,`1.19.0-debian10.3-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.3-slim/Dockerfile)
- [`1.19-debian10.2-slim`,`1.19.0-debian10.2-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.2-slim/Dockerfile)
- [`1.19-centos8.1.1911`,`1.19.0-centos8.1.1911`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/8.1.1911/Dockerfile)
- [`1.19-centos7.8.2003`,`1.19.0-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/7.8.2003/Dockerfile)
- [`1.19-amazonlinux2018.03.0.20200318.1`,`1.19.0-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.19-amazonlinux2.0.20200406.0`,`1.19.0-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.19-amazonlinux2.0.20181010`,`1.19.0-amazonlinux2.0.20181010`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20181010/Dockerfile)
- [`1.19-amazonlinux2.0.20180827`,`1.19.0-amazonlinux2.0.20180827`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20180827/Dockerfile)
- [`1.19-alpine3.11.6`,`1.19.0-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.11.6/Dockerfile)
- [`1.19-alpine3.11.5`,`1.19.0-alpine3.11.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.11.5/Dockerfile)
- [`1.19-alpine3.10.5`,`1.19.0-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.10.5/Dockerfile)
- [`1.18-ubuntu`,`1.18.0-ubuntu`,`1.18-ubuntu20.10`,`1.18.0-ubuntu20.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/20.10/Dockerfile)
- [`1.18-ubuntu20.04`,`1.18.0-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/20.04/Dockerfile)
- [`1.18-ubuntu19.10`,`1.18.0-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/19.10/Dockerfile)
- [`1.18-ubuntu18.04`,`1.18.0-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/ubuntu/18.04/Dockerfile)
- [`1.18-fedora`,`1.18-fedora33`,`1.18.0-fedora`,`1.18.0-fedora33`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/33/Dockerfile)
- [`1.18-fedora32`,`1.18.0-fedora32`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/32/Dockerfile)
- [`1.18-fedora31`,`1.18.0-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/31/Dockerfile)
- [`1.18-fedora30`,`1.18.0-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/30/Dockerfile)
- [`1.18-fedora29`,`1.18.0-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/fedora/29/Dockerfile)
- [`1.18-debian`,`1.18.0-debian`,`1.18-debian10.4-slim`,`1.18.0-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/10.4-slim/Dockerfile)
- [`1.18-debian9.12-slim`,`1.18.0-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/9.12-slim/Dockerfile)
- [`1.18-debian8.11-slim`,`1.18.0-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/8.11-slim/Dockerfile)
- [`1.18-debian10.3-slim`,`1.18.0-debian10.3-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/10.3-slim/Dockerfile)
- [`1.18-debian10.2-slim`,`1.18.0-debian10.2-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/debian/10.2-slim/Dockerfile)
- [`1.18-centos`,`1.18.0-centos`,`1.18-centos8.2.2004`,`1.18.0-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/8.2.2004/Dockerfile)
- [`1.18-centos8.1.1911`,`1.18.0-centos8.1.1911`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/8.1.1911/Dockerfile)
- [`1.18-centos7.8.2003`,`1.18.0-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/centos/7.8.2003/Dockerfile)
- [`1.18-amazonlinux`,`1.18.0-amazonlinux`,`1.18-amazonlinux2.0.20180622.1`,`1.18.0-amazonlinux2.0.20180622.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2.0.20180622.1/Dockerfile)
- [`1.18-amazonlinux2018.03.0.20200318.1`,`1.18.0-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.18-amazonlinux2.0.20200406.0`,`1.18.0-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.18-amazonlinux2.0.20181010`,`1.18.0-amazonlinux2.0.20181010`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2.0.20181010/Dockerfile)
- [`1.18-amazonlinux2.0.20180827`,`1.18.0-amazonlinux2.0.20180827`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/amazonlinux/2.0.20180827/Dockerfile)
- [`1.18-alpine`,`1.18.0-alpine`,`1.18-alpine3.12.0`,`1.18.0-alpine3.12.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.12.0/Dockerfile)
- [`1.18-alpine3.11.6`,`1.18.0-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.11.6/Dockerfile)
- [`1.18-alpine3.11.5`,`1.18.0-alpine3.11.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.11.5/Dockerfile)
- [`1.18-alpine3.10.5`,`1.18.0-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.18.0/alpine/3.10.5/Dockerfile)
- [`1.17-ubuntu`,`1.17.10-ubuntu`,`1.17-ubuntu20.10`,`1.17.10-ubuntu20.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/20.10/Dockerfile)
- [`1.17-ubuntu20.04`,`1.17.10-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/20.04/Dockerfile)
- [`1.17-ubuntu19.10`,`1.17.10-ubuntu19.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/19.10/Dockerfile)
- [`1.17-ubuntu18.04`,`1.17.10-ubuntu18.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/ubuntu/18.04/Dockerfile)
- [`1.17-fedora`,`1.17-fedora33`,`1.17.10-fedora`,`1.17.10-fedora33`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/33/Dockerfile)
- [`1.17-fedora32`,`1.17.10-fedora32`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/32/Dockerfile)
- [`1.17-fedora31`,`1.17.10-fedora31`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/31/Dockerfile)
- [`1.17-fedora30`,`1.17.10-fedora30`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/30/Dockerfile)
- [`1.17-fedora29`,`1.17.10-fedora29`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/fedora/29/Dockerfile)
- [`1.17-debian`,`1.17.10-debian`,`1.17-debian10.4-slim`,`1.17.10-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/10.4-slim/Dockerfile)
- [`1.17-debian9.12-slim`,`1.17.10-debian9.12-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/9.12-slim/Dockerfile)
- [`1.17-debian8.11-slim`,`1.17.10-debian8.11-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/8.11-slim/Dockerfile)
- [`1.17-debian10.3-slim`,`1.17.10-debian10.3-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/10.3-slim/Dockerfile)
- [`1.17-debian10.2-slim`,`1.17.10-debian10.2-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/debian/10.2-slim/Dockerfile)
- [`1.17-centos`,`1.17.10-centos`,`1.17-centos8.2.2004`,`1.17.10-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/8.2.2004/Dockerfile)
- [`1.17-centos8.1.1911`,`1.17.10-centos8.1.1911`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/8.1.1911/Dockerfile)
- [`1.17-centos7.8.2003`,`1.17.10-centos7.8.2003`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/centos/7.8.2003/Dockerfile)
- [`1.17-amazonlinux`,`1.17.10-amazonlinux`,`1.17-amazonlinux2.0.20180622.1`,`1.17.10-amazonlinux2.0.20180622.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2.0.20180622.1/Dockerfile)
- [`1.17-amazonlinux2018.03.0.20200318.1`,`1.17.10-amazonlinux2018.03.0.20200318.1`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2018.03.0.20200318.1/Dockerfile)
- [`1.17-amazonlinux2.0.20200406.0`,`1.17.10-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1.17-amazonlinux2.0.20181010`,`1.17.10-amazonlinux2.0.20181010`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2.0.20181010/Dockerfile)
- [`1.17-amazonlinux2.0.20180827`,`1.17.10-amazonlinux2.0.20180827`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/amazonlinux/2.0.20180827/Dockerfile)
- [`1.17-alpine`,`1.17.10-alpine`,`1.17-alpine3.12.0`,`1.17.10-alpine3.12.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.12.0/Dockerfile)
- [`1.17-alpine3.11.6`,`1.17.10-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.11.6/Dockerfile)
- [`1.17-alpine3.11.5`,`1.17.10-alpine3.11.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.11.5/Dockerfile)
- [`1.17-alpine3.10.5`,`1.17.10-alpine3.10.5`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.17.10/alpine/3.10.5/Dockerfile)
</details>

## What is nginx?

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Windows.

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)

## What is Lua?

Lua is a lightweight, high-level, multi-paradigm programming language designed primarily for embedded use in applications. Lua is cross-platform, since the interpreter of compiled bytecode is written in ANSI C, and Lua has a relatively simple C API to embed it into applications.

> [wikipedia.org/wiki/Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))

## Features

 - Support for LUA.
 - Minimal size only, minimal layers.
 - Same build configure of official nginx image.
 - Security checks: Docker Bench Security, Snyk.
 - Docker Healthchecks.
 - Exposes default ports (`80` and `443`), easy to extend.
 - Runs as non-root UID/GID `32548` (selected randomly to avoid mapping to an existing user) and uses [dumb-init](https://github.com/Yelp/dumb-init) to reap zombie processes.
 - Support for multiple linux distros: Alpine, Amazon, CentOS, Debian, Fedora, Ubuntu.

## Specs

 - [nginx](https://nginx.org/en/download.html)
 - Supported OS
   - [Alpine Linux](https://hub.docker.com/_/alpine) (30-50MB)
   - [Amazon Linux](https://hub.docker.com/_/amazonlinux) (~300MB)
   - [CentOS](https://hub.docker.com/_/centos) (~300MB)
   - [Debian](https://hub.docker.com/_/debian) (~250MB)
   - [Fedora](https://hub.docker.com/_/fedora) (~300MB)
   - [Ubuntu](https://hub.docker.com/_/ubuntu) (~300MB)
 - [OpenResty's Branch of LuaJIT 2](https://github.com/openresty/luajit2)
 - [Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module)
 - [New FFI-based API for lua-nginx-module](https://github.com/openresty/lua-resty-core)
 - [Lua-land LRU Cache based on LuaJIT FFI](https://github.com/openresty/lua-resty-lrucache)
 - [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit)
 - <details><summary>Additional Modules</summary>

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
   </details>

### Compiled Version Details

```console
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' --add-module=/lua-nginx-module-0.10.15 --add-module=/ngx_devel_kit-0.3.1 --with-http_dav_module --with-http_geoip_module
```

## Run Container

```bash
docker run -it --rm -p 80:80 \
  --health-cmd='curl --fail http://example.com || exit 1' \
  --health-interval=30s \
  --health-timeout=3s \
  fabiocicerchia/nginx-lua:latest
```

## Image Variants

### `fabiocicerchia/nginx-lua:<version>`
The default Nginx + LUA image. Uses Alpine for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro>`
Provides Nginx + LUA. Uses Alpine, Amazon Linux, CentOS, Debian, Fedora, Ubuntu for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro><version>`
Provides Nginx + LUA. Uses pinned version for Alpine, Amazon Linux, CentOS, Debian, Fedora, Ubuntu for base image.

## Example

### Virtual Host

```nginx
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

### Docker Compose

```yaml
version: '3.7'
services:
  nginx-lua:
    image: fabiocicerchia/nginx-lua:latest
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /path/to/docroot:/var/www/html
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    healthcheck:
      test: ['CMD', 'curl --fail http://localhost/ || exit 1']
      interval: 30s
      timeout: 3s
      retries: 3
```

# License

MIT License

Copyright (c) 2020 Fabio Cicerchia <info@fabiocicerchia.it>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
