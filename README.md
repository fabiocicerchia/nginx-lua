# Nginx & Lua

![nginx logo](https://github.com/fabiocicerchia/nginx-lua/raw/main/docs/logo-nginx.png)
![lua logo](https://github.com/fabiocicerchia/nginx-lua/raw/main/docs/logo-lua.png)

---

[![MIT License](https://img.shields.io/badge/License-MIT-lightgrey.svg?longCache=true)](LICENSE)
[![Pull Requests](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?longCache=true)](https://github.com/fabiocicerchia/nginx-lua/pulls)
![Last Commit](https://img.shields.io/github/last-commit/fabiocicerchia/nginx-lua)
![Release Date](https://img.shields.io/github/release-date/fabiocicerchia/nginx-lua)

![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.svg "Docker pulls")
![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.svg "Docker stars")
![Known Vulnerabilities](https://img.shields.io/badge/vulnerabilities-snyk-4b45a9)

![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
![Docker Builds](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker%20Builds/badge.svg)
![Auto Update](https://github.com/fabiocicerchia/nginx-lua/workflows/Auto%20Update/badge.svg)
[![Documentation Status](https://readthedocs.org/projects/nginx-lua/badge/?version=latest)](https://nginx-lua.readthedocs.io/en/latest/?badge=latest)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ffabiocicerchia%2Fnginx-lua.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Ffabiocicerchia%2Fnginx-lua?ref=badge_shield)

Nginx 1.19+ with Lua support based on Alpine Linux, Amazon Linux, Fedora and Ubuntu.

---

## 💗 Support the Project 💗

This project is only maintained by one person, [Fabio Cicerchia](https://github.com/fabiocicerchia).  
It started as a simple docker image, now it updates automatically periodically and provides support for multiple disto 😎  
Maintaining a project is a very time consuming activity, especially when done alone 💪  
I really want to make this project better and become super cool 🚀

If you'd like to support this open-source project I'll appreciate any kind of [contribution](https://github.com/sponsors/fabiocicerchia).

---

## Quick reference

- **Maintained by**: [Fabio Cicerchia](https://github.com/fabiocicerchia)
- **Where to get help**: [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

## Supported tags and respective `Dockerfile` links

<!-- START_SUPPORTED_TAGS -->
- [`almalinux`, `1-almalinux`, `1.23-almalinux`, `1.23.1-almalinux`, `1-almalinux8.6-20220706`, `1.23-almalinux8.6-20220706`, `1.23.1-almalinux8.6-20220706`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/almalinux/8.6-20220706/Dockerfile)
- [`almalinux-compat`, `1-almalinux-compat`, `1.23-almalinux-compat`, `1.23.1-almalinux-compat`, `1-almalinux8.6-20220706-compat`, `1.23-almalinux8.6-20220706-compat`, `1.23.1-almalinux8.6-20220706-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/almalinux/8.6-20220706/Dockerfile-compat)
- [`1`, `1.23`, `1.23.1`, `alpine`, `latest`, `1-alpine`, `1.23-alpine`, `1.23.1-alpine`, `1-alpine3.16.1`, `1.23-alpine3.16.1`, `1.23.1-alpine3.16.1`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/alpine/3.16.1/Dockerfile)
- [`1-compat`, `1.23-compat`, `1.23.1-compat`, `alpine-compat`, `latest-compat`, `1-alpine-compat`, `1.23-alpine-compat`, `1.23.1-alpine-compat`, `1-alpine3.16.1-compat`, `1.23-alpine3.16.1-compat`, `1.23.1-alpine3.16.1-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/alpine/3.16.1/Dockerfile-compat)
- [`amazonlinux`, `1-amazonlinux`, `1.23-amazonlinux`, `1.23.1-amazonlinux`, `1-amazonlinux2.0.20220606.1`, `1.23-amazonlinux2.0.20220606.1`, `1.23.1-amazonlinux2.0.20220606.1`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/amazonlinux/2.0.20220606.1/Dockerfile)
- [`amazonlinux-compat`, `1-amazonlinux-compat`, `1.23-amazonlinux-compat`, `1.23.1-amazonlinux-compat`, `1-amazonlinux2.0.20220606.1-compat`, `1.23-amazonlinux2.0.20220606.1-compat`, `1.23.1-amazonlinux2.0.20220606.1-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/amazonlinux/2.0.20220606.1/Dockerfile-compat)
- [`debian`, `1-debian`, `1.23-debian`, `1-debian11.4`, `1.23.1-debian`, `1.23-debian11.4`, `1.23.1-debian11.4`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/debian/11.4/Dockerfile)
- [`debian-compat`, `1-debian-compat`, `1.23-debian-compat`, `1-debian11.4-compat`, `1.23.1-debian-compat`, `1.23-debian11.4-compat`, `1.23.1-debian11.4-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/debian/11.4/Dockerfile-compat)
- [`fedora`, `1-fedora`, `1-fedora36`, `1.23-fedora`, `1.23-fedora36`, `1.23.1-fedora`, `1.23.1-fedora36`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/fedora/36/Dockerfile)
- [`fedora-compat`, `1-fedora-compat`, `1-fedora36-compat`, `1.23-fedora-compat`, `1.23-fedora36-compat`, `1.23.1-fedora-compat`, `1.23.1-fedora36-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/fedora/36/Dockerfile-compat)
- [`ubuntu`, `1-ubuntu`, `1.23-ubuntu`, `1-ubuntu22.04`, `1.23.1-ubuntu`, `1.23-ubuntu22.04`, `1.23.1-ubuntu22.04`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/ubuntu/22.04/Dockerfile)
- [`ubuntu-compat`, `1-ubuntu-compat`, `1.23-ubuntu-compat`, `1-ubuntu22.04-compat`, `1.23.1-ubuntu-compat`, `1.23-ubuntu22.04-compat`, `1.23.1-ubuntu22.04-compat`](https://github.com/fabiocicerchia/nginx-lua/blob/main/nginx/1.23.1/ubuntu/22.04/Dockerfile-compat)
<!-- END_SUPPORTED_TAGS -->

**Note:** The full list of supported/unsupported tags can be found on [`docs/TAGS.md`](https://github.com/fabiocicerchia/nginx-lua/blob/main/docs/TAGS.md).

## Quick reference (cont.)

- **Where to file issues:** [https://github.com/fabiocicerchia/nginx-lua/issues](https://github.com/fabiocicerchia/nginx-lua/issues)
- **Supported architectures:** amd64, arm64
- **Published image artifact details:** [repo-info repo's docs/metadata/ directory](https://github.com/fabiocicerchia/nginx-lua/tree/main/docs/examples) ([history](https://github.com/fabiocicerchia/nginx-lua/commits/main/docs/metadata)) (image metadata, transfer size, etc)

## What is nginx?

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Windows.

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)

## What is Lua?

Lua is a lightweight, high-level, multi-paradigm programming language designed primarily for embedded use in applications. Lua is cross-platform, since the interpreter of compiled bytecode is written in ANSI C, and Lua has a relatively simple C API to embed it into applications.

> [wikipedia.org/wiki/Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))

## Why this repo and not OpenResty?

With this project you'll get a fresh nginx + lua version the day after (or even less than a day) of the release of a new nginx version!

| | nginx-lua | OpenResty |
|--|--|--|
| nginx latest version | `1.21.6` | `1.19.x` (last tested: `1.19.9`)¹ |
| Almalinux supported | ✅ | ❌ |
| Alpine supported | ✅ | ✅ |
| Amazon supported | ✅ | ✅ |
| CentOS supported | ❌ | ✅ |
| Debian supported | ✅ | ✅ |
| Fedora supported | ✅ | ❌ |
| Ubuntu supported | ✅ | ✅ |
| Windows supported | ❌ | ✅ |

¹ Note: Between official nginx `1.19.9` (30 Mar 2021) and OpenResty compatibility for `1.19.9.1` (6 Aug 2021) have passed ~4 months.

## Features

- Support for Lua.
- Minimal size only, minimal layers.
- Same build configure of official nginx image.
- Security checks: Docker Bench Security, Snyk.
- Docker Healthchecks.
- Exposes default ports (`80` and `443`), easy to extend.
- Support for multiple linux distros: Almalinux, Alpine, Amazon, Debian, Fedora, Ubuntu.
- Extra Lua Modules.
- Performance Benchmarks.
- LuaRocks Support.

## Typical Uses

> Just to name a few:
>
> - Mashup'ing and processing outputs of various Nginx upstream outputs (proxy, drizzle, postgres, redis, memcached, and etc) in Lua,
> - doing arbitrarily complex access control and security checks in Lua before requests actually reach the upstream backends,
> - manipulating response headers in an arbitrary way (by Lua)
> - fetching backend information from external storage backends (like redis, memcached, mysql, postgresql) and use that information to choose which upstream backend to access on-the-fly,
> - coding up arbitrarily complex web applications in a content handler using synchronous but still non-blocking access to the database backends and other storage,
> - doing very complex URL dispatch in Lua at rewrite phase,
> - using Lua to implement advanced caching mechanism for Nginx's subrequests and arbitrary locations.
>
> The possibilities are unlimited as the module allows bringing together various
> elements within Nginx as well as exposing the power of the Lua language to the
> user. The module provides the full flexibility of scripting while offering
> performance levels comparable with native C language programs both in terms of
> CPU time as well as memory footprint thanks to LuaJIT 2.x.
>
> Other scripting language implementations typically struggle to match this
> performance level.
>
> - <https://github.com/openresty/lua-nginx-module#typical-uses>

## How to use this image

### Hosting some simple static content

```console
$ docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d fabiocicerchia/nginx-lua
[...OMITTED...]
```

Alternatively, a simple `Dockerfile` can be used to generate a new image that includes the necessary content (which is a much cleaner solution than the bind mount above):

```dockerfile
FROM fabiocicerchia/nginx-lua
COPY static-html-directory /usr/share/nginx/html
```

Place this file in the same directory as your directory of content ("static-html-directory"), run `docker build -t some-content-nginx .`, then start your container:

```console
$ docker run --name some-nginx -d some-content-nginx
[...OMITTED...]
```

### Exposing external port

```console
$ docker run --name some-nginx -d -p 8080:80 some-content-nginx
[...OMITTED...]
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

### Complex configuration

```console
$ docker run --name my-custom-nginx-container -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d fabiocicerchia/nginx-lua
[...OMITTED...]
```

For information on the syntax of the nginx configuration files, see [the official documentation](http://nginx.org/en/docs/) (specifically the [Beginner's Guide](http://nginx.org/en/docs/beginners_guide.html#conf_structure)).
If you wish to adapt the default configuration, use something like the following to copy it from a running nginx container:

```console
$ docker run --name tmp-nginx-container -d fabiocicerchia/nginx-lua
[...OMITTED...]
$ docker cp tmp-nginx-container:/etc/nginx/nginx.conf /host/path/nginx.conf
[...OMITTED...]
$ docker rm -f tmp-nginx-container
[...OMITTED...]
```

This can also be accomplished more cleanly using a simple `Dockerfile` (in `/host/path/`):

```dockerfile
FROM fabiocicerchia/nginx-lua
COPY nginx.conf /etc/nginx/nginx.conf
```

If you add a custom `CMD` in the Dockerfile, be sure to include `-g daemon off;` in the `CMD` in order for nginx to stay in the foreground, so that Docker can track the process properly (otherwise your container will stop immediately after starting)!
Then build the image with `docker build -t custom-nginx .` and run it as follows:

```console
$ docker run --name my-custom-nginx-container -d custom-nginx
[...OMITTED...]
```

#### Using environment variables in nginx configuration (new in 1.19)

Out-of-the-box, nginx doesn't support environment variables inside most configuration blocks. But this image has a function, which will extract environment variables before nginx starts.
Here is an example using docker-compose.yml:

```yaml
web:
  image: fabiocicerchia/nginx-lua
  volumes:
    - ./templates:/etc/nginx/templates
  ports:
    - "8080:80"
  environment:
    - NGINX_HOST=foobar.com
    - NGINX_PORT=80
```

By default, this function reads template files in `/etc/nginx/templates/*.template` and outputs the result of executing `envsubst` to `/etc/nginx/conf.d`.
So if you place `templates/default.conf.template` file, which contains variable references like this:

```nginx
listen       ${NGINX_PORT};
```

outputs to `/etc/nginx/conf.d/default.conf` like this:

```nginx
listen       80;
```

This behavior can be changed via the following environment variables:

- `NGINX_ENVSUBST_TEMPLATE_DIR`
  - A directory which contains template files (default: `/etc/nginx/templates`)
  - When this directory doesn't exist, this function will do nothing about template processing.
- `NGINX_ENVSUBST_TEMPLATE_SUFFIX`
  - A suffix of template files (default: `.template`)
  - This function only processes the files whose name ends with this suffix.
- `NGINX_ENVSUBST_OUTPUT_DIR`
  - A directory where the result of executing envsubst is output (default: `/etc/nginx/conf.d`)
  - The output filename is the template filename with the suffix removed.
    - ex.) `/etc/nginx/templates/default.conf.template` will be output with the filename `/etc/nginx/conf.d/default.conf`.
  - This directory must be writable by the user running a container.

### Running nginx in read-only mode

To run nginx in read-only mode, you will need to mount a Docker volume to every location where nginx writes information. The default nginx configuration requires write access to `/var/cache` and `/var/run`. This can be easily accomplished by running nginx as follows:

```console
$ docker run -d -p 80:80 --read-only -v $(pwd)/nginx-cache:/var/cache/nginx -v $(pwd)/nginx-pid:/var/run fabiocicerchia/nginx-lua
[...OMITTED...]
```

If you have a more advanced configuration that requires nginx to write to other locations, simply add more volume mounts to those locations.

### Running nginx in debug mode

Images since version 1.19.3 come with `nginx-debug` binary that produces verbose output when using higher log levels. It can be used with simple CMD substitution:

```console
$ docker run --name my-nginx -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d fabiocicerchia/nginx-lua nginx-debug -g 'daemon off;'
[...OMITTED...]
```

Similar configuration in docker-compose.yml may look like this:

```yaml
web:
  image: fabiocicerchia/nginx-lua
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf:ro
  command: [nginx-debug, '-g', 'daemon off;']
```

### Entrypoint quiet logs

Since version 1.19.0, a verbose entrypoint was added. It provides information on what's happening during container startup. You can silence this output by setting environment variable `NGINX_ENTRYPOINT_QUIET_LOGS`:

```console
$ docker run -d -e NGINX_ENTRYPOINT_QUIET_LOGS=1 fabiocicerchia/nginx-lua
[...OMITTED...]
```

### User and group id

Since 1.17.0, both alpine- and debian-based images variants use the same user and group ids to drop the privileges for worker processes:

```console
$ id
uid=101(nginx) gid=101(nginx) groups=101(nginx)
```

### Running nginx as a non-root user

It is possible to run the image as a less privileged arbitrary UID/GID. This, however, requires modification of nginx configuration to use directories writeable by that specific UID/GID pair:

```console
$ docker run -d -v $PWD/nginx.conf:/etc/nginx/nginx.conf fabiocicerchia/nginx-lua
[...OMITTED...]
```

where nginx.conf in the current directory should have the following directives re-defined:

```nginx
pid        /tmp/nginx.pid;
```

And in the http context:

```nginx
http {
    client_body_temp_path /tmp/client_temp;
    proxy_temp_path       /tmp/proxy_temp_path;
    fastcgi_temp_path     /tmp/fastcgi_temp;
    uwsgi_temp_path       /tmp/uwsgi_temp;
    scgi_temp_path        /tmp/scgi_temp;
...
}
```

## Specs

- [nginx](https://nginx.org/en/download.html)
- Supported OS
  - [Almalinux](https://hub.docker.com/_/almalinux) (~430MB)
  - [Alpine Linux](https://hub.docker.com/_/alpine) (~65MB)
  - [Amazon Linux](https://hub.docker.com/_/amazonlinux) (~240MB)
  - [Debian](https://hub.docker.com/_/debian) (~250MB)
  - [Fedora](https://hub.docker.com/_/fedora) (~450MB)
  - [Ubuntu](https://hub.docker.com/_/ubuntu) (~220MB)
- [OpenResty's Branch of LuaJIT 2](https://github.com/openresty/luajit2)
- [Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module)
- [New FFI-based API for lua-nginx-module](https://github.com/openresty/lua-resty-core)
- [Lua-land LRU Cache based on LuaJIT FFI](https://github.com/openresty/lua-resty-lrucache)
- [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit)
- [LuaRocks](https://luarocks.org/)
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

```console
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --without-pcre2 --add-module=/lua-nginx-module-0.10.20 --add-module=/ngx_devel_kit-0.3.1 --add-module=/lua-upstream-nginx-module-0.07 --add-module=/headers-more-nginx-module-a4a0686605161a6777d7d612d5aef79b9e7c13e0 --add-module=/stream-lua-nginx-module-0.0.10 --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' --with-ld-opt='-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
```

The following are the available build-time options. They can be set using the `--build-arg` CLI argument.

| Key                         | Default                                    | Description |
:---------------------------- | :----------------------------------------: |:----------- |
| `ARCH`                      |                                            | The image name. |
| `DISTRO`                    |                                            | The Docker base image to build `FROM`. |
| `DISTRO_VER`                |                                            | The Docker image tag to build `FROM`. |
| `DOCKER_IMAGE`              | `fabiocicerchia/nginx-lua`                 | The image name. |
| `BUILD_DATE`                |                                            | This label contains the Date the image was built. |
| `VCS_REF`                   |                                            | Identifier for the version of the source code from which this image was built. |
| `TARGETPLATFORM`            | `linux/amd64`                              | Platform of the build result. eg. `linux/amd64`, `linux/arm/v7`, `windows/amd64`. |
| `TARGETOS`                  | `linux`                                    | OS component of `TARGETPLATFORM`. |
| `TARGETARCH`                | `amd64`                                    | Architecture component of `TARGETPLATFORM`. |
| `VER_NGX_DEVEL_KIT`         | `0.3.1`                                    | The version of [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit) to use. |
| `VER_LUAJIT`                | `2.1-20211210`                             | The version of [LuaJIT](https://github.com/openresty/luajit2) to use. |
| `LUAJIT_LIB`                | `/usr/local/lib`                           | Tell nginx's build system where to find LuaJIT 2.0 |
| `LUAJIT_INC`                | `/usr/local/include/luajit-2.1`            | Tell nginx's build system where to find LuaJIT 2.0 |
| `LD_LIBRARY_PATH`           | `/usr/local/lib/:$LD_LIBRARY_PATH`         | Search path environment variable for the linux shared library. |
| `VER_LUA`                   | `5.4`                                      | The version of [Lua](https://www.lua.org/) to use. |
| `VER_LUAROCKS`              | `3.8.0`                                    | The version of [LuaRocks](https://luarocks.org/) to use. |
| `VER_LUA_NGINX_MODULE`      | `0.10.20`                                  | The version of [ngx_http_lua_module](https://github.com/openresty/lua-nginx-module) to use. |
| `VER_LUA_RESTY_CORE`        | `0.1.22`                                   | The version of [lua-resty-core](https://github.com/openresty/lua-resty-core) to use. |
| `LUA_LIB_DIR`               | `/usr/local/share/lua/5.1`                 | Path to Lua library directory. |
| `VER_LUA_RESTY_LRUCACHE`    | `0.11`                                     | The version of [lua-resty-lrucache](https://github.com/openresty/lua-resty-lrucache) to use. |
| `VER_OPENRESTY_HEADERS`     | `a4a0686605161a6777d7d612d5aef79b9e7c13e0` | The version of [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module) to use. |
| `VER_CLOUDFLARE_COOKIE`     | `99be1005e38ce19ace54515272a2be1b9fdc5da2` | The version of [lua-resty-cookie](https://github.com/cloudflare/lua-resty-cookie) to use. |
| `VER_OPENRESTY_DNS`         | `0.22`                                     | The version of [lua-resty-dns](https://github.com/openresty/lua-resty-dns) to use. |
| `VER_OPENRESTY_MEMCACHED`   | `0.16`                                     | The version of [lua-resty-memcached](https://github.com/openresty/lua-resty-memcached) to use. |
| `VER_OPENRESTY_MYSQL`       | `0.24`                                     | The version of [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql) to use. |
| `VER_OPENRESTY_REDIS`       | `0.29`                                     | The version of [lua-resty-redis](https://github.com/openresty/lua-resty-redis) to use. |
| `VER_OPENRESTY_SHELL`       | `0.03`                                     | The version of [lua-resty-shell](https://github.com/openresty/lua-resty-shell) to use. |
| `VER_OPENRESTY_SIGNAL`      | `0.03`                                     | The version of [lua-resty-signal](https://github.com/openresty/lua-resty-signal) to use. |
| `VER_OPENRESTY_TABLEPOOL`   | `0.02`                                     | The version of [lua-tablepool](https://github.com/openresty/lua-tablepool) to use. |
| `VER_OPENRESTY_HEALTHCHECK` | `0.06`                                     | The version of [lua-resty-upstream-healthcheck](https://github.com/openresty/lua-resty-upstream-healthcheck) to use. |
| `VER_OPENRESTY_WEBSOCKET`   | `0.08`                                     | The version of [lua-resty-websocket](https://github.com/openresty/lua-resty-websocket) to use. |
| `VER_LUA_UPSTREAM`          | `0.07`                                     | The version of [lua-upstream-nginx-module](https://github.com/openresty/lua-upstream-nginx-module) to use. |
| `VER_PROMETHEUS`            | `0.20210206`                               | The version of [nginx-lua-prometheus](https://github.com/knyar/nginx-lua-prometheus) to use. |
| `VER_OPENRESTY_STREAMLUA`   | `0.0.10`                                   | The version of [stream-lua-nginx-module](https://github.com/openresty/stream-lua-nginx-module) to use. |
| `VER_NGINX`                 | `1.21.4`                                   | The version of nginx to use. |
| `NGX_CFLAGS`                | `-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC`                                   | Sets additional parameters that will be added to the CFLAGS variable. |
| `NGX_LDOPT`                 | `-Wl,-rpath,/usr/local/lib -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie`                                   | Sets additional parameters that will be used during linking. |
| `NGINX_BUILD_CONFIG`        | `--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --without-pcre2 --add-module=/lua-nginx-module-0.10.20 --add-module=/ngx_devel_kit-0.3.1 --add-module=/lua-upstream-nginx-module-0.07 --add-module=/headers-more-nginx-module-a4a0686605161a6777d7d612d5aef79b9e7c13e0 --add-module=/stream-lua-nginx-module-0.0.10` | Options to pass to nginx's `./configure` script. |
| `BUILD_DEPS_BASE`           | Differs based on the distro                | List of common needed packages to build properly the software. |
| `BUILD_DEPS_AMD64`          | Differs based on the distro                | List of needed packages to build properly the software on amd64. |
| `BUILD_DEPS_ARM64V8`        | Differs based on the distro                | List of needed packages to build properly the software on arm64/v8. |
| `NGINX_BUILD_DEPS`          | Differs based on the distro                | List of needed packages to build properly nginx. |
| `PKG_DEPS`                  | Differs based on the distro                | List of needed packages to run properly the software. |

These built-from-source flavors include the following modules by default, but one can easily increase or decrease that with the custom build options above:

- file-aio
- threads
- http_addition_module
- http_auth_request_module
- http_dav_module
- http_flv_module
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

## Notes

- The `SIGQUIT` signal will be sent to nginx to stop this container, to give it an opportunity to stop gracefully (i.e, finish processing active connections). The Docker default is `SIGTERM`, which immediately terminates active connections. Note that if your configuration listens on UNIX domain sockets, this means that you'll need to manually remove the socket file upon shutdown, due to [nginx bug #753](https://trac.nginx.org/nginx/ticket/753).

## Run Container

```console
$ docker run -it --rm -p 80:80 \
  --health-cmd='curl --fail http://example.com || exit 1' \
  --health-interval=30s \
  --health-timeout=3s \
  fabiocicerchia/nginx-lua:latest
```

## Image Variants

### `fabiocicerchia/nginx-lua:<version>`

The default Nginx + Lua + extra lua modules image. Uses Alpine for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro>`

Provides Nginx + Lua + extra lua modules. Uses Alpine, Amazon Linux, Debian, Fedora, Ubuntu for base image.

### `fabiocicerchia/nginx-lua:<version>-<distro><version>`

Provides Nginx + Lua + extra lua modules. Uses pinned version for Alpine, Amazon Linux, Debian, Fedora, Ubuntu for base image.

### `fabiocicerchia/nginx-lua:<version>-compat`

The default Nginx + Lua + extra lua modules image. Uses Alpine for base image. Enables LUA 5.1 Compatibility.  
**WARNING:** This version has a compiled version of LUA and not using the version distributed by the OS's packet manager.

### `fabiocicerchia/nginx-lua:<version>-<distro>-compat`

Provides Nginx + Lua + extra lua modules. Uses Alpine, Amazon Linux, Debian, Fedora, Ubuntu for base image. Enables LUA 5.1 Compatibility.  
**WARNING:** This version has a compiled version of LUA and not using the version distributed by the OS's packet manager.

### `fabiocicerchia/nginx-lua:<version>-<distro><version>-compat`

Provides Nginx + Lua + extra lua modules. Uses pinned version for Alpine, Amazon Linux, Debian, Fedora, Ubuntu for base image. Enables LUA 5.1 Compatibility.  
**WARNING:** This version has a compiled version of LUA and not using the version distributed by the OS's packet manager.

## Custom Builds

If you need to extend the functionality of the existing image, you could build your own version using the following command.
For the list of values do refer to the [relative section](#compiled-version-details).

```console
$ docker build \
  --build-arg NGINX_BUILD_CONFIG=... \ # nginx build flags
  --build-arg BUILD_DEPS=... \ # packages needed for building phase
  --build-arg NGINX_BUILD_DEPS=... \ # packages needed for building phase by nginx
  --build-arg PKG_DEPS=... \ # packages available in final image
  -f $DOCKERFILE .
```

## Image Labels

The image builds are labeled with various information. Here's an example of printing the labels using jq:

```console
$ docker pull fabiocicerchia/nginx-lua:1-alpine
$ docker inspect fabiocicerchia/nginx-lua:1-alpine | jq '.[].Config.Labels'
{
  "image.target.arch": "amd64",
  "image.target.os": "linux",
  "image.target.platform": "linux/amd64",
  "maintainer": "Fabio Cicerchia <info@fabiocicerchia.it>",
  "org.label-schema.build-date": "1970-01-01T00:00:00Z",
  "org.label-schema.description": "Nginx 1.21.6 with Lua support based on alpine 3.15.0.",
  "org.label-schema.docker.cmd": "docker run -p 80:80 -d fabiocicerchia/nginx-lua:1.21.6-alpine3.15.0",
  "org.label-schema.name": "fabiocicerchia/nginx-lua",
  "org.label-schema.schema-version": "1.0",
  "org.label-schema.url": "https://github.com/fabiocicerchia/nginx-lua",
  "org.label-schema.vcs-ref": "b3e7513",
  "org.label-schema.vcs-url": "https://github.com/fabiocicerchia/nginx-lua",
  "org.label-schema.version": "1.21.6-",
  "versions.headers-more-nginx-module": "a4a0686605161a6777d7d612d5aef79b9e7c13e0",
  "versions.lua": "5.4",
  "versions.lua-nginx-module": "0.10.20",
  "versions.lua-resty-cookie": "99be1005e38ce19ace54515272a2be1b9fdc5da2",
  "versions.lua-resty-core": "0.1.22",
  "versions.lua-resty-dns": "0.22",
  "versions.lua-resty-lrucache": "0.11",
  "versions.lua-resty-memcached": "0.16",
  "versions.lua-resty-mysql": "0.24",
  "versions.lua-resty-redis": "0.29",
  "versions.lua-resty-shell": "0.03",
  "versions.lua-resty-signal": "0.03",
  "versions.lua-resty-tablepool": "0.02",
  "versions.lua-resty-upstream-healthcheck": "0.06",
  "versions.lua-resty-websocket": "0.08",
  "versions.lua-upstream": "0.07",
  "versions.luajit2": "2.1-20211210",
  "versions.luarocks": "3.8.0",
  "versions.nginx": "1.21.6",
  "versions.nginx-lua-prometheus": "0.20210206",
  "versions.ngx_devel_kit": "0.3.1",
  "versions.os": "3.15.0",
  "versions.stream-lua-nginx-module": "0.0.10"
}
```

| Label Name                                | Description             |
:------------------------------------------ |:----------------------- |
| `maintainer`                              | Maintainer of the image |
| `org.label-schema.build-date`             | This label contains the Date the image was built. The value SHOULD be formatted according to RFC 3339. buildarg `BUILD_DATE` |
| `org.label-schema.description`            | Text description of the image. May contain up to 300 characters. |
| `org.label-schema.docker.cmd`             | How to run a container based on the image under the Docker runtime. |
| `org.label-schema.name`                   | buildarg `DOCKER_IMAGE` |
| `org.label-schema.schema-version`         | This label SHOULD be present to indicate the version of Label Schema in use. |
| `org.label-schema.url`                    | URL of website with more information about the product or service provided by the container. |
| `org.label-schema.vcs-ref`                | buildarg `VCS_REF` |
| `org.label-schema.vcs-url`                | URL for the source code under version control from which this container image was built. |
| `org.label-schema.version`                | Release identifier for the contents of the image. |
| `image.target.platform`                   | Platform of the build result. eg. `linux/amd64`, `linux/arm/v7`, `windows/amd64`. |
| `image.target.os`                         | OS component of `image.target.platform`. |
| `image.target.arch`                       | Architecture component of `image.target.platform`. |
| `versions.headers-more-nginx-module`      | The version of [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module) used. |
| `versions.lua`                            | The version of [Lua](https://www.lua.org/) to use. |
| `versions.luarocks`                       | The version of [LuaRocks](https://luarocks.org/) to use. |
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
| `versions.lua-upstream`                   | The version of [lua-upstream-nginx-module](https://github.com/openresty/lua-upstream-nginx-module) used. |
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

## nginx-lua different distro

![Benchmark Mean Requests per Second](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:226.12|226.23|217.74|222.27|216.50&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=180,250&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Requests+per+second&chxl=0:|reqs/sec&chxr=1,180,250,20&chxt=x,y)
![Benchmark Median Response Time](http://chart.googleapis.com/chart?&chco=0D597F,9CCE28,CD2B4A,3D6EB4,DD4915&chd=t:9.86|9.93|10.4|10.06|10.3&chdl=alpine|centos|debian|fedora|ubuntu&chdlp=bvr&chds=9.5,10&chma=20,20,20,20&chs=300x200&cht=bvg&chts=000000,15,l&chtt=Median+Response+Time&chxl=0:|msec&chxr=1,9.5,10,0.1&chxt=x,y)

More details about the benchark can be found in [docs/benchmarks/distros](docs/benchmarks/distros).

## Extras

Extract of [openresty/lua-nginx-module](https://github.com/openresty/lua-nginx-module) under [BSD license](https://github.com/openresty/lua-nginx-module#copyright-and-license).

- [LUA Nginx Module - Known Issues](docs/lua-nginx-module/known-issues.md)
- [LUA Nginx Module - Directives](docs/lua-nginx-module/directives.md)
- [Nginx API for Lua](docs/lua-nginx-module/nginx-api-for-lua.md)

![Lua Nginx Modules Directives](docs/lua-nginx-module/lua_nginx_modules_directives.png)

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

More examples are available in the directory [`docs/examples`](https://github.com/fabiocicerchia/nginx-lua/blob/main/docs/examples)

## Contributing

A [dedicated section](docs/CONTRIBUTING.mg) is available to know how to contribute to this project.

## License

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

- [Nginx License](https://nginx.org/LICENSE)
- [Lua License](https://www.lua.org/license.html)
- [OpenResty License](https://github.com/openresty/openresty#copyright--license)

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ffabiocicerchia%2Fnginx-lua.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Ffabiocicerchia%2Fnginx-lua?ref=badge_large)

### `fabiocicerchia/nginx-lua`

MIT License

Copyright (c) 2022 Fabio Cicerchia <info@fabiocicerchia.it>

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
