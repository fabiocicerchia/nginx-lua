# nginx-lua

![Docker stars](https://img.shields.io/docker/stars/fabiocicerchia/nginx-lua.png "Docker stars")
![Docker pulls](https://img.shields.io/docker/pulls/fabiocicerchia/nginx-lua.png "Docker pulls")
![Docker](https://github.com/fabiocicerchia/nginx-lua/workflows/Docker/badge.svg)
[![](https://images.microbadger.com/badges/image/fabiocicerchia/nginx-lua.svg)](https://microbadger.com/#/images/fabiocicerchia/nginx-lua "microbadger.com")

Nginx 1.19+ with LUA support based on Alpine Linux.

## Supported Tags and Respective Dockerfile Links

 - [`1.19.0`, `1`, `1.19`, `latest`](https://github.com/fabiocicerchia/nginx-lua/blob/master/Dockerfile)

## Specs

 - [nginx](https://nginx.org/en/download.html)
 - [OpenResty's Branch of LuaJIT 2](https://github.com/openresty/luajit2)
 - [Embed the Power of Lua into NGINX HTTP servers](https://github.com/openresty/lua-nginx-module)
 - [New FFI-based API for lua-nginx-module](https://github.com/openresty/lua-resty-core)
 - [Lua-land LRU Cache based on LuaJIT FFI](https://github.com/openresty/lua-resty-lrucache)
 - [Nginx Development Kit](https://github.com/vision5/ngx_devel_kit)

## Example

```
lua_package_path "/usr/local/lib/lua/?.lua;;";

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
