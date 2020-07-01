# Nginx & Lua

![nginx logo](https://github.com/fabiocicerchia/nginx-lua/raw/master/docs/logo-nginx.png)
![lua logo](https://github.com/fabiocicerchia/nginx-lua/raw/master/docs/logo-lua.png)

---

![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.svg "Docker pulls")
![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.svg "Docker stars")
![Known Vulnerabilities](https://img.shields.io/badge/vulnerabilities-snyk-4b45a9)

Nginx 1.19+ with Lua support based on Alpine Linux, Amazon Linux, CentOS, Debian, Fedora and Ubuntu.

## Quick reference

- **Maintained by**: [Fabio Cicerchia](https://github.com/fabiocicerchia)
- **Where to get help**: [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

## Supported tags and respective `Dockerfile` links

- [`1`,`1.19`,`1.19.0`,`1-alpine`,`1.19-alpine`,`1.19.0-alpine`,`1-alpine3.12.0`,`1-alpine3.12.0`,`1.19-alpine3.12.0`,`1.19.0-alpine3.12.0`,`latest`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.12.0/Dockerfile)
- [`1-ubuntu`,`1.19-ubuntu`,`1-ubuntu20.10`,`1-ubuntu20.10`,`1.19.0-ubuntu`,`1.19-ubuntu20.10`,`1.19.0-ubuntu20.10`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/20.10/Dockerfile)
- [`1-ubuntu20.04`,`1.19-ubuntu20.04`,`1.19.0-ubuntu20.04`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/ubuntu/20.04/Dockerfile)
- [`1-fedora`,`1-fedora33`,`1-fedora33`,`1.19-fedora`,`1.19-fedora33`,`1.19.0-fedora`,`1.19.0-fedora33`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/33/Dockerfile)
- [`1-fedora32`,`1.19-fedora32`,`1.19.0-fedora32`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/fedora/32/Dockerfile)
- [`1-debian`,`1.19-debian`,`1.19.0-debian`,`1-debian10.4-slim`,`1-debian10.4-slim`,`1.19-debian10.4-slim`,`1.19.0-debian10.4-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.4-slim/Dockerfile)
- [`1-debian10.3-slim`,`1.19-debian10.3-slim`,`1.19.0-debian10.3-slim`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/debian/10.3-slim/Dockerfile)
- [`1-centos`,`1.19-centos`,`1.19.0-centos`,`1-centos8.2.2004`,`1-centos8.2.2004`,`1.19-centos8.2.2004`,`1.19.0-centos8.2.2004`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/8.2.2004/Dockerfile)
- [`1-centos8.1.1911`,`1.19-centos8.1.1911`,`1.19.0-centos8.1.1911`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/centos/8.1.1911/Dockerfile)
- [`1-amazonlinux`,`1.19-amazonlinux`,`1.19.0-amazonlinux`,`1-amazonlinux2.0.20200406.0`,`1-amazonlinux2.0.20200406.0`,`1.19-amazonlinux2.0.20200406.0`,`1.19.0-amazonlinux2.0.20200406.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20200406.0/Dockerfile)
- [`1-amazonlinux2.0.20200304.0`,`1.19-amazonlinux2.0.20200304.0`,`1.19.0-amazonlinux2.0.20200304.0`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/amazonlinux/2.0.20200304.0/Dockerfile)
- [`1-alpine3.11.6`,`1.19-alpine3.11.6`,`1.19.0-alpine3.11.6`](https://github.com/fabiocicerchia/nginx-lua/blob/master/nginx/1.19.0/alpine/3.11.6/Dockerfile)

**Note:** The full list of supported/unsupported tags can be found on [docs/TAGS.md](https://github.com/fabiocicerchia/nginx-lua/blob/master/docs/TAGS.md).

## What is nginx?

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Windows.

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)

## What is Lua?

Lua is a lightweight, high-level, multi-paradigm programming language designed primarily for embedded use in applications. Lua is cross-platform, since the interpreter of compiled bytecode is written in ANSI C, and Lua has a relatively simple C API to embed it into applications.

> [wikipedia.org/wiki/Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))

## Features

- Support for Lua.
- Minimal size only, minimal layers.
- Same build configure of official nginx image.
- Security checks: Docker Bench Security, Snyk.
- Docker Healthchecks.
- Exposes default ports (`80` and `443`), easy to extend.
- Runs as non-root UID/GID `32548` (selected randomly to avoid mapping to an existing user) and uses [dumb-init](https://github.com/Yelp/dumb-init) to reap zombie processes.
- Support for multiple linux distros: Alpine, Amazon, CentOS, Debian, Fedora, Ubuntu.
- Extra Lua Modules.
- Performance Benchmarks.

## Specs

- [nginx](https://nginx.org/en/download.html)
- Supported OS
  - [Alpine Linux](https://hub.docker.com/_/alpine) (~30MB)
  - [Amazon Linux](https://hub.docker.com/_/amazonlinux) (~200MB)
  - [CentOS](https://hub.docker.com/_/centos) (~250MB)
  - [Debian](https://hub.docker.com/_/debian) (~150MB)
  - [Fedora](https://hub.docker.com/_/fedora) (~250MB)
  - [Ubuntu](https://hub.docker.com/_/ubuntu) (~200MB)
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
  - [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module)
  - [lua-resty-cookie](https://github.com/cloudflare/lua-resty-cookie)
  - [lua-resty-dns](https://github.com/openresty/lua-resty-dns)
  - [lua-resty-memcached](https://github.com/openresty/lua-resty-memcached)
  - [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql)
  - [lua-resty-redis](https://github.com/openresty/lua-resty-redis)
  - [lua-resty-shell](https://github.com/openresty/lua-resty-shell)
  - [lua-resty-upstream-healthcheck](https://github.com/openresty/lua-resty-upstream-healthcheck)
  - [lua-resty-websocket](https://github.com/openresty/lua-resty-websocket)
  - [nginx-lua-prometheus](https://github.com/knyar/nginx-lua-prometheus)
  - [stream-lua-nginx-module](https://github.com/openresty/stream-lua-nginx-module)
  </details>

### Compiled Version Details

```bash
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --user=nginx --group=nginx --add-module=/lua-nginx-module-0.10.15 --add-module=/ngx_devel_kit-0.3.1 --with-compat --with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
```

The following are the available build-time options. They can be set using the `--build-arg` CLI argument.

| Key                      | Default                                    | Description |
:------------------------- | :----------------------------------------: |:----------- |
| DOCKER_IMAGE             | `fabiocicerchia/nginx-lua`                 | The image name. |
| DOCKER_IMAGE_OS          | `alpine`                                   | The Docker base image to build `FROM`. |
| DOCKER_IMAGE_TAG         | `3.12.0`                                   | The Docker image tag to build `FROM`. |
| BUILD_DATE               |                                            | This label contains the Date/Time the image was built. |
| VCS_REF                  |                                            | Identifier for the version of the source code from which this image was built. |
| EXTENDED_IMAGE           | `1`                                        | Flag to identify if extended image (which contains extra modules). |
| VER_NGX_DEVEL_KIT        | `0.3.1`                                    | The version of [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit) to use. |
| VER_LUAJIT               | `2.1-20200102`                             | The version of [LuaJIT](https://github.com/openresty/luajit2) to use. |
| LUAJIT_LIB               | `/usr/local/lib`                           | Tell nginx's build system where to find LuaJIT 2.0 |
| LUAJIT_INC               | `/usr/local/include/luajit-2.1`            | Tell nginx's build system where to find LuaJIT 2.0 |
| LD_LIBRARY_PATH          | `/usr/local/lib/:$LD_LIBRARY_PATH`         | Search path environment variable for the linux shared library. |
| VER_LUA_NGINX_MODULE     | `0.10.15`                                  | The version of [ngx_http_lua_module](https://github.com/openresty/lua-nginx-module) to use. |
| VER_LUA_RESTY_CORE       | `0.1.17`                                   | The version of [lua-resty-core](https://github.com/openresty/lua-resty-core) to use. |
| LUA_LIB_DIR              | `/usr/local/share/lua/5.1`                 | Path to Lua library directory. |
| VER_LUA_RESTY_LRUCACHE   | `0.09`                                     | The version of [lua-resty-lrucache](https://github.com/openresty/lua-resty-lrucache) to use. |
| VER_OPENRESTY_HEADERS    | `743a4bb1a253325d17a4f4ce8ee61ea0d8e0cc19` | The version of [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module) to use. |
| VER_CLOUDFLARE_COOKIE    | `c54865bdcfc3c42cbd6dbbceb654ba73871d07f6` | The version of [lua-resty-cookie](https://github.com/cloudflare/lua-resty-cookie) to use. |
| VER_OPENRESTY_DNS        | `0.21`                                     | The version of [lua-resty-dns](https://github.com/openresty/lua-resty-dns) to use. |
| VER_OPENRESTY_MEMCACHED  | `0.15`                                     | The version of [lua-resty-memcached](https://github.com/openresty/lua-resty-memcached) to use. |
| VER_OPENRESTY_MYSQL      | `0.22`                                     | The version of [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql) to use. |
| VER_OPENRESTY_REDIS      | `0.27`                                     | The version of [lua-resty-redis](https://github.com/openresty/lua-resty-redis) to use. |
| VER_OPENRESTY_SHELL      | `0.02`                                     | The version of [lua-resty-shell](https://github.com/openresty/lua-resty-shell) to use. |
| VER_OPENRESTY_HALTHCHECK | `0.06`                                     | The version of [lua-resty-upstream-healthcheck](https://github.com/openresty/lua-resty-upstream-healthcheck) to use. |
| VER_OPENRESTY_WEBSOCKET  | `0.07`                                     | The version of [lua-resty-websocket](https://github.com/openresty/lua-resty-websocket) to use. |
| VER_PROMETHEUS           | `0.20200523`                               | The version of [nginx-lua-prometheus](https://github.com/knyar/nginx-lua-prometheus) to use. |
| VER_OPENRESTY_STREAMLUA  | `0.0.8rc3`                                 | The version of [stream-lua-nginx-module](https://github.com/openresty/stream-lua-nginx-module) to use. |
| VER_NGINX                | `1.19.0`                                   | The version of nginx to use. |
| NGINX_BUILD_CONFIG       | `--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --user=nginx --group=nginx --add-module=/lua-nginx-module-${VER_LUA_NGINX_MODULE} --add-module=/ngx_devel_kit-${VER_NGX_DEVEL_KIT} --with-compat --with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads` | Options to pass to nginx's `./configure` script. |
| BUILD_DEPS               | Differs based on the distro                | List of needed packages to build properly the software. |
| NGINX_BUILD_DEPS         | Differs based on the distro                | List of needed packages to build properly nginx. |
| VER_DUMBINIT             | `1.2.2`                                    | The version of [dumb-init](https://github.com/Yelp/dumb-init) to use. |
| PKG_DEPS                 | Differs based on the distro                | List of needed packages to run properly the software. |

These built-from-source flavors include the following modules by default, but one can easily increase or decrease that with the custom build options above:

- file-aio
- http_addition_module
- http_auth_request_module
- http_dav_module
- http_dav_module
- http_flv_module
- http_geoip_module
- http_gunzip_module
- http_gzip_static_module
- http_mp4_module
- http_random_index_module
- http_realip_module
- http_secure_link_module
- http_slice_module
- http_ssl_module
- http_stub_status_module
- http_sub_module
- http_v2_module
- mail
- mail_ssl_module
- stream
- stream_realip_module
- stream_ssl_module
- stream_ssl_preread_module
- thread

## Notes

- The `SIGQUIT` signal will be sent to nginx to stop this container, to give it an opportunity to stop gracefully (i.e, finish processing active connections). The Docker default is `SIGTERM`, which immediately terminates active connections. Note that if your configuration listens on UNIX domain sockets, this means that you'll need to manually remove the socket file upon shutdown, due to [nginx bug #753](https://trac.nginx.org/nginx/ticket/753).

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
The default Nginx + Lua image. Uses Alpine for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro>`
Provides Nginx + Lua. Uses Alpine, Amazon Linux, CentOS, Debian, Fedora, Ubuntu for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro><version>`
Provides Nginx + Lua. Uses pinned version for Alpine, Amazon Linux, CentOS, Debian, Fedora, Ubuntu for base image.

## Image Labels

The image builds are labeled with various information. Here's an example of printing the labels using jq:

```bash
$ docker pull fabiocicerchia/nginx-lua:1-alpine
$ docker inspect fabiocicerchia/nginx-lua:1-alpine | jq '.[].Config.Labels'
{
  "maintainer": "Fabio Cicerchia <info@fabiocicerchia.it>",
  "org.label-schema.build-date": "1970-01-01T00:00:00Z",
  "org.label-schema.description": "Nginx 1.19.0 with Lua support based on alpine 3.12.0.",
  "org.label-schema.docker.cmd": "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.19.0-alpine3.12.0",
  "org.label-schema.name": "fabiocicerchia/nginx-lua",
  "org.label-schema.schema-version": "1.0",
  "org.label-schema.url": "https://github.com/fabiocicerchia/nginx-lua",
  "org.label-schema.vcs-ref": "5b8a255",
  "org.label-schema.vcs-url": "https://github.com/fabiocicerchia/nginx-lua",
  "org.label-schema.version": "1.19.0-alpine3.12.0",
  "versions.extended": "1",
  "versions.dumb-init": "1.2.2",
  "versions.headers-more-nginx-module": "743a4bb1a253325d17a4f4ce8ee61ea0d8e0cc19",
  "versions.lua-nginx-module": "0.10.15",
  "versions.lua-resty-cookie": "c54865bdcfc3c42cbd6dbbceb654ba73871d07f6",
  "versions.lua-resty-core": "0.1.17",
  "versions.lua-resty-dns": "0.21",
  "versions.lua-resty-lrucache": "0.09",
  "versions.lua-resty-memcached": "0.15",
  "versions.lua-resty-mysql": "0.22",
  "versions.lua-resty-redis": "0.27",
  "versions.lua-resty-shell": "0.02",
  "versions.lua-resty-upstream-healthcheck": "0.06",
  "versions.lua-resty-websocket": "0.07",
  "versions.luajit2": "2.1-20200102",
  "versions.nginx": "1.19.0",
  "versions.nginx-lua-prometheus": "0.20200523",
  "versions.ngx_devel_kit": "0.3.1",
  "versions.os": "3.12.0",
  "versions.stream-lua-nginx-module": "0.0.8rc3"
}
```

| Label Name                                | Description             |
:------------------------------------------ |:----------------------- |
| `maintainer`                              | Maintainer of the image |
| `org.label-schema.build-date`             | This label contains the Date/Time the image was built. The value SHOULD be formatted according to RFC 3339. buildarg `BUILD_DATE` |
| `org.label-schema.description`            | Text description of the image. May contain up to 300 characters. |
| `org.label-schema.docker.cmd`             | How to run a container based on the image under the Docker runtime. |
| `org.label-schema.name`                   | buildarg `DOCKER_IMAGE` |
| `org.label-schema.schema-version`         | This label SHOULD be present to indicate the version of Label Schema in use. |
| `org.label-schema.url`                    | URL of website with more information about the product or service provided by the container. |
| `org.label-schema.vcs-ref`                | buildarg `VCS_REF` |
| `org.label-schema.vcs-url`                | URL for the source code under version control from which this container image was built. |
| `org.label-schema.version`                | Release identifier for the contents of the image. |
| `versions.extended`                       | Flag to identify if extended image (which contains extra modules). |
| `versions.dumb-init`                      | The version of [dumb-init](https://github.com/Yelp/dumb-init) used. |
| `versions.headers-more-nginx-module`      | The version of [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module) used. |
| `versions.lua-nginx-module`               | The version of [ngx_http_lua_module](https://github.com/openresty/lua-nginx-module) used. |
| `versions.lua-resty-cookie`               | The version of [lua-resty-cookie](https://github.com/cloudflare/lua-resty-cookie) used. |
| `versions.lua-resty-core`                 | The version of [lua-resty-core](https://github.com/openresty/lua-resty-core) used. |
| `versions.lua-resty-dns`                  | The version of [lua-resty-dns](https://github.com/openresty/lua-resty-dns) used. |
| `versions.lua-resty-lrucache`             | The version of [lua-resty-lrucache](https://github.com/openresty/lua-resty-lrucache) used. |
| `versions.lua-resty-memcached`            | The version of [lua-resty-memcached](https://github.com/openresty/lua-resty-memcached) used. |
| `versions.lua-resty-mysql`                | The version of [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql) used. |
| `versions.lua-resty-redis`                | The version of [lua-resty-redis](https://github.com/openresty/lua-resty-redis) used. |
| `versions.lua-resty-shell`                | The version of [lua-resty-shell](https://github.com/openresty/lua-resty-shell) used. |
| `versions.lua-resty-upstream-healthcheck` | The version of [lua-resty-upstream-healthcheck](https://github.com/openresty/lua-resty-upstream-healthcheck) used. |
| `versions.lua-resty-websocket`            | The version of [lua-resty-websocket](https://github.com/openresty/lua-resty-websocket) used. |
| `versions.luajit2`                        | The version of [LuaJIT](https://github.com/openresty/luajit2) used. |
| `versions.nginx`                          | The version of nginx used. |
| `versions.nginx-lua-prometheus`           | The version of [nginx-lua-prometheus](https://github.com/knyar/nginx-lua-prometheus) used. |
| `versions.ngx_devel_kit`                  | The version of [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit) used. |
| `versions.os`                             | The Docker base image. |
| `versions.stream-lua-nginx-module`        | The version of [stream-lua-nginx-module](https://github.com/openresty/stream-lua-nginx-module) used. |

## Benchmarks

## nginx vs nginx-lua vs openresty

![Benchmark Mean Requests per Second](http://chart.googleapis.com/chart?chco=00B140,000080,4D8D89&chd=t:256.8|257.91|259.59&chdl=nginx|nginx-lua|openresty&chdlp=bvr&chds=250,270&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Requests+per+second&chxl=0:|reqs/sec&chxr=1,250,270,5&chxt=x,y)
![Benchmark Median Response Time](http://chart.googleapis.com/chart?&chco=00B140,000080,4D8D89&chd=t:8.8|8.83|8.76&chdl=nginx|nginx-lua|openresty&chdlp=bvr&chds=8,9&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Median+Response+Time&chxl=0:|msec&chxr=1,8,9,0.2&chxt=x,y)

More details about the benchark can be found in [docs/benchmarks/different_images](docs/benchmarks/different_images).

## nginx-lua different distro

![Benchmark Mean Requests per Second](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:226.12|226.23|217.74|222.27|216.50&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=180,250&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Requests+per+second&chxl=0:|reqs/sec&chxr=1,180,250,20&chxt=x,y)
![Benchmark Median Response Time](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:9.86|9.93|10.4|10.06|10.3&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=9.5,10&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Median+Response+Time&chxl=0:|msec&chxr=1,9.5,10,0.1&chxt=x,y)

More details about the benchark can be found in [docs/benchmarks/distros](docs/benchmarks/distros).

## Examples

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

## License

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

- [Nginx License](https://nginx.org/LICENSE)
- [Lua License](https://www.lua.org/license.html)
- [OpenResty License](https://github.com/openresty/openresty#copyright--license)

### `fabiocicerchia/nginx-lua`

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
