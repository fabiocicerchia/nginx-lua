# Nginx API for Lua

- [Introduction](#introduction)
- [ngx.arg](#ngxarg)
- [ngx.var.VARIABLE](#ngxvarvariable)
- [Core constants](#core-constants)
- [HTTP method constants](#http-method-constants)
- [HTTP status constants](#http-status-constants)
- [Nginx log level constants](#nginx-log-level-constants)
- [print](#print)
- [ngx.ctx](#ngxctx)
- [ngx.location.capture](#ngxlocationcapture)
- [ngx.location.capture_multi](#ngxlocationcapture_multi)
- [ngx.status](#ngxstatus)
- [ngx.header.HEADER](#ngxheaderheader)
- [ngx.resp.get_headers](#ngxrespget_headers)
- [ngx.req.is_internal](#ngxreqis_internal)
- [ngx.req.start_time](#ngxreqstart_time)
- [ngx.req.http_version](#ngxreqhttp_version)
- [ngx.req.raw_header](#ngxreqraw_header)
- [ngx.req.get_method](#ngxreqget_method)
- [ngx.req.set_method](#ngxreqset_method)
- [ngx.req.set_uri](#ngxreqset_uri)
- [ngx.req.set_uri_args](#ngxreqset_uri_args)
- [ngx.req.get_uri_args](#ngxreqget_uri_args)
- [ngx.req.get_post_args](#ngxreqget_post_args)
- [ngx.req.get_headers](#ngxreqget_headers)
- [ngx.req.set_header](#ngxreqset_header)
- [ngx.req.clear_header](#ngxreqclear_header)
- [ngx.req.read_body](#ngxreqread_body)
- [ngx.req.discard_body](#ngxreqdiscard_body)
- [ngx.req.get_body_data](#ngxreqget_body_data)
- [ngx.req.get_body_file](#ngxreqget_body_file)
- [ngx.req.set_body_data](#ngxreqset_body_data)
- [ngx.req.set_body_file](#ngxreqset_body_file)
- [ngx.req.init_body](#ngxreqinit_body)
- [ngx.req.append_body](#ngxreqappend_body)
- [ngx.req.finish_body](#ngxreqfinish_body)
- [ngx.req.socket](#ngxreqsocket)
- [ngx.exec](#ngxexec)
- [ngx.redirect](#ngxredirect)
- [ngx.send_headers](#ngxsend_headers)
- [ngx.headers_sent](#ngxheaders_sent)
- [ngx.print](#ngxprint)
- [ngx.say](#ngxsay)
- [ngx.log](#ngxlog)
- [ngx.flush](#ngxflush)
- [ngx.exit](#ngxexit)
- [ngx.eof](#ngxeof)
- [ngx.sleep](#ngxsleep)
- [ngx.escape_uri](#ngxescape_uri)
- [ngx.unescape_uri](#ngxunescape_uri)
- [ngx.encode_args](#ngxencode_args)
- [ngx.decode_args](#ngxdecode_args)
- [ngx.encode_base64](#ngxencode_base64)
- [ngx.decode_base64](#ngxdecode_base64)
- [ngx.crc32_short](#ngxcrc32_short)
- [ngx.crc32_long](#ngxcrc32_long)
- [ngx.hmac_sha1](#ngxhmac_sha1)
- [ngx.md5](#ngxmd5)
- [ngx.md5_bin](#ngxmd5_bin)
- [ngx.sha1_bin](#ngxsha1_bin)
- [ngx.quote_sql_str](#ngxquote_sql_str)
- [ngx.today](#ngxtoday)
- [ngx.time](#ngxtime)
- [ngx.now](#ngxnow)
- [ngx.update_time](#ngxupdate_time)
- [ngx.localtime](#ngxlocaltime)
- [ngx.utctime](#ngxutctime)
- [ngx.cookie_time](#ngxcookie_time)
- [ngx.http_time](#ngxhttp_time)
- [ngx.parse_http_time](#ngxparse_http_time)
- [ngx.is_subrequest](#ngxis_subrequest)
- [ngx.re.match](#ngxrematch)
- [ngx.re.find](#ngxrefind)
- [ngx.re.gmatch](#ngxregmatch)
- [ngx.re.sub](#ngxresub)
- [ngx.re.gsub](#ngxregsub)
- [ngx.shared.DICT](#ngxshareddict)
- [ngx.shared.DICT.get](#ngxshareddictget)
- [ngx.shared.DICT.get_stale](#ngxshareddictget_stale)
- [ngx.shared.DICT.set](#ngxshareddictset)
- [ngx.shared.DICT.safe_set](#ngxshareddictsafe_set)
- [ngx.shared.DICT.add](#ngxshareddictadd)
- [ngx.shared.DICT.safe_add](#ngxshareddictsafe_add)
- [ngx.shared.DICT.replace](#ngxshareddictreplace)
- [ngx.shared.DICT.delete](#ngxshareddictdelete)
- [ngx.shared.DICT.incr](#ngxshareddictincr)
- [ngx.shared.DICT.lpush](#ngxshareddictlpush)
- [ngx.shared.DICT.rpush](#ngxshareddictrpush)
- [ngx.shared.DICT.lpop](#ngxshareddictlpop)
- [ngx.shared.DICT.rpop](#ngxshareddictrpop)
- [ngx.shared.DICT.llen](#ngxshareddictllen)
- [ngx.shared.DICT.ttl](#ngxshareddictttl)
- [ngx.shared.DICT.expire](#ngxshareddictexpire)
- [ngx.shared.DICT.flush_all](#ngxshareddictflush_all)
- [ngx.shared.DICT.flush_expired](#ngxshareddictflush_expired)
- [ngx.shared.DICT.get_keys](#ngxshareddictget_keys)
- [ngx.shared.DICT.capacity](#ngxshareddictcapacity)
- [ngx.shared.DICT.free_space](#ngxshareddictfree_space)
- [ngx.socket.udp](#ngxsocketudp)
- [udpsock:setpeername](#udpsocksetpeername)
- [udpsock:send](#udpsocksend)
- [udpsock:receive](#udpsockreceive)
- [udpsock:close](#udpsockclose)
- [udpsock:settimeout](#udpsocksettimeout)
- [ngx.socket.stream](#ngxsocketstream)
- [ngx.socket.tcp](#ngxsockettcp)
- [tcpsock:connect](#tcpsockconnect)
- [tcpsock:sslhandshake](#tcpsocksslhandshake)
- [tcpsock:send](#tcpsocksend)
- [tcpsock:receive](#tcpsockreceive)
- [tcpsock:receiveany](#tcpsockreceiveany)
- [tcpsock:receiveuntil](#tcpsockreceiveuntil)
- [tcpsock:close](#tcpsockclose)
- [tcpsock:settimeout](#tcpsocksettimeout)
- [tcpsock:settimeouts](#tcpsocksettimeouts)
- [tcpsock:setoption](#tcpsocksetoption)
- [tcpsock:setkeepalive](#tcpsocksetkeepalive)
- [tcpsock:getreusedtimes](#tcpsockgetreusedtimes)
- [ngx.socket.connect](#ngxsocketconnect)
- [ngx.get_phase](#ngxget_phase)
- [ngx.thread.spawn](#ngxthreadspawn)
- [ngx.thread.wait](#ngxthreadwait)
- [ngx.thread.kill](#ngxthreadkill)
- [ngx.on_abort](#ngxon_abort)
- [ngx.timer.at](#ngxtimerat)
- [ngx.timer.every](#ngxtimerevery)
- [ngx.timer.running_count](#ngxtimerrunning_count)
- [ngx.timer.pending_count](#ngxtimerpending_count)
- [ngx.config.subsystem](#ngxconfigsubsystem)
- [ngx.config.debug](#ngxconfigdebug)
- [ngx.config.prefix](#ngxconfigprefix)
- [ngx.config.nginx_version](#ngxconfignginx_version)
- [ngx.config.nginx_configure](#ngxconfignginx_configure)
- [ngx.config.ngx_lua_version](#ngxconfigngx_lua_version)
- [ngx.worker.exiting](#ngxworkerexiting)
- [ngx.worker.pid](#ngxworkerpid)
- [ngx.worker.count](#ngxworkercount)
- [ngx.worker.id](#ngxworkerid)
- [ngx.semaphore](#ngxsemaphore)
- [ngx.balancer](#ngxbalancer)
- [ngx.ssl](#ngxssl)
- [ngx.ocsp](#ngxocsp)
- [ndk.set_var.DIRECTIVE](#ndkset_vardirective)
- [coroutine.create](#coroutinecreate)
- [coroutine.resume](#coroutineresume)
- [coroutine.yield](#coroutineyield)
- [coroutine.wrap](#coroutinewrap)
- [coroutine.running](#coroutinerunning)
- [coroutine.status](#coroutinestatus)

[Back to TOC](#table-of-contents)

## Introduction

The various `*_by_lua`, `*_by_lua_block` and `*_by_lua_file` configuration directives serve as gateways to the Lua API within the `nginx.conf` file. The Nginx Lua API described below can only be called within the user Lua code run in the context of these configuration directives.

The API is exposed to Lua in the form of two standard packages `ngx` and `ndk`. These packages are in the default global scope within ngx_lua and are always available within ngx_lua directives.

The packages can be introduced into external Lua modules like this:

```lua

 local say = ngx.say

 local _M = {}

 function _M.foo(a)
     say(a)
 end

 return _M
```

Use of the [package.seeall](https://www.lua.org/manual/5.1/manual.html#pdf-package.seeall) flag is strongly discouraged due to its various bad side-effects.

It is also possible to directly require the packages in external Lua modules:

```lua

 local ngx = require "ngx"
 local ndk = require "ndk"
```

The ability to require these packages was introduced in the `v0.2.1rc19` release.

Network I/O operations in user code should only be done through the Nginx Lua API calls as the Nginx event loop may be blocked and performance drop off dramatically otherwise. Disk operations with relatively small amount of data can be done using the standard Lua `io` library but huge file reading and writing should be avoided wherever possible as they may block the Nginx process significantly. Delegating all network and disk I/O operations to Nginx's subrequests (via the [ngx.location.capture](#ngxlocationcapture) method and similar) is strongly recommended for maximum performance.

## ngx.arg

**syntax:** _val = ngx.arg\[index\]_

**context:** _set_by_lua\*, body_filter_by_lua\*_

When this is used in the context of the [set_by_lua\*](#set_by_lua) directives, this table is read-only and holds the input arguments to the config directives:

```lua

 value = ngx.arg[n]
```

Here is an example

```nginx

 location /foo {
     set $a 32;
     set $b 56;

     set_by_lua $sum
         'return tonumber(ngx.arg[1]) + tonumber(ngx.arg[2])'
         $a $b;

     echo $sum;
 }
```

that writes out `88`, the sum of `32` and `56`.

When this table is used in the context of [body_filter_by_lua\*](#body_filter_by_lua), the first element holds the input data chunk to the output filter code and the second element holds the boolean flag for the "eof" flag indicating the end of the whole output data stream.

The data chunk and "eof" flag passed to the downstream Nginx output filters can also be overridden by assigning values directly to the corresponding table elements. When setting `nil` or an empty Lua string value to `ngx.arg[1]`, no data chunk will be passed to the downstream Nginx output filters at all.

## ngx.var.VARIABLE

**syntax:** _ngx.var.VAR_NAME_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, balancer_by_lua\*_

Read and write Nginx variable values.

```nginx

 value = ngx.var.some_nginx_variable_name
 ngx.var.some_nginx_variable_name = value
```

Note that only already defined Nginx variables can be written to.
For example:

```nginx

 location /foo {
     set $my_var ''; # this line is required to create $my_var at config time
     content_by_lua_block {
         ngx.var.my_var = 123
         ...
     }
 }
```

That is, Nginx variables cannot be created on-the-fly.

Some special Nginx variables like `$args` and `$limit_rate` can be assigned a value,
many others are not, like `$query_string`, `$arg_PARAMETER`, and `$http_NAME`.

Nginx regex group capturing variables `$1`, `$2`, `$3`, and etc, can be read by this
interface as well, by writing `ngx.var[1]`, `ngx.var[2]`, `ngx.var[3]`, and etc.

Setting `ngx.var.Foo` to a `nil` value will unset the `$Foo` Nginx variable.

```lua

 ngx.var.args = nil
```

**CAUTION** When reading from an Nginx variable, Nginx will allocate memory in the per-request memory pool which is freed only at request termination. So when you need to read from an Nginx variable repeatedly in your Lua code, cache the Nginx variable value to your own Lua variable, for example,

```lua

 local val = ngx.var.some_var
 --- use the val repeatedly later
```

to prevent (temporary) memory leaking within the current request's lifetime. Another way of caching the result is to use the [ngx.ctx](#ngxctx) table.

Undefined Nginx variables are evaluated to `nil` while uninitialized (but defined) Nginx variables are evaluated to an empty Lua string.

This API requires a relatively expensive metamethod call and it is recommended to avoid using it on hot code paths.

## Core constants

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, \*log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

```lua

   ngx.OK (0)
   ngx.ERROR (-1)
   ngx.AGAIN (-2)
   ngx.DONE (-4)
   ngx.DECLINED (-5)
```

Note that only three of these constants are utilized by the [Nginx API for Lua](#nginx-api-for-lua) (i.e., [ngx.exit](#ngxexit) accepts `ngx.OK`, `ngx.ERROR`, and `ngx.DECLINED` as input).

```lua

   ngx.null
```

The `ngx.null` constant is a `NULL` light userdata usually used to represent nil values in Lua tables etc and is similar to the [lua-cjson](http://www.kyne.com.au/~mark/software/lua-cjson.php) library's `cjson.null` constant. This constant was first introduced in the `v0.5.0rc5` release.

The `ngx.DECLINED` constant was first introduced in the `v0.5.0rc19` release.

## HTTP method constants

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

```default
ngx.HTTP_GET
ngx.HTTP_HEAD
ngx.HTTP_PUT
ngx.HTTP_POST
ngx.HTTP_DELETE
ngx.HTTP_OPTIONS   (added in the v0.5.0rc24 release)
ngx.HTTP_MKCOL     (added in the v0.8.2 release)
ngx.HTTP_COPY      (added in the v0.8.2 release)
ngx.HTTP_MOVE      (added in the v0.8.2 release)
ngx.HTTP_PROPFIND  (added in the v0.8.2 release)
ngx.HTTP_PROPPATCH (added in the v0.8.2 release)
ngx.HTTP_LOCK      (added in the v0.8.2 release)
ngx.HTTP_UNLOCK    (added in the v0.8.2 release)
ngx.HTTP_PATCH     (added in the v0.8.2 release)
ngx.HTTP_TRACE     (added in the v0.8.2 release)
```

These constants are usually used in [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi) method calls.

## HTTP status constants

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

```nginx

   value = ngx.HTTP_CONTINUE (100) (first added in the v0.9.20 release)
   value = ngx.HTTP_SWITCHING_PROTOCOLS (101) (first added in the v0.9.20 release)
   value = ngx.HTTP_OK (200)
   value = ngx.HTTP_CREATED (201)
   value = ngx.HTTP_ACCEPTED (202) (first added in the v0.9.20 release)
   value = ngx.HTTP_NO_CONTENT (204) (first added in the v0.9.20 release)
   value = ngx.HTTP_PARTIAL_CONTENT (206) (first added in the v0.9.20 release)
   value = ngx.HTTP_SPECIAL_RESPONSE (300)
   value = ngx.HTTP_MOVED_PERMANENTLY (301)
   value = ngx.HTTP_MOVED_TEMPORARILY (302)
   value = ngx.HTTP_SEE_OTHER (303)
   value = ngx.HTTP_NOT_MODIFIED (304)
   value = ngx.HTTP_TEMPORARY_REDIRECT (307) (first added in the v0.9.20 release)
   value = ngx.HTTP_PERMANENT_REDIRECT (308)
   value = ngx.HTTP_BAD_REQUEST (400)
   value = ngx.HTTP_UNAUTHORIZED (401)
   value = ngx.HTTP_PAYMENT_REQUIRED (402) (first added in the v0.9.20 release)
   value = ngx.HTTP_FORBIDDEN (403)
   value = ngx.HTTP_NOT_FOUND (404)
   value = ngx.HTTP_NOT_ALLOWED (405)
   value = ngx.HTTP_NOT_ACCEPTABLE (406) (first added in the v0.9.20 release)
   value = ngx.HTTP_REQUEST_TIMEOUT (408) (first added in the v0.9.20 release)
   value = ngx.HTTP_CONFLICT (409) (first added in the v0.9.20 release)
   value = ngx.HTTP_GONE (410)
   value = ngx.HTTP_UPGRADE_REQUIRED (426) (first added in the v0.9.20 release)
   value = ngx.HTTP_TOO_MANY_REQUESTS (429) (first added in the v0.9.20 release)
   value = ngx.HTTP_CLOSE (444) (first added in the v0.9.20 release)
   value = ngx.HTTP_ILLEGAL (451) (first added in the v0.9.20 release)
   value = ngx.HTTP_INTERNAL_SERVER_ERROR (500)
   value = ngx.HTTP_METHOD_NOT_IMPLEMENTED (501)
   value = ngx.HTTP_BAD_GATEWAY (502) (first added in the v0.9.20 release)
   value = ngx.HTTP_SERVICE_UNAVAILABLE (503)
   value = ngx.HTTP_GATEWAY_TIMEOUT (504) (first added in the v0.3.1rc38 release)
   value = ngx.HTTP_VERSION_NOT_SUPPORTED (505) (first added in the v0.9.20 release)
   value = ngx.HTTP_INSUFFICIENT_STORAGE (507) (first added in the v0.9.20 release)
```

## Nginx log level constants

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

```lua

   ngx.STDERR
   ngx.EMERG
   ngx.ALERT
   ngx.CRIT
   ngx.ERR
   ngx.WARN
   ngx.NOTICE
   ngx.INFO
   ngx.DEBUG
```

These constants are usually used by the [ngx.log](#ngxlog) method.

## print

**syntax:** _print(...)_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Writes argument values into the Nginx `error.log` file with the `ngx.NOTICE` log level.

It is equivalent to

```lua

 ngx.log(ngx.NOTICE, ...)
```

Lua `nil` arguments are accepted and result in literal `"nil"` strings while Lua booleans result in literal `"true"` or `"false"` strings. And the `ngx.null` constant will yield the `"null"` string output.

There is a hard coded `2048` byte limitation on error message lengths in the Nginx core. This limit includes trailing newlines and leading time stamps. If the message size exceeds this limit, Nginx will truncate the message text accordingly. This limit can be manually modified by editing the `NGX_MAX_ERROR_STR` macro definition in the `src/core/ngx_log.h` file in the Nginx source tree.

## ngx.ctx

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, exit_worker_by_lua\*_

This table can be used to store per-request Lua context data and has a life time identical to the current request (as with the Nginx variables).

Consider the following example,

```nginx

 location /test {
     rewrite_by_lua_block {
         ngx.ctx.foo = 76
     }
     access_by_lua_block {
         ngx.ctx.foo = ngx.ctx.foo + 3
     }
     content_by_lua_block {
         ngx.say(ngx.ctx.foo)
     }
 }
```

Then `GET /test` will yield the output

```bash

 79
```

That is, the `ngx.ctx.foo` entry persists across the rewrite, access, and content phases of a request.

Every request, including subrequests, has its own copy of the table. For example:

```nginx

 location /sub {
     content_by_lua_block {
         ngx.say("sub pre: ", ngx.ctx.blah)
         ngx.ctx.blah = 32
         ngx.say("sub post: ", ngx.ctx.blah)
     }
 }

 location /main {
     content_by_lua_block {
         ngx.ctx.blah = 73
         ngx.say("main pre: ", ngx.ctx.blah)
         local res = ngx.location.capture("/sub")
         ngx.print(res.body)
         ngx.say("main post: ", ngx.ctx.blah)
     }
 }
```

Then `GET /main` will give the output

```bash

 main pre: 73
 sub pre: nil
 sub post: 32
 main post: 73
```

Here, modification of the `ngx.ctx.blah` entry in the subrequest does not affect the one in the parent request. This is because they have two separate versions of `ngx.ctx.blah`.

Internal redirection will destroy the original request `ngx.ctx` data (if any) and the new request will have an empty `ngx.ctx` table. For instance,

```nginx

 location /new {
     content_by_lua_block {
         ngx.say(ngx.ctx.foo)
     }
 }

 location /orig {
     content_by_lua_block {
         ngx.ctx.foo = "hello"
         ngx.exec("/new")
     }
 }
```

Then `GET /orig` will give

```bash

 nil
```

rather than the original `"hello"` value.

Because HTTP request is created after SSL handshake, the `ngx.ctx` created
in [ssl_certificate_by_lua\*](#ssl_certificate_by_lua), [ssl_session_store_by_lua\*](#ssl_session_store_by_lua) and [ssl_session_fetch_by_lua\*](#ssl_session_fetch_by_lua)
is not available in the following phases like [rewrite_by_lua\*](#rewrite_by_lua).

Since `dev`, the `ngx.ctx` created during a SSL handshake
will be inherited by the requests which share the same TCP connection established by the handshake.
Note that overwrite values in `ngx.ctx` in the http request phases (like `rewrite_by_lua*`) will only take affect in the current http request.

Arbitrary data values, including Lua closures and nested tables, can be inserted into this "magic" table. It also allows the registration of custom meta methods.

Overriding `ngx.ctx` with a new Lua table is also supported, for example,

```lua

 ngx.ctx = { foo = 32, bar = 54 }
```

When being used in the context of [init_worker_by_lua\*](#init_worker_by_lua), this table just has the same lifetime of the current Lua handler.

The `ngx.ctx` lookup requires relatively expensive metamethod calls and it is much slower than explicitly passing per-request data along by your own function arguments. So do not abuse this API for saving your own function arguments because it usually has quite some performance impact.

Because of the metamethod magic, never "local" the `ngx.ctx` table outside your Lua function scope on the Lua module level due to [worker-level data sharing](#data-sharing-within-an-nginx-worker). For example, the following is bad:

```lua

 -- mymodule.lua
 local _M = {}

 -- the following line is bad since ngx.ctx is a per-request
 -- data while this <code>ctx</code> variable is on the Lua module level
 -- and thus is per-nginx-worker.
 local ctx = ngx.ctx

 function _M.main()
     ctx.foo = "bar"
 end

 return _M
```

Use the following instead:

```lua

 -- mymodule.lua
 local _M = {}

 function _M.main(ctx)
     ctx.foo = "bar"
 end

 return _M
```

That is, let the caller pass the `ctx` table explicitly via a function argument.

## ngx.location.capture

**syntax:** _res = ngx.location.capture(uri, options?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Issues a synchronous but still non-blocking _Nginx Subrequest_ using `uri`.

Nginx's subrequests provide a powerful way to make non-blocking internal requests to other locations configured with disk file directory or _any_ other Nginx C modules like `ngx_proxy`, `ngx_fastcgi`, `ngx_memc`,
`ngx_postgres`, `ngx_drizzle`, and even ngx_lua itself and etc etc etc.

Also note that subrequests just mimic the HTTP interface but there is _no_ extra HTTP/TCP traffic _nor_ IPC involved. Everything works internally, efficiently, on the C level.

Subrequests are completely different from HTTP 301/302 redirection (via [ngx.redirect](#ngxredirect)) and internal redirection (via [ngx.exec](#ngxexec)).

You should always read the request body (by either calling [ngx.req.read_body](#ngxreqread_body) or configuring [lua_need_request_body](#lua_need_request_body) on) before initiating a subrequest.

This API function (as well as [ngx.location.capture_multi](#ngxlocationcapture_multi)) always buffers the whole response body of the subrequest in memory. Thus, you should use [cosockets](#ngxsockettcp)
and streaming processing instead if you have to handle large subrequest responses.

Here is a basic example:

```lua

 res = ngx.location.capture(uri)
```

Returns a Lua table with 4 slots: `res.status`, `res.header`, `res.body`, and `res.truncated`.

`res.status` holds the response status code for the subrequest response.

`res.header` holds all the response headers of the
subrequest and it is a normal Lua table. For multi-value response headers,
the value is a Lua (array) table that holds all the values in the order that
they appear. For instance, if the subrequest response headers contain the following
lines:

```bash

 Set-Cookie: a=3
 Set-Cookie: foo=bar
 Set-Cookie: baz=blah
```

Then `res.header["Set-Cookie"]` will be evaluated to the table value
`{"a=3", "foo=bar", "baz=blah"}`.

`res.body` holds the subrequest's response body data, which might be truncated. You always need to check the `res.truncated` boolean flag to see if `res.body` contains truncated data. The data truncation here can only be caused by those unrecoverable errors in your subrequests like the cases that the remote end aborts the connection prematurely in the middle of the response body data stream or a read timeout happens when your subrequest is receiving the response body data from the remote.

URI query strings can be concatenated to URI itself, for instance,

```lua

 res = ngx.location.capture('/foo/bar?a=3&b=4')
```

Named locations like `@foo` are not allowed due to a limitation in
the Nginx core. Use normal locations combined with the `internal` directive to
prepare internal-only locations.

An optional option table can be fed as the second
argument, which supports the options:

- `method`
  specify the subrequest's request method, which only accepts constants like `ngx.HTTP_POST`.
- `body`
  specify the subrequest's request body (string value only).
- `args`
  specify the subrequest's URI query arguments (both string value and Lua tables are accepted)
- `ctx`
  specify a Lua table to be the [ngx.ctx](#ngxctx) table for the subrequest. It can be the current request's [ngx.ctx](#ngxctx) table, which effectively makes the parent and its subrequest to share exactly the same context table. This option was first introduced in the `v0.3.1rc25` release.
- `vars`
  take a Lua table which holds the values to set the specified Nginx variables in the subrequest as this option's value. This option was first introduced in the `v0.3.1rc31` release.
- `copy_all_vars`
  specify whether to copy over all the Nginx variable values of the current request to the subrequest in question. modifications of the Nginx variables in the subrequest will not affect the current (parent) request. This option was first introduced in the `v0.3.1rc31` release.
- `share_all_vars`
  specify whether to share all the Nginx variables of the subrequest with the current (parent) request. modifications of the Nginx variables in the subrequest will affect the current (parent) request. Enabling this option may lead to hard-to-debug issues due to bad side-effects and is considered bad and harmful. Only enable this option when you completely know what you are doing.
- `always_forward_body`
  when set to true, the current (parent) request's request body will always be forwarded to the subrequest being created if the `body` option is not specified. The request body read by either [ngx.req.read_body()](#ngxreqread_body) or [lua_need_request_body on](#lua_need_request_body) will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest (no matter the request body data is buffered in memory buffers or temporary files). By default, this option is `false` and when the `body` option is not specified, the request body of the current (parent) request is only forwarded when the subrequest takes the `PUT` or `POST` request method.

Issuing a POST subrequest, for example, can be done as follows

```lua

 res = ngx.location.capture(
     '/foo/bar',
     { method = ngx.HTTP_POST, body = 'hello, world' }
 )
```

See HTTP method constants methods other than POST.
The `method` option is `ngx.HTTP_GET` by default.

The `args` option can specify extra URI arguments, for instance,

```lua

 ngx.location.capture('/foo?a=1',
     { args = { b = 3, c = ':' } }
 )
```

is equivalent to

```lua

 ngx.location.capture('/foo?a=1&b=3&c=%3a')
```

that is, this method will escape argument keys and values according to URI rules and
concatenate them together into a complete query string. The format for the Lua table passed as the `args` argument is identical to the format used in the [ngx.encode_args](#ngxencode_args) method.

The `args` option can also take plain query strings:

```lua

 ngx.location.capture('/foo?a=1',
     { args = 'b=3&c=%3a' }
 )
```

This is functionally identical to the previous examples.

The `share_all_vars` option controls whether to share Nginx variables among the current request and its subrequests.
If this option is set to `true`, then the current request and associated subrequests will share the same Nginx variable scope. Hence, changes to Nginx variables made by a subrequest will affect the current request.

Care should be taken in using this option as variable scope sharing can have unexpected side effects. The `args`, `vars`, or `copy_all_vars` options are generally preferable instead.

This option is set to `false` by default

```nginx

 location /other {
     set $dog "$dog world";
     echo "$uri dog: $dog";
 }

 location /lua {
     set $dog 'hello';
     content_by_lua_block {
         res = ngx.location.capture("/other",
             { share_all_vars = true })

         ngx.print(res.body)
         ngx.say(ngx.var.uri, ": ", ngx.var.dog)
     }
 }
```

Accessing location `/lua` gives

```default
/other dog: hello world
/lua: hello world
```

The `copy_all_vars` option provides a copy of the parent request's Nginx variables to subrequests when such subrequests are issued. Changes made to these variables by such subrequests will not affect the parent request or any other subrequests sharing the parent request's variables.

```nginx

 location /other {
     set $dog "$dog world";
     echo "$uri dog: $dog";
 }

 location /lua {
     set $dog 'hello';
     content_by_lua_block {
         res = ngx.location.capture("/other",
             { copy_all_vars = true })

         ngx.print(res.body)
         ngx.say(ngx.var.uri, ": ", ngx.var.dog)
     }
 }
```

Request `GET /lua` will give the output

```default
/other dog: hello world
/lua: hello
```

Note that if both `share_all_vars` and `copy_all_vars` are set to true, then `share_all_vars` takes precedence.

In addition to the two settings above, it is possible to specify
values for variables in the subrequest using the `vars` option. These
variables are set after the sharing or copying of variables has been
evaluated, and provides a more efficient method of passing specific
values to a subrequest over encoding them as URL arguments and
unescaping them in the Nginx config file.

```nginx

 location /other {
     content_by_lua_block {
         ngx.say("dog = ", ngx.var.dog)
         ngx.say("cat = ", ngx.var.cat)
     }
 }

 location /lua {
     set $dog '';
     set $cat '';
     content_by_lua_block {
         res = ngx.location.capture("/other",
             { vars = { dog = "hello", cat = 32 }})

         ngx.print(res.body)
     }
 }
```

Accessing `/lua` will yield the output

```default
dog = hello
cat = 32
```

The `ctx` option can be used to specify a custom Lua table to serve as the [ngx.ctx](#ngxctx) table for the subrequest.

```nginx

 location /sub {
     content_by_lua_block {
         ngx.ctx.foo = "bar";
     }
 }
 location /lua {
     content_by_lua_block {
         local ctx = {}
         res = ngx.location.capture("/sub", { ctx = ctx })

         ngx.say(ctx.foo)
         ngx.say(ngx.ctx.foo)
     }
 }
```

Then request `GET /lua` gives

```default
bar
nil
```

It is also possible to use this `ctx` option to share the same [ngx.ctx](#ngxctx) table between the current (parent) request and the subrequest:

```nginx

 location /sub {
     content_by_lua_block {
         ngx.ctx.foo = "bar"
     }
 }
 location /lua {
     content_by_lua_block {
         res = ngx.location.capture("/sub", { ctx = ngx.ctx })
         ngx.say(ngx.ctx.foo)
     }
 }
```

Request `GET /lua` yields the output

```default
bar
```

Note that subrequests issued by [ngx.location.capture](#ngxlocationcapture) inherit all the
request headers of the current request by default and that this may have unexpected side effects on the
subrequest responses. For example, when using the standard `ngx_proxy` module to serve
subrequests, an "Accept-Encoding: gzip" header in the main request may result
in gzipped responses that cannot be handled properly in Lua code. Original request headers should be ignored by setting
[proxy_pass_request_headers](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_request_headers) to `off` in subrequest locations.

When the `body` option is not specified and the `always_forward_body` option is false (the default value), the `POST` and `PUT` subrequests will inherit the request bodies of the parent request (if any).

There is a hard-coded upper limit on the number of subrequests possible for every main request. In older versions of Nginx, the limit was `50` concurrent subrequests and in more recent versions, Nginx `1.9.5` onwards, the same limit is changed to limit the depth of recursive subrequests. When this limit is exceeded, the following error message is added to the `error.log` file:

```default
[error] 13983#0: *1 subrequests cycle while processing "/uri"
```

The limit can be manually modified if required by editing the definition of the `NGX_HTTP_MAX_SUBREQUESTS` macro in the `nginx/src/http/ngx_http_request.h` file in the Nginx source tree.

Please also refer to restrictions on capturing locations configured by [subrequest directives of other modules](#locations-configured-by-subrequest-directives-of-other-modules).

## ngx.location.capture_multi

**syntax:** _res1, res2, ... = ngx.location.capture_multi({ {uri, options?}, {uri, options?}, ... })_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Just like [ngx.location.capture](#ngxlocationcapture), but supports multiple subrequests running in parallel.

This function issues several parallel subrequests specified by the input table and returns their results in the same order. For example,

```lua

 res1, res2, res3 = ngx.location.capture_multi{
     { "/foo", { args = "a=3&b=4" } },
     { "/bar" },
     { "/baz", { method = ngx.HTTP_POST, body = "hello" } },
 }

 if res1.status == ngx.HTTP_OK then
     ...
 end

 if res2.body == "BLAH" then
     ...
 end
```

This function will not return until all the subrequests terminate.
The total latency is the longest latency of the individual subrequests rather than the sum.

Lua tables can be used for both requests and responses when the number of subrequests to be issued is not known in advance:

```lua

 -- construct the requests table
 local reqs = {}
 table.insert(reqs, { "/mysql" })
 table.insert(reqs, { "/postgres" })
 table.insert(reqs, { "/redis" })
 table.insert(reqs, { "/memcached" })

 -- issue all the requests at once and wait until they all return
 local resps = { ngx.location.capture_multi(reqs) }

 -- loop over the responses table
 for i, resp in ipairs(resps) do
     -- process the response table "resp"
 end
```

The [ngx.location.capture](#ngxlocationcapture) function is just a special form
of this function. Logically speaking, the [ngx.location.capture](#ngxlocationcapture) can be implemented like this

```lua

 ngx.location.capture =
     function (uri, args)
         return ngx.location.capture_multi({ {uri, args} })
     end
```

Please also refer to restrictions on capturing locations configured by [subrequest directives of other modules](#locations-configured-by-subrequest-directives-of-other-modules).

## ngx.status

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Read and write the current request's response status. This should be called
before sending out the response headers.

```lua

 ngx.status = ngx.HTTP_CREATED
 status = ngx.status
```

Setting `ngx.status` after the response header is sent out has no effect but leaving an error message in your Nginx's error log file:

```default
attempt to set ngx.status after sending out response headers
```

## ngx.header.HEADER

**syntax:** _ngx.header.HEADER = VALUE_

**syntax:** _value = ngx.header.HEADER_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Set, add to, or clear the current request's `HEADER` response header that is to be sent.

Underscores (`_`) in the header names will be replaced by hyphens (`-`) by default. This transformation can be turned off via the [lua_transform_underscores_in_response_headers](#lua_transform_underscores_in_response_headers) directive.

The header names are matched case-insensitively.

```lua

 -- equivalent to ngx.header["Content-Type"] = 'text/plain'
 ngx.header.content_type = 'text/plain'

 ngx.header["X-My-Header"] = 'blah blah'
```

Multi-value headers can be set this way:

```lua

 ngx.header['Set-Cookie'] = {'a=32; path=/', 'b=4; path=/'}
```

will yield

```bash

 Set-Cookie: a=32; path=/
 Set-Cookie: b=4; path=/
```

in the response headers.

Only Lua tables are accepted (Only the last element in the table will take effect for standard headers such as `Content-Type` that only accept a single value).

```lua

 ngx.header.content_type = {'a', 'b'}
```

is equivalent to

```lua

 ngx.header.content_type = 'b'
```

Setting a slot to `nil` effectively removes it from the response headers:

```lua

 ngx.header["X-My-Header"] = nil
```

The same applies to assigning an empty table:

```lua

 ngx.header["X-My-Header"] = {}
```

Setting `ngx.header.HEADER` after sending out response headers (either explicitly with [ngx.send_headers](#ngxsend_headers) or implicitly with [ngx.print](#ngxprint) and similar) will log an error message.

Reading `ngx.header.HEADER` will return the value of the response header named `HEADER`.

Underscores (`_`) in the header names will also be replaced by dashes (`-`) and the header names will be matched case-insensitively. If the response header is not present at all, `nil` will be returned.

This is particularly useful in the context of [header_filter_by_lua\*](#header_filter_by_lua), for example,

```nginx

 location /test {
     set $footer '';

     proxy_pass http://some-backend;

     header_filter_by_lua_block {
         if ngx.header["X-My-Header"] == "blah" then
             ngx.var.footer = "some value"
         end
     }

     echo_after_body $footer;
 }
```

For multi-value headers, all of the values of header will be collected in order and returned as a Lua table. For example, response headers

```default
Foo: bar
Foo: baz
```

will result in

```lua

 {"bar", "baz"}
```

to be returned when reading `ngx.header.Foo`.

Note that `ngx.header` is not a normal Lua table and as such, it is not possible to iterate through it using the Lua `ipairs` function.

Note: this function throws a Lua error if `HEADER` or
`VALUE` contain unsafe characters (control characters).

For reading _request_ headers, use the [ngx.req.get_headers](#ngxreqget_headers) function instead.

## ngx.resp.get_headers

**syntax:** _headers, err = ngx.resp.get_headers(max_headers?, raw?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, balancer_by_lua\*_

Returns a Lua table holding all the current response headers for the current request.

```lua

 local h, err = ngx.resp.get_headers()

 if err == "truncated" then
     -- one can choose to ignore or reject the current response here
 end

 for k, v in pairs(h) do
     ...
 end
```

This function has the same signature as [ngx.req.get_headers](#ngxreqget_headers) except getting response headers instead of request headers.

Note that a maximum of 100 response headers are parsed by default (including those with the same name) and that additional response headers are silently discarded to guard against potential denial of service attacks. Since `v0.10.13`, when the limit is exceeded, it will return a second value which is the string `"truncated"`.

This API was first introduced in the `v0.9.5` release.

## ngx.req.is_internal

**syntax:** _is_internal = ngx.req.is_internal()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Returns a boolean indicating whether the current request is an "internal request", i.e.,
a request initiated from inside the current Nginx server instead of from the client side.

Subrequests are all internal requests and so are requests after internal redirects.

This API was first introduced in the `v0.9.20` release.

## ngx.req.start_time

**syntax:** _secs = ngx.req.start_time()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Returns a floating-point number representing the timestamp (including milliseconds as the decimal part) when the current request was created.

The following example emulates the `$request_time` variable value (provided by [ngx_http_log_module](http://nginx.org/en/docs/http/ngx_http_log_module.html)) in pure Lua:

```lua

 local request_time = ngx.now() - ngx.req.start_time()
```

This function was first introduced in the `v0.7.7` release.

See also [ngx.now](#ngxnow) and [ngx.update_time](#ngxupdate_time).

## ngx.req.http_version

**syntax:** _num = ngx.req.http_version()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*_

Returns the HTTP version number for the current request as a Lua number.

Current possible values are 2.0, 1.0, 1.1, and 0.9. Returns `nil` for unrecognized values.

This method was first introduced in the `v0.7.17` release.

## ngx.req.raw_header

**syntax:** _str = ngx.req.raw_header(no_request_line?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*_

Returns the original raw HTTP protocol header received by the Nginx server.

By default, the request line and trailing `CR LF` terminator will also be included. For example,

```lua

 ngx.print(ngx.req.raw_header())
```

gives something like this:

```default
GET /t HTTP/1.1
Host: localhost
Connection: close
Foo: bar
```

You can specify the optional
`no_request_line` argument as a `true` value to exclude the request line from the result. For example,

```lua

 ngx.print(ngx.req.raw_header(true))
```

outputs something like this:

```default
Host: localhost
Connection: close
Foo: bar
```

This method was first introduced in the `v0.7.17` release.

This method does not work in HTTP/2 requests yet.

## ngx.req.get_method

**syntax:** _method_name = ngx.req.get_method()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, balancer_by_lua\*, log_by_lua\*_

Retrieves the current request's request method name. Strings like `"GET"` and `"POST"` are returned instead of numerical [method constants](#http-method-constants).

If the current request is an Nginx subrequest, then the subrequest's method name will be returned.

This method was first introduced in the `v0.5.6` release.

See also [ngx.req.set_method](#ngxreqset_method).

## ngx.req.set_method

**syntax:** _ngx.req.set_method(method_id)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*_

Overrides the current request's request method with the `method_id` argument. Currently only numerical [method constants](#http-method-constants) are supported, like `ngx.HTTP_POST` and `ngx.HTTP_GET`.

If the current request is an Nginx subrequest, then the subrequest's method will be overridden.

This method was first introduced in the `v0.5.6` release.

See also [ngx.req.get_method](#ngxreqget_method).

## ngx.req.set_uri

**syntax:** _ngx.req.set_uri(uri, jump?, binary?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*_

Rewrite the current request's (parsed) URI by the `uri` argument. The `uri` argument must be a Lua string and cannot be of zero length, or a Lua exception will be thrown.

The optional boolean `jump` argument can trigger location rematch (or location jump) as [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)'s [rewrite](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directive, that is, when `jump` is `true` (default to `false`), this function will never return and it will tell Nginx to try re-searching locations with the new URI value at the later `post-rewrite` phase and jumping to the new location.

Location jump will not be triggered otherwise, and only the current request's URI will be modified, which is also the default behavior. This function will return but with no returned values when the `jump` argument is `false` or absent altogether.

For example, the following Nginx config snippet

```nginx

 rewrite ^ /foo last;
```

can be coded in Lua like this:

```lua

 ngx.req.set_uri("/foo", true)
```

Similarly, Nginx config

```nginx

 rewrite ^ /foo break;
```

can be coded in Lua as

```lua

 ngx.req.set_uri("/foo", false)
```

or equivalently,

```lua

 ngx.req.set_uri("/foo")
```

The `jump` argument can only be set to `true` in [rewrite_by_lua\*](#rewrite_by_lua). Use of jump in other contexts is prohibited and will throw out a Lua exception.

A more sophisticated example involving regex substitutions is as follows

```nginx

 location /test {
     rewrite_by_lua_block {
         local uri = ngx.re.sub(ngx.var.uri, "^/test/(.*)", "/$1", "o")
         ngx.req.set_uri(uri)
     }
     proxy_pass http://my_backend;
 }
```

which is functionally equivalent to

```nginx

 location /test {
     rewrite ^/test/(.*) /$1 break;
     proxy_pass http://my_backend;
 }
```

Note: this function throws a Lua error if the `uri` argument
contains unsafe characters (control characters).

Note that it is not possible to use this interface to rewrite URI arguments and that [ngx.req.set_uri_args](#ngxreqset_uri_args) should be used for this instead. For instance, Nginx config

```nginx

 rewrite ^ /foo?a=3? last;
```

can be coded as

```nginx

 ngx.req.set_uri_args("a=3")
 ngx.req.set_uri("/foo", true)
```

or

```nginx

 ngx.req.set_uri_args({a = 3})
 ngx.req.set_uri("/foo", true)
```

Starting from `0.10.16` of this module, this function accepts an
optional boolean `binary` argument to allow arbitrary binary URI
data. By default, this `binary` argument is false and this function
will throw out a Lua error such as the one below when the `uri`
argument contains any control characters (ASCII Code 0 ~ 0x08, 0x0A ~ 0x1F and 0x7F).

```default
[error] 23430#23430: *1 lua entry thread aborted: runtime error:
content_by_lua(nginx.conf:44):3: ngx.req.set_uri unsafe byte "0x00"
in "\x00foo" (maybe you want to set the 'binary' argument?)
```

This interface was first introduced in the `v0.3.1rc14` release.

## ngx.req.set_uri_args

**syntax:** _ngx.req.set_uri_args(args)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*_

Rewrite the current request's URI query arguments by the `args` argument. The `args` argument can be either a Lua string, as in

```lua

 ngx.req.set_uri_args("a=3&b=hello%20world")
```

or a Lua table holding the query arguments' key-value pairs, as in

```lua

 ngx.req.set_uri_args({ a = 3, b = "hello world" })
```

In the former case, i.e., when the whole query-string is provided directly,
the input Lua string should already be well-formed with the URI encoding.
For security considerations, this method will automatically escape any control and
whitespace characters (ASCII code 0x00 ~ 0x20 and 0x7F) in the Lua string.

In the latter case, this method will escape argument keys and values according to the URI escaping rule.

Multi-value arguments are also supported:

```lua

 ngx.req.set_uri_args({ a = 3, b = {5, 6} })
```

which will result in a query string like `a=3&b=5&b=6`.

This interface was first introduced in the `v0.3.1rc13` release.

See also [ngx.req.set_uri](#ngxreqset_uri).

## ngx.req.get_uri_args

**syntax:** _args, err = ngx.req.get_uri_args(max_args?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, balancer_by_lua\*_

Returns a Lua table holding all the current request URL query arguments.

```nginx

 location = /test {
     content_by_lua_block {
         local args, err = ngx.req.get_uri_args()

         if err == "truncated" then
             -- one can choose to ignore or reject the current request here
         end

         for key, val in pairs(args) do
             if type(val) == "table" then
                 ngx.say(key, ": ", table.concat(val, ", "))
             else
                 ngx.say(key, ": ", val)
             end
         end
     }
 }
```

Then `GET /test?foo=bar&bar=baz&bar=blah` will yield the response body

```bash

 foo: bar
 bar: baz, blah
```

Multiple occurrences of an argument key will result in a table value holding all the values for that key in order.

Keys and values are unescaped according to URI escaping rules. In the settings above, `GET /test?a%20b=1%61+2` will yield:

```bash

 a b: 1a 2
```

Arguments without the `=<value>` parts are treated as boolean arguments. `GET /test?foo&bar` will yield:

```bash

 foo: true
 bar: true
```

That is, they will take Lua boolean values `true`. However, they are different from arguments taking empty string values. `GET /test?foo=&bar=` will give something like

```bash

 foo:
 bar:
```

Empty key arguments are discarded. `GET /test?=hello&=world` will yield an empty output for instance.

Updating query arguments via the Nginx variable `$args` (or `ngx.var.args` in Lua) at runtime is also supported:

```lua

 ngx.var.args = "a=3&b=42"
 local args, err = ngx.req.get_uri_args()
```

Here the `args` table will always look like

```lua

 {a = 3, b = 42}
```

regardless of the actual request query string.

Note that a maximum of 100 request arguments are parsed by default (including those with the same name) and that additional request arguments are silently discarded to guard against potential denial of service attacks. Since `v0.10.13`, when the limit is exceeded, it will return a second value which is the string `"truncated"`.

However, the optional `max_args` function argument can be used to override this limit:

```lua

 local args, err = ngx.req.get_uri_args(10)
 if err == "truncated" then
     -- one can choose to ignore or reject the current request here
 end
```

This argument can be set to zero to remove the limit and to process all request arguments received:

```lua

 local args, err = ngx.req.get_uri_args(0)
```

Removing the `max_args` cap is strongly discouraged.

## ngx.req.get_post_args

**syntax:** _args, err = ngx.req.get_post_args(max_args?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Returns a Lua table holding all the current request POST query arguments (of the MIME type `application/x-www-form-urlencoded`). Call [ngx.req.read_body](#ngxreqread_body) to read the request body first or turn on the [lua_need_request_body](#lua_need_request_body) directive to avoid errors.

```nginx

 location = /test {
     content_by_lua_block {
         ngx.req.read_body()
         local args, err = ngx.req.get_post_args()

         if err == "truncated" then
             -- one can choose to ignore or reject the current request here
         end

         if not args then
             ngx.say("failed to get post args: ", err)
             return
         end
         for key, val in pairs(args) do
             if type(val) == "table" then
                 ngx.say(key, ": ", table.concat(val, ", "))
             else
                 ngx.say(key, ": ", val)
             end
         end
     }
 }
```

Then

```bash

 # Post request with the body 'foo=bar&bar=baz&bar=blah'
 $ curl --data 'foo=bar&bar=baz&bar=blah' localhost/test
```

will yield the response body like

```bash

 foo: bar
 bar: baz, blah
```

Multiple occurrences of an argument key will result in a table value holding all of the values for that key in order.

Keys and values will be unescaped according to URI escaping rules.

With the settings above,

```bash

 # POST request with body 'a%20b=1%61+2'
 $ curl -d 'a%20b=1%61+2' localhost/test
```

will yield:

```bash

 a b: 1a 2
```

Arguments without the `=<value>` parts are treated as boolean arguments. `POST /test` with the request body `foo&bar` will yield:

```bash

 foo: true
 bar: true
```

That is, they will take Lua boolean values `true`. However, they are different from arguments taking empty string values. `POST /test` with request body `foo=&bar=` will return something like

```bash

 foo:
 bar:
```

Empty key arguments are discarded. `POST /test` with body `=hello&=world` will yield empty outputs for instance.

Note that a maximum of 100 request arguments are parsed by default (including those with the same name) and that additional request arguments are silently discarded to guard against potential denial of service attacks. Since `v0.10.13`, when the limit is exceeded, it will return a second value which is the string `"truncated"`.

However, the optional `max_args` function argument can be used to override this limit:

```lua

 local args, err = ngx.req.get_post_args(10)
 if err == "truncated" then
     -- one can choose to ignore or reject the current request here
 end
```

This argument can be set to zero to remove the limit and to process all request arguments received:

```lua

 local args, err = ngx.req.get_post_args(0)
```

Removing the `max_args` cap is strongly discouraged.

## ngx.req.get_headers

**syntax:** _headers, err = ngx.req.get_headers(max_headers?, raw?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Returns a Lua table holding all the current request headers.

```lua

 local h, err = ngx.req.get_headers()

 if err == "truncated" then
     -- one can choose to ignore or reject the current request here
 end

 for k, v in pairs(h) do
     ...
 end
```

To read an individual header:

```lua

 ngx.say("Host: ", ngx.req.get_headers()["Host"])
```

Note that the [ngx.var.HEADER](#ngxvarvariable) API call, which uses core [\$http_HEADER](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_http_) variables, may be more preferable for reading individual request headers.

For multiple instances of request headers such as:

```bash

 Foo: foo
 Foo: bar
 Foo: baz
```

the value of `ngx.req.get_headers()["Foo"]` will be a Lua (array) table such as:

```lua

 {"foo", "bar", "baz"}
```

Note that a maximum of 100 request headers are parsed by default (including those with the same name) and that additional request headers are silently discarded to guard against potential denial of service attacks. Since `v0.10.13`, when the limit is exceeded, it will return a second value which is the string `"truncated"`.

However, the optional `max_headers` function argument can be used to override this limit:

```lua

 local headers, err = ngx.req.get_headers(10)

 if err == "truncated" then
     -- one can choose to ignore or reject the current request here
 end
```

This argument can be set to zero to remove the limit and to process all request headers received:

```lua

 local headers, err = ngx.req.get_headers(0)
```

Removing the `max_headers` cap is strongly discouraged.

Since the `0.6.9` release, all the header names in the Lua table returned are converted to the pure lower-case form by default, unless the `raw` argument is set to `true` (default to `false`).

Also, by default, an `__index` metamethod is added to the resulting Lua table and will normalize the keys to a pure lowercase form with all underscores converted to dashes in case of a lookup miss. For example, if a request header `My-Foo-Header` is present, then the following invocations will all pick up the value of this header correctly:

```lua

 ngx.say(headers.my_foo_header)
 ngx.say(headers["My-Foo-Header"])
 ngx.say(headers["my-foo-header"])
```

The `__index` metamethod will not be added when the `raw` argument is set to `true`.

## ngx.req.set_header

**syntax:** _ngx.req.set_header(header_name, header_value)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*_

Set the current request's request header named `header_name` to value `header_value`, overriding any existing ones.

The input Lua string `header_name` and `header_value` should already be well-formed with the URI encoding.
For security considerations, this method will automatically escape " ", """, "(", ")", ",", "/", ":", ";", "?",
"<", "=", ">", "?", "@", "[", "]", "\", "{", "}", 0x00-0x1F, 0x7F-0xFF in `header_name` and automatically escape
"0x00-0x08, 0x0A-0x0F, 0x7F in `header_value`.

By default, all the subrequests subsequently initiated by [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi) will inherit the new header.

Here is an example of setting the `Content-Type` header:

```lua

 ngx.req.set_header("Content-Type", "text/css")
```

The `header_value` can take an array list of values,
for example,

```lua

 ngx.req.set_header("Foo", {"a", "abc"})
```

will produce two new request headers:

```bash

 Foo: a
 Foo: abc
```

and old `Foo` headers will be overridden if there is any.

When the `header_value` argument is `nil`, the request header will be removed. So

```lua

 ngx.req.set_header("X-Foo", nil)
```

is equivalent to

```lua

 ngx.req.clear_header("X-Foo")
```

Note: this function throws a Lua error if `header_name` or
`header_value` contain unsafe characters (control characters).

## ngx.req.clear_header

**syntax:** _ngx.req.clear_header(header_name)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*_

Clears the current request's request header named `header_name`. None of the current request's existing subrequests will be affected but subsequently initiated subrequests will inherit the change by default.

## ngx.req.read_body

**syntax:** _ngx.req.read_body()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Reads the client request body synchronously without blocking the Nginx event loop.

```lua

 ngx.req.read_body()
 local args = ngx.req.get_post_args()
```

If the request body is already read previously by turning on [lua_need_request_body](#lua_need_request_body) or by using other modules, then this function does not run and returns immediately.

If the request body has already been explicitly discarded, either by the [ngx.req.discard_body](#ngxreqdiscard_body) function or other modules, this function does not run and returns immediately.

In case of errors, such as connection errors while reading the data, this method will throw out a Lua exception _or_ terminate the current request with a 500 status code immediately.

The request body data read using this function can be retrieved later via [ngx.req.get_body_data](#ngxreqget_body_data) or, alternatively, the temporary file name for the body data cached to disk using [ngx.req.get_body_file](#ngxreqget_body_file). This depends on

1. whether the current request body is already larger than the [client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size),
1. and whether [client_body_in_file_only](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_in_file_only) has been switched on.

In cases where current request may have a request body and the request body data is not required, The [ngx.req.discard_body](#ngxreqdiscard_body) function must be used to explicitly discard the request body to avoid breaking things under HTTP 1.1 keepalive or HTTP 1.1 pipelining.

This function was first introduced in the `v0.3.1rc17` release.

## ngx.req.discard_body

**syntax:** _ngx.req.discard_body()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Explicitly discard the request body, i.e., read the data on the connection and throw it away immediately (without using the request body by any means).

This function is an asynchronous call and returns immediately.

If the request body has already been read, this function does nothing and returns immediately.

This function was first introduced in the `v0.3.1rc17` release.

See also [ngx.req.read_body](#ngxreqread_body).

## ngx.req.get_body_data

**syntax:** _data = ngx.req.get_body_data()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, log_by_lua\*_

Retrieves in-memory request body data. It returns a Lua string rather than a Lua table holding all the parsed query arguments. Use the [ngx.req.get_post_args](#ngxreqget_post_args) function instead if a Lua table is required.

This function returns `nil` if

1. the request body has not been read,
1. the request body has been read into disk temporary files,
1. or the request body has zero size.

If the request body has not been read yet, call [ngx.req.read_body](#ngxreqread_body) first (or turn on [lua_need_request_body](#lua_need_request_body) to force this module to read the request body. This is not recommended however).

If the request body has been read into disk files, try calling the [ngx.req.get_body_file](#ngxreqget_body_file) function instead.

To force in-memory request bodies, try setting [client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size) to the same size value in [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size).

Note that calling this function instead of using `ngx.var.request_body` or `ngx.var.echo_request_body` is more efficient because it can save one dynamic memory allocation and one data copy.

This function was first introduced in the `v0.3.1rc17` release.

See also [ngx.req.get_body_file](#ngxreqget_body_file).

## ngx.req.get_body_file

**syntax:** _file_name = ngx.req.get_body_file()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Retrieves the file name for the in-file request body data. Returns `nil` if the request body has not been read or has been read into memory.

The returned file is read only and is usually cleaned up by Nginx's memory pool. It should not be manually modified, renamed, or removed in Lua code.

If the request body has not been read yet, call [ngx.req.read_body](#ngxreqread_body) first (or turn on [lua_need_request_body](#lua_need_request_body) to force this module to read the request body. This is not recommended however).

If the request body has been read into memory, try calling the [ngx.req.get_body_data](#ngxreqget_body_data) function instead.

To force in-file request bodies, try turning on [client_body_in_file_only](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_in_file_only).

This function was first introduced in the `v0.3.1rc17` release.

See also [ngx.req.get_body_data](#ngxreqget_body_data).

## ngx.req.set_body_data

**syntax:** _ngx.req.set_body_data(data)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Set the current request's request body using the in-memory data specified by the `data` argument.

If the request body has not been read yet, call [ngx.req.read_body](#ngxreqread_body) first (or turn on [lua_need_request_body](#lua_need_request_body) to force this module to read the request body. This is not recommended however). Additionally, the request body must not have been previously discarded by [ngx.req.discard_body](#ngxreqdiscard_body).

Whether the previous request body has been read into memory or buffered into a disk file, it will be freed or the disk file will be cleaned up immediately, respectively.

This function was first introduced in the `v0.3.1rc18` release.

See also [ngx.req.set_body_file](#ngxreqset_body_file).

## ngx.req.set_body_file

**syntax:** _ngx.req.set_body_file(file_name, auto_clean?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Set the current request's request body using the in-file data specified by the `file_name` argument.

If the request body has not been read yet, call [ngx.req.read_body](#ngxreqread_body) first (or turn on [lua_need_request_body](#lua_need_request_body) to force this module to read the request body. This is not recommended however). Additionally, the request body must not have been previously discarded by [ngx.req.discard_body](#ngxreqdiscard_body).

If the optional `auto_clean` argument is given a `true` value, then this file will be removed at request completion or the next time this function or [ngx.req.set_body_data](#ngxreqset_body_data) are called in the same request. The `auto_clean` is default to `false`.

Please ensure that the file specified by the `file_name` argument exists and is readable by an Nginx worker process by setting its permission properly to avoid Lua exception errors.

Whether the previous request body has been read into memory or buffered into a disk file, it will be freed or the disk file will be cleaned up immediately, respectively.

This function was first introduced in the `v0.3.1rc18` release.

See also [ngx.req.set_body_data](#ngxreqset_body_data).

## ngx.req.init_body

**syntax:** _ngx.req.init_body(buffer_size?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Creates a new blank request body for the current request and inializes the buffer for later request body data writing via the [ngx.req.append_body](#ngxreqappend_body) and [ngx.req.finish_body](#ngxreqfinish_body) APIs.

If the `buffer_size` argument is specified, then its value will be used for the size of the memory buffer for body writing with [ngx.req.append_body](#ngxreqappend_body). If the argument is omitted, then the value specified by the standard [client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size) directive will be used instead.

When the data can no longer be hold in the memory buffer for the request body, then the data will be flushed onto a temporary file just like the standard request body reader in the Nginx core.

It is important to always call the [ngx.req.finish_body](#ngxreqfinish_body) after all the data has been appended onto the current request body. Also, when this function is used together with [ngx.req.socket](#ngxreqsocket), it is required to call [ngx.req.socket](#ngxreqsocket) _before_ this function, or you will get the "request body already exists" error message.

The usage of this function is often like this:

```lua

 ngx.req.init_body(128 * 1024)  -- buffer is 128KB
 for chunk in next_data_chunk() do
     ngx.req.append_body(chunk) -- each chunk can be 4KB
 end
 ngx.req.finish_body()
```

This function can be used with [ngx.req.append_body](#ngxreqappend_body), [ngx.req.finish_body](#ngxreqfinish_body), and [ngx.req.socket](#ngxreqsocket) to implement efficient input filters in pure Lua (in the context of [rewrite_by_lua\*](#rewrite_by_lua) or [access_by_lua\*](#access_by_lua)), which can be used with other Nginx content handler or upstream modules like [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) and [ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).

This function was first introduced in the `v0.5.11` release.

## ngx.req.append_body

**syntax:** _ngx.req.append_body(data_chunk)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Append new data chunk specified by the `data_chunk` argument onto the existing request body created by the [ngx.req.init_body](#ngxreqinit_body) call.

When the data can no longer be hold in the memory buffer for the request body, then the data will be flushed onto a temporary file just like the standard request body reader in the Nginx core.

It is important to always call the [ngx.req.finish_body](#ngxreqfinish_body) after all the data has been appended onto the current request body.

This function can be used with [ngx.req.init_body](#ngxreqinit_body), [ngx.req.finish_body](#ngxreqfinish_body), and [ngx.req.socket](#ngxreqsocket) to implement efficient input filters in pure Lua (in the context of [rewrite_by_lua\*](#rewrite_by_lua) or [access_by_lua\*](#access_by_lua)), which can be used with other Nginx content handler or upstream modules like [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) and [ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).

This function was first introduced in the `v0.5.11` release.

See also [ngx.req.init_body](#ngxreqinit_body).

## ngx.req.finish_body

**syntax:** _ngx.req.finish_body()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Completes the construction process of the new request body created by the [ngx.req.init_body](#ngxreqinit_body) and [ngx.req.append_body](#ngxreqappend_body) calls.

This function can be used with [ngx.req.init_body](#ngxreqinit_body), [ngx.req.append_body](#ngxreqappend_body), and [ngx.req.socket](#ngxreqsocket) to implement efficient input filters in pure Lua (in the context of [rewrite_by_lua\*](#rewrite_by_lua) or [access_by_lua\*](#access_by_lua)), which can be used with other Nginx content handler or upstream modules like [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) and [ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).

This function was first introduced in the `v0.5.11` release.

See also [ngx.req.init_body](#ngxreqinit_body).

## ngx.req.socket

**syntax:** _tcpsock, err = ngx.req.socket()_

**syntax:** _tcpsock, err = ngx.req.socket(raw)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Returns a read-only cosocket object that wraps the downstream connection. Only [receive](#tcpsockreceive), [receiveany](#tcpsockreceiveany) and [receiveuntil](#tcpsockreceiveuntil) methods are supported on this object.

In case of error, `nil` will be returned as well as a string describing the error.

The socket object returned by this method is usually used to read the current request's body in a streaming fashion. Do not turn on the [lua_need_request_body](#lua_need_request_body) directive, and do not mix this call with [ngx.req.read_body](#ngxreqread_body) and [ngx.req.discard_body](#ngxreqdiscard_body).

If any request body data has been pre-read into the Nginx core request header buffer, the resulting cosocket object will take care of this to avoid potential data loss resulting from such pre-reading.
Chunked request bodies are not yet supported in this API.

Since the `v0.9.0` release, this function accepts an optional boolean `raw` argument. When this argument is `true`, this function returns a full-duplex cosocket object wrapping around the raw downstream connection socket, upon which you can call the [receive](#tcpsockreceive), [receiveany](#tcpsockreceiveany), [receiveuntil](#tcpsockreceiveuntil), and [send](#tcpsocksend) methods.

When the `raw` argument is `true`, it is required that no pending data from any previous [ngx.say](#ngxsay), [ngx.print](#ngxprint), or [ngx.send_headers](#ngxsend_headers) calls exists. So if you have these downstream output calls previously, you should call [ngx.flush(true)](#ngxflush) before calling `ngx.req.socket(true)` to ensure that there is no pending output data. If the request body has not been read yet, then this "raw socket" can also be used to read the request body.

You can use the "raw request socket" returned by `ngx.req.socket(true)` to implement fancy protocols like [WebSocket](https://en.wikipedia.org/wiki/WebSocket), or just emit your own raw HTTP response header or body data. You can refer to the [lua-resty-websocket library](https://github.com/openresty/lua-resty-websocket) for a real world example.

This function was first introduced in the `v0.5.0rc1` release.

## ngx.exec

**syntax:** _ngx.exec(uri, args?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Does an internal redirect to `uri` with `args` and is similar to the [echo_exec](http://github.com/openresty/echo-nginx-module#echo_exec) directive of the [echo-nginx-module](http://github.com/openresty/echo-nginx-module).

```lua

 ngx.exec('/some-location')
 ngx.exec('/some-location', 'a=3&b=5&c=6')
 ngx.exec('/some-location?a=3&b=5', 'c=6')
```

The optional second `args` can be used to specify extra URI query arguments, for example:

```lua

 ngx.exec("/foo", "a=3&b=hello%20world")
```

Alternatively, a Lua table can be passed for the `args` argument for ngx_lua to carry out URI escaping and string concatenation.

```lua

 ngx.exec("/foo", { a = 3, b = "hello world" })
```

The result is exactly the same as the previous example.

The format for the Lua table passed as the `args` argument is identical to the format used in the [ngx.encode_args](#ngxencode_args) method.

Named locations are also supported but the second `args` argument will be ignored if present and the querystring for the new target is inherited from the referring location (if any).

`GET /foo/file.php?a=hello` will return "hello" and not "goodbye" in the example below

```nginx

 location /foo {
     content_by_lua_block {
         ngx.exec("@bar", "a=goodbye")
     }
 }

 location @bar {
     content_by_lua_block {
         local args = ngx.req.get_uri_args()
         for key, val in pairs(args) do
             if key == "a" then
                 ngx.say(val)
             end
         end
     }
 }
```

Note that the `ngx.exec` method is different from [ngx.redirect](#ngxredirect) in that
it is purely an internal redirect and that no new external HTTP traffic is involved.

Also note that this method call terminates the processing of the current request and that it _must_ be called before [ngx.send_headers](#ngxsend_headers) or explicit response body
outputs by either [ngx.print](#ngxprint) or [ngx.say](#ngxsay).

It is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.exec(...)` be adopted when this method call is used in contexts other than [header_filter_by_lua\*](#header_filter_by_lua) to reinforce the fact that the request processing is being terminated.

## ngx.redirect

**syntax:** _ngx.redirect(uri, status?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Issue an `HTTP 301` or `302` redirection to `uri`.

Note: this function throws a Lua error if the `uri` argument
contains unsafe characters (control characters).

The optional `status` parameter specifies the HTTP status code to be used. The following status codes are supported right now:

- `301`
- `302` (default)
- `303`
- `307`
- `308`

It is `302` (`ngx.HTTP_MOVED_TEMPORARILY`) by default.

Here is an example assuming the current server name is `localhost` and that it is listening on port 1984:

```lua

 return ngx.redirect("/foo")
```

which is equivalent to

```lua

 return ngx.redirect("/foo", ngx.HTTP_MOVED_TEMPORARILY)
```

Redirecting arbitrary external URLs is also supported, for example:

```lua

 return ngx.redirect("http://www.google.com")
```

We can also use the numerical code directly as the second `status` argument:

```lua

 return ngx.redirect("/foo", 301)
```

This method is similar to the [rewrite](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directive with the `redirect` modifier in the standard
[ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html), for example, this `nginx.conf` snippet

```nginx

 rewrite ^ /foo? redirect;  # nginx config
```

is equivalent to the following Lua code

```lua

 return ngx.redirect('/foo')  -- Lua code
```

while

```nginx

 rewrite ^ /foo? permanent;  # nginx config
```

is equivalent to

```lua

 return ngx.redirect('/foo', ngx.HTTP_MOVED_PERMANENTLY)  -- Lua code
```

URI arguments can be specified as well, for example:

```lua

 return ngx.redirect('/foo?a=3&b=4')
```

Note that this method call terminates the processing of the current request and that it _must_ be called before [ngx.send_headers](#ngxsend_headers) or explicit response body
outputs by either [ngx.print](#ngxprint) or [ngx.say](#ngxsay).

It is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.redirect(...)` be adopted when this method call is used in contexts other than [header_filter_by_lua\*](#header_filter_by_lua) to reinforce the fact that the request processing is being terminated.

## ngx.send_headers

**syntax:** _ok, err = ngx.send_headers()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Explicitly send out the response headers.

Since `v0.8.3` this function returns `1` on success, or returns `nil` and a string describing the error otherwise.

Note that there is normally no need to manually send out response headers as ngx_lua will automatically send headers out
before content is output with [ngx.say](#ngxsay) or [ngx.print](#ngxprint) or when [content_by_lua\*](#content_by_lua) exits normally.

## ngx.headers_sent

**syntax:** _value = ngx.headers_sent_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Returns `true` if the response headers have been sent (by ngx_lua), and `false` otherwise.

This API was first introduced in ngx_lua v0.3.1rc6.

## ngx.print

**syntax:** _ok, err = ngx.print(...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Emits arguments concatenated to the HTTP client (as response body). If response headers have not been sent, this function will send headers out first and then output body data.

Since `v0.8.3` this function returns `1` on success, or returns `nil` and a string describing the error otherwise.

Lua `nil` values will output `"nil"` strings and Lua boolean values will output `"true"` and `"false"` literal strings respectively.

Nested arrays of strings are permitted and the elements in the arrays will be sent one by one:

```lua

 local table = {
     "hello, ",
     {"world: ", true, " or ", false,
         {": ", nil}}
 }
 ngx.print(table)
```

will yield the output

```bash

 hello, world: true or false: nil
```

Non-array table arguments will cause a Lua exception to be thrown.

The `ngx.null` constant will yield the `"null"` string output.

This is an asynchronous call and will return immediately without waiting for all the data to be written into the system send buffer. To run in synchronous mode, call `ngx.flush(true)` after calling `ngx.print`. This can be particularly useful for streaming output. See [ngx.flush](#ngxflush) for more details.

Please note that both `ngx.print` and [ngx.say](#ngxsay) will always invoke the whole Nginx output body filter chain, which is an expensive operation. So be careful when calling either of these two in a tight loop; buffer the data yourself in Lua and save the calls.

## ngx.say

**syntax:** _ok, err = ngx.say(...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Just as [ngx.print](#ngxprint) but also emit a trailing newline.

## ngx.log

**syntax:** _ngx.log(log_level, ...)_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Log arguments concatenated to error.log with the given logging level.

Lua `nil` arguments are accepted and result in literal `"nil"` string while Lua booleans result in literal `"true"` or `"false"` string outputs. And the `ngx.null` constant will yield the `"null"` string output.

The `log_level` argument can take constants like `ngx.ERR` and `ngx.WARN`. Check out [Nginx log level constants](#nginx-log-level-constants) for details.

There is a hard coded `2048` byte limitation on error message lengths in the Nginx core. This limit includes trailing newlines and leading time stamps. If the message size exceeds this limit, Nginx will truncate the message text accordingly. This limit can be manually modified by editing the `NGX_MAX_ERROR_STR` macro definition in the `src/core/ngx_log.h` file in the Nginx source tree.

## ngx.flush

**syntax:** _ok, err = ngx.flush(wait?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Flushes response output to the client.

`ngx.flush` accepts an optional boolean `wait` argument (Default: `false`) first introduced in the `v0.3.1rc34` release. When called with the default argument, it issues an asynchronous call (Returns immediately without waiting for output data to be written into the system send buffer). Calling the function with the `wait` argument set to `true` switches to synchronous mode.

In synchronous mode, the function will not return until all output data has been written into the system send buffer or until the [send_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#send_timeout) setting has expired. Note that using the Lua coroutine mechanism means that this function does not block the Nginx event loop even in the synchronous mode.

When `ngx.flush(true)` is called immediately after [ngx.print](#ngxprint) or [ngx.say](#ngxsay), it causes the latter functions to run in synchronous mode. This can be particularly useful for streaming output.

Note that `ngx.flush` is not functional when in the HTTP 1.0 output buffering mode. See [HTTP 1.0 support](#http-10-support).

Since `v0.8.3` this function returns `1` on success, or returns `nil` and a string describing the error otherwise.

## ngx.exit

**syntax:** _ngx.exit(status)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

When `status >= 200` (i.e., `ngx.HTTP_OK` and above), it will interrupt the execution of the current request and return status code to Nginx.

When `status == 0` (i.e., `ngx.OK`), it will only quit the current phase handler (or the content handler if the [content_by_lua\*](#content_by_lua) directive is used) and continue to run later phases (if any) for the current request.

The `status` argument can be `ngx.OK`, `ngx.ERROR`, `ngx.HTTP_NOT_FOUND`,
`ngx.HTTP_MOVED_TEMPORARILY`, or other [HTTP status constants](#http-status-constants).

To return an error page with custom contents, use code snippets like this:

```lua

 ngx.status = ngx.HTTP_GONE
 ngx.say("This is our own content")
 -- to cause quit the whole request rather than the current phase handler
 ngx.exit(ngx.HTTP_OK)
```

The effect in action:

```bash

 $ curl -i http://localhost/test
 HTTP/1.1 410 Gone
 Server: nginx/1.0.6
 Date: Thu, 15 Sep 2011 00:51:48 GMT
 Content-Type: text/plain
 Transfer-Encoding: chunked
 Connection: keep-alive

 This is our own content
```

Number literals can be used directly as the argument, for instance,

```lua

 ngx.exit(501)
```

Note that while this method accepts all [HTTP status constants](#http-status-constants) as input, it only accepts `ngx.OK` and `ngx.ERROR` of the [core constants](#core-constants).

Also note that this method call terminates the processing of the current request and that it is recommended that a coding style that combines this method call with the `return` statement, i.e., `return ngx.exit(...)` be used to reinforce the fact that the request processing is being terminated.

When being used in the contexts of [header_filter_by_lua\*](#header_filter_by_lua), [balancer_by_lua\*](#balancer_by_lua_block), and
[ssl_session_store_by_lua\*](#ssl_session_store_by_lua_block), `ngx.exit()` is
an asynchronous operation and will return immediately. This behavior may change in future and it is recommended that users always use `return` in combination as suggested above.

## ngx.eof

**syntax:** _ok, err = ngx.eof()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Explicitly specify the end of the response output stream. In the case of HTTP 1.1 chunked encoded output, it will just trigger the Nginx core to send out the "last chunk".

When you disable the HTTP 1.1 keep-alive feature for your downstream connections, you can rely on well written HTTP clients to close the connection actively for you when you call this method. This trick can be used do back-ground jobs without letting the HTTP clients to wait on the connection, as in the following example:

```nginx

 location = /async {
     keepalive_timeout 0;
     content_by_lua_block {
         ngx.say("got the task!")
         ngx.eof()  -- well written HTTP clients will close the connection at this point
         -- access MySQL, PostgreSQL, Redis, Memcached, and etc here...
     }
 }
```

But if you create subrequests to access other locations configured by Nginx upstream modules, then you should configure those upstream modules to ignore client connection abortions if they are not by default. For example, by default the standard [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html) will terminate both the subrequest and the main request as soon as the client closes the connection, so it is important to turn on the [proxy_ignore_client_abort](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ignore_client_abort) directive in your location block configured by [ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html):

```nginx

 proxy_ignore_client_abort on;
```

A better way to do background jobs is to use the [ngx.timer.at](#ngxtimerat) API.

Since `v0.8.3` this function returns `1` on success, or returns `nil` and a string describing the error otherwise.

## ngx.sleep

**syntax:** _ngx.sleep(seconds)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Sleeps for the specified seconds without blocking. One can specify time resolution up to 0.001 seconds (i.e., one millisecond).

Behind the scene, this method makes use of the Nginx timers.

Since the `0.7.20` release, The `0` time argument can also be specified.

This method was introduced in the `0.5.0rc30` release.

## ngx.escape_uri

**syntax:** _newstr = ngx.escape_uri(str, type?)_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Since `v0.10.16`, this function accepts an optional `type` argument.
It accepts the following values (defaults to `2`):

- `0`: escapes `str` as a full URI. And the characters
  ` ` (space), `#`, `%`,
  `?`, 0x00 ~ 0x1F, 0x7F ~ 0xFF will be escaped.
- `2`: escape `str` as a URI component. All characters except
  alphabetic characters, digits, `-`, `.`, `_`,
  `~` will be encoded as `%XX`.

## ngx.unescape_uri

**syntax:** _newstr = ngx.unescape_uri(str)_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, exit_worker_by_lua\*_

Unescape `str` as an escaped URI component.

For example,

```lua

 ngx.say(ngx.unescape_uri("b%20r56+7"))
```

gives the output

```default
b r56 7
```

## ngx.encode_args

**syntax:** _str = ngx.encode_args(table)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*_

Encode the Lua table to a query args string according to the URI encoded rules.

For example,

```lua

 ngx.encode_args({foo = 3, ["b r"] = "hello world"})
```

yields

```default
foo=3&b%20r=hello%20world
```

The table keys must be Lua strings.

Multi-value query args are also supported. Just use a Lua table for the argument's value, for example:

```lua

 ngx.encode_args({baz = {32, "hello"}})
```

gives

```default
baz=32&baz=hello
```

If the value table is empty and the effect is equivalent to the `nil` value.

Boolean argument values are also supported, for instance,

```lua

 ngx.encode_args({a = true, b = 1})
```

yields

```default
a&b=1
```

If the argument value is `false`, then the effect is equivalent to the `nil` value.

This method was first introduced in the `v0.3.1rc27` release.

## ngx.decode_args

**syntax:** _table, err = ngx.decode_args(str, max_args?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Decodes a URI encoded query-string into a Lua table. This is the inverse function of [ngx.encode_args](#ngxencode_args).

The optional `max_args` argument can be used to specify the maximum number of arguments parsed from the `str` argument. By default, a maximum of 100 request arguments are parsed (including those with the same name) and that additional URI arguments are silently discarded to guard against potential denial of service attacks. Since `v0.10.13`, when the limit is exceeded, it will return a second value which is the string `"truncated"`.

This argument can be set to zero to remove the limit and to process all request arguments received:

```lua

 local args = ngx.decode_args(str, 0)
```

Removing the `max_args` cap is strongly discouraged.

This method was introduced in the `v0.5.0rc29`.

## ngx.encode_base64

**syntax:** _newstr = ngx.encode_base64(str, no_padding?)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Encodes `str` to a base64 digest.

Since the `0.9.16` release, an optional boolean-typed `no_padding` argument can be specified to control whether the base64 padding should be appended to the resulting digest (default to `false`, i.e., with padding enabled).

## ngx.decode_base64

**syntax:** _newstr = ngx.decode_base64(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Decodes the `str` argument as a base64 digest to the raw form. Returns `nil` if `str` is not well formed.

## ngx.crc32_short

**syntax:** _intval = ngx.crc32_short(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Calculates the CRC-32 (Cyclic Redundancy Code) digest for the `str` argument.

This method performs better on relatively short `str` inputs (i.e., less than 30 ~ 60 bytes), as compared to [ngx.crc32_long](#ngxcrc32_long). The result is exactly the same as [ngx.crc32_long](#ngxcrc32_long).

Behind the scene, it is just a thin wrapper around the `ngx_crc32_short` function defined in the Nginx core.

This API was first introduced in the `v0.3.1rc8` release.

## ngx.crc32_long

**syntax:** _intval = ngx.crc32_long(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Calculates the CRC-32 (Cyclic Redundancy Code) digest for the `str` argument.

This method performs better on relatively long `str` inputs (i.e., longer than 30 ~ 60 bytes), as compared to [ngx.crc32_short](#ngxcrc32_short). The result is exactly the same as [ngx.crc32_short](#ngxcrc32_short).

Behind the scene, it is just a thin wrapper around the `ngx_crc32_long` function defined in the Nginx core.

This API was first introduced in the `v0.3.1rc8` release.

## ngx.hmac_sha1

**syntax:** _digest = ngx.hmac_sha1(secret_key, str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Computes the [HMAC-SHA1](https://en.wikipedia.org/wiki/HMAC) digest of the argument `str` and turns the result using the secret key `<secret_key>`.

The raw binary form of the `HMAC-SHA1` digest will be generated, use [ngx.encode_base64](#ngxencode_base64), for example, to encode the result to a textual representation if desired.

For example,

```lua

 local key = "thisisverysecretstuff"
 local src = "some string we want to sign"
 local digest = ngx.hmac_sha1(key, src)
 ngx.say(ngx.encode_base64(digest))
```

yields the output

```default
R/pvxzHC4NLtj7S+kXFg/NePTmk=
```

This API requires the OpenSSL library enabled in the Nginx build (usually by passing the `--with-http_ssl_module` option to the `./configure` script).

This function was first introduced in the `v0.3.1rc29` release.

## ngx.md5

**syntax:** _digest = ngx.md5(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Returns the hexadecimal representation of the MD5 digest of the `str` argument.

For example,

```nginx

 location = /md5 {
     content_by_lua_block { ngx.say(ngx.md5("hello")) }
 }
```

yields the output

```default
5d41402abc4b2a76b9719d911017c592
```

See [ngx.md5_bin](#ngxmd5_bin) if the raw binary MD5 digest is required.

## ngx.md5_bin

**syntax:** _digest = ngx.md5_bin(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Returns the binary form of the MD5 digest of the `str` argument.

See [ngx.md5](#ngxmd5) if the hexadecimal form of the MD5 digest is required.

## ngx.sha1_bin

**syntax:** _digest = ngx.sha1_bin(str)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Returns the binary form of the SHA-1 digest of the `str` argument.

This function requires SHA-1 support in the Nginx build. (This usually just means OpenSSL should be installed while building Nginx).

This function was first introduced in the `v0.5.0rc6`.

## ngx.quote_sql_str

**syntax:** _quoted_value = ngx.quote_sql_str(raw_value)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Returns a quoted SQL string literal according to the MySQL quoting rules.

## ngx.today

**syntax:** _str = ngx.today()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns current date (in the format `yyyy-mm-dd`) from the Nginx cached time (no syscall involved unlike Lua's date library).

This is the local time.

## ngx.time

**syntax:** _secs = ngx.time()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns the elapsed seconds from the epoch for the current time stamp from the Nginx cached time (no syscall involved unlike Lua's date library).

Updates of the Nginx time cache can be forced by calling [ngx.update_time](#ngxupdate_time) first.

## ngx.now

**syntax:** _secs = ngx.now()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns a floating-point number for the elapsed time in seconds (including milliseconds as the decimal part) from the epoch for the current time stamp from the Nginx cached time (no syscall involved unlike Lua's date library).

You can forcibly update the Nginx time cache by calling [ngx.update_time](#ngxupdate_time) first.

This API was first introduced in `v0.3.1rc32`.

## ngx.update_time

**syntax:** _ngx.update_time()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Forcibly updates the Nginx current time cache. This call involves a syscall and thus has some overhead, so do not abuse it.

This API was first introduced in `v0.3.1rc32`.

## ngx.localtime

**syntax:** _str = ngx.localtime()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns the current time stamp (in the format `yyyy-mm-dd hh:mm:ss`) of the Nginx cached time (no syscall involved unlike Lua's [os.date](https://www.lua.org/manual/5.1/manual.html#pdf-os.date) function).

This is the local time.

## ngx.utctime

**syntax:** _str = ngx.utctime()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns the current time stamp (in the format `yyyy-mm-dd hh:mm:ss`) of the Nginx cached time (no syscall involved unlike Lua's [os.date](https://www.lua.org/manual/5.1/manual.html#pdf-os.date) function).

This is the UTC time.

## ngx.cookie_time

**syntax:** _str = ngx.cookie_time(sec)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns a formatted string can be used as the cookie expiration time. The parameter `sec` is the time stamp in seconds (like those returned from [ngx.time](#ngxtime)).

```nginx

 ngx.say(ngx.cookie_time(1290079655))
     -- yields "Thu, 18-Nov-10 11:27:35 GMT"
```

## ngx.http_time

**syntax:** _str = ngx.http_time(sec)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns a formated string can be used as the http header time (for example, being used in `Last-Modified` header). The parameter `sec` is the time stamp in seconds (like those returned from [ngx.time](#ngxtime)).

```nginx

 ngx.say(ngx.http_time(1290079655))
     -- yields "Thu, 18 Nov 2010 11:27:35 GMT"
```

## ngx.parse_http_time

**syntax:** _sec = ngx.parse_http_time(str)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Parse the http time string (as returned by [ngx.http_time](#ngxhttp_time)) into seconds. Returns the seconds or `nil` if the input string is in bad forms.

```nginx

 local time = ngx.parse_http_time("Thu, 18 Nov 2010 11:27:35 GMT")
 if time == nil then
     ...
 end
```

## ngx.is_subrequest

**syntax:** _value = ngx.is_subrequest_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*_

Returns `true` if the current request is an Nginx subrequest, or `false` otherwise.

## ngx.re.match

**syntax:** _captures, err = ngx.re.match(subject, regex, options?, ctx?, res_table?)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Matches the `subject` string using the Perl compatible regular expression `regex` with the optional `options`.

Only the first occurrence of the match is returned, or `nil` if no match is found. In case of errors, like seeing a bad regular expression or exceeding the PCRE stack limit, `nil` and a string describing the error will be returned.

When a match is found, a Lua table `captures` is returned, where `captures[0]` holds the whole substring being matched, and `captures[1]` holds the first parenthesized sub-pattern's capturing, `captures[2]` the second, and so on.

```lua

 local m, err = ngx.re.match("hello, 1234", "[0-9]+")
 if m then
     -- m[0] == "1234"

 else
     if err then
         ngx.log(ngx.ERR, "error: ", err)
         return
     end

     ngx.say("match not found")
 end
```

```lua

 local m, err = ngx.re.match("hello, 1234", "([0-9])[0-9]+")
 -- m[0] == "1234"
 -- m[1] == "1"
```

Named captures are also supported since the `v0.7.14` release
and are returned in the same Lua table as key-value pairs as the numbered captures.

```lua

 local m, err = ngx.re.match("hello, 1234", "([0-9])(?<remaining>[0-9]+)")
 -- m[0] == "1234"
 -- m[1] == "1"
 -- m[2] == "234"
 -- m["remaining"] == "234"
```

Unmatched subpatterns will have `false` values in their `captures` table fields.

```lua

 local m, err = ngx.re.match("hello, world", "(world)|(hello)|(?<named>howdy)")
 -- m[0] == "hello"
 -- m[1] == false
 -- m[2] == "hello"
 -- m[3] == false
 -- m["named"] == false
```

Specify `options` to control how the match operation will be performed. The following option characters are supported:

```default
a             anchored mode (only match from the beginning)

d             enable the DFA mode (or the longest token match semantics).
              this requires PCRE 6.0+ or else a Lua exception will be thrown.
              first introduced in ngx_lua v0.3.1rc30.

D             enable duplicate named pattern support. This allows named
              subpattern names to be repeated, returning the captures in
              an array-like Lua table. for example,
                local m = ngx.re.match("hello, world",
                                       "(?<named>\w+), (?<named>\w+)",
                                       "D")
                -- m["named"] == {"hello", "world"}
              this option was first introduced in the v0.7.14 release.
              this option requires at least PCRE 8.12.

i             case insensitive mode (similar to Perl's /i modifier)

j             enable PCRE JIT compilation, this requires PCRE 8.21+ which
              must be built with the --enable-jit option. for optimum performance,
              this option should always be used together with the 'o' option.
              first introduced in ngx_lua v0.3.1rc30.

J             enable the PCRE Javascript compatible mode. this option was
              first introduced in the v0.7.14 release. this option requires
              at least PCRE 8.12.

m             multi-line mode (similar to Perl's /m modifier)

o             compile-once mode (similar to Perl's /o modifier),
              to enable the worker-process-level compiled-regex cache

s             single-line mode (similar to Perl's /s modifier)

u             UTF-8 mode. this requires PCRE to be built with
              the --enable-utf8 option or else a Lua exception will be thrown.

U             similar to "u" but disables PCRE's UTF-8 validity check on
              the subject string. first introduced in ngx_lua v0.8.1.

x             extended mode (similar to Perl's /x modifier)
```

These options can be combined:

```nginx

 local m, err = ngx.re.match("hello, world", "HEL LO", "ix")
 -- m[0] == "hello"
```

```nginx

 local m, err = ngx.re.match("hello, 美好生活", "HELLO, (.{2})", "iu")
 -- m[0] == "hello, 美好"
 -- m[1] == "美好"
```

The `o` option is useful for performance tuning, because the regex pattern in question will only be compiled once, cached in the worker-process level, and shared among all requests in the current Nginx worker process. The upper limit of the regex cache can be tuned via the [lua_regex_cache_max_entries](#lua_regex_cache_max_entries) directive.

The optional fourth argument, `ctx`, can be a Lua table holding an optional `pos` field. When the `pos` field in the `ctx` table argument is specified, `ngx.re.match` will start matching from that offset (starting from 1). Regardless of the presence of the `pos` field in the `ctx` table, `ngx.re.match` will always set this `pos` field to the position _after_ the substring matched by the whole pattern in case of a successful match. When match fails, the `ctx` table will be left intact.

```lua

 local ctx = {}
 local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
      -- m[0] = "1234"
      -- ctx.pos == 5
```

```lua

 local ctx = { pos = 2 }
 local m, err = ngx.re.match("1234, hello", "[0-9]+", "", ctx)
      -- m[0] = "234"
      -- ctx.pos == 5
```

The `ctx` table argument combined with the `a` regex modifier can be used to construct a lexer atop `ngx.re.match`.

Note that, the `options` argument is not optional when the `ctx` argument is specified and that the empty Lua string (`""`) must be used as placeholder for `options` if no meaningful regex options are required.

This method requires the PCRE library enabled in Nginx ([Known Issue With Special Escaping Sequences](#special-escaping-sequences)).

To confirm that PCRE JIT is enabled, activate the Nginx debug log by adding the `--with-debug` option to Nginx or OpenResty's `./configure` script. Then, enable the "debug" error log level in `error_log` directive. The following message will be generated if PCRE JIT is enabled:

```default
pcre JIT compiling result: 1
```

Starting from the `0.9.4` release, this function also accepts a 5th argument, `res_table`, for letting the caller supply the Lua table used to hold all the capturing results. Starting from `0.9.6`, it is the caller's responsibility to ensure this table is empty. This is very useful for recycling Lua tables and saving GC and table allocation overhead.

This feature was introduced in the `v0.2.1rc11` release.

## ngx.re.find

**syntax:** _from, to, err = ngx.re.find(subject, regex, options?, ctx?, nth?)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Similar to [ngx.re.match](#ngxrematch) but only returns the beginning index (`from`) and end index (`to`) of the matched substring. The returned indexes are 1-based and can be fed directly into the [string.sub](https://www.lua.org/manual/5.1/manual.html#pdf-string.sub) API function to obtain the matched substring.

In case of errors (like bad regexes or any PCRE runtime errors), this API function returns two `nil` values followed by a string describing the error.

If no match is found, this function just returns a `nil` value.

Below is an example:

```lua

 local s = "hello, 1234"
 local from, to, err = ngx.re.find(s, "([0-9]+)", "jo")
 if from then
     ngx.say("from: ", from)
     ngx.say("to: ", to)
     ngx.say("matched: ", string.sub(s, from, to))
 else
     if err then
         ngx.say("error: ", err)
         return
     end
     ngx.say("not matched!")
 end
```

This example produces the output

```default
from: 8
to: 11
matched: 1234
```

Because this API function does not create new Lua strings nor new Lua tables, it is much faster than [ngx.re.match](#ngxrematch). It should be used wherever possible.

Since the `0.9.3` release, an optional 5th argument, `nth`, is supported to specify which (submatch) capture's indexes to return. When `nth` is 0 (which is the default), the indexes for the whole matched substring is returned; when `nth` is 1, then the 1st submatch capture's indexes are returned; when `nth` is 2, then the 2nd submatch capture is returned, and so on. When the specified submatch does not have a match, then two `nil` values will be returned. Below is an example for this:

```lua

 local str = "hello, 1234"
 local from, to = ngx.re.find(str, "([0-9])([0-9]+)", "jo", nil, 2)
 if from then
     ngx.say("matched 2nd submatch: ", string.sub(str, from, to))  -- yields "234"
 end
```

This API function was first introduced in the `v0.9.2` release.

## ngx.re.gmatch

**syntax:** _iterator, err = ngx.re.gmatch(subject, regex, options?)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Similar to [ngx.re.match](#ngxrematch), but returns a Lua iterator instead, so as to let the user programmer iterate all the matches over the `<subject>` string argument with the PCRE `regex`.

In case of errors, like seeing an ill-formed regular expression, `nil` and a string describing the error will be returned.

Here is a small example to demonstrate its basic usage:

```lua

 local iterator, err = ngx.re.gmatch("hello, world!", "([a-z]+)", "i")
 if not iterator then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 local m
 m, err = iterator()    -- m[0] == m[1] == "hello"
 if err then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 m, err = iterator()    -- m[0] == m[1] == "world"
 if err then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 m, err = iterator()    -- m == nil
 if err then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end
```

More often we just put it into a Lua loop:

```lua

 local it, err = ngx.re.gmatch("hello, world!", "([a-z]+)", "i")
 if not it then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 while true do
     local m, err = it()
     if err then
         ngx.log(ngx.ERR, "error: ", err)
         return
     end

     if not m then
         -- no match found (any more)
         break
     end

     -- found a match
     ngx.say(m[0])
     ngx.say(m[1])
 end
```

The optional `options` argument takes exactly the same semantics as the [ngx.re.match](#ngxrematch) method.

The current implementation requires that the iterator returned should only be used in a single request. That is, one should _not_ assign it to a variable belonging to persistent namespace like a Lua package.

This method requires the PCRE library enabled in Nginx ([Known Issue With Special Escaping Sequences](#special-escaping-sequences)).

This feature was first introduced in the `v0.2.1rc12` release.

## ngx.re.sub

**syntax:** _newstr, n, err = ngx.re.sub(subject, regex, replace, options?)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Substitutes the first match of the Perl compatible regular expression `regex` on the `subject` argument string with the string or function argument `replace`. The optional `options` argument has exactly the same meaning as in [ngx.re.match](#ngxrematch).

This method returns the resulting new string as well as the number of successful substitutions. In case of failures, like syntax errors in the regular expressions or the `<replace>` string argument, it will return `nil` and a string describing the error.

When the `replace` is a string, then it is treated as a special template for string replacement. For example,

```lua

 local newstr, n, err = ngx.re.sub("hello, 1234", "([0-9])[0-9]", "[$0][$1]")
 if not newstr then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 -- newstr == "hello, [12][1]34"
 -- n == 1
```

where `$0` referring to the whole substring matched by the pattern and `$1` referring to the first parenthesized capturing substring.

Curly braces can also be used to disambiguate variable names from the background string literals:

```lua

 local newstr, n, err = ngx.re.sub("hello, 1234", "[0-9]", "${0}00")
 -- newstr == "hello, 100234"
 -- n == 1
```

Literal dollar sign characters (`$`) in the `replace` string argument can be escaped by another dollar sign, for instance,

```lua

 local newstr, n, err = ngx.re.sub("hello, 1234", "[0-9]", "$$")
 -- newstr == "hello, $234"
 -- n == 1
```

Do not use backlashes to escape dollar signs; it will not work as expected.

When the `replace` argument is of type "function", then it will be invoked with the "match table" as the argument to generate the replace string literal for substitution. The "match table" fed into the `replace` function is exactly the same as the return value of [ngx.re.match](#ngxrematch). Here is an example:

```lua

 local func = function (m)
     return "[" .. m[0] .. "][" .. m[1] .. "]"
 end

 local newstr, n, err = ngx.re.sub("hello, 1234", "( [0-9] ) [0-9]", func, "x")
 -- newstr == "hello, [12][1]34"
 -- n == 1
```

The dollar sign characters in the return value of the `replace` function argument are not special at all.

This method requires the PCRE library enabled in Nginx ([Known Issue With Special Escaping Sequences](#special-escaping-sequences)).

This feature was first introduced in the `v0.2.1rc13` release.

## ngx.re.gsub

**syntax:** _newstr, n, err = ngx.re.gsub(subject, regex, replace, options?)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Just like [ngx.re.sub](#ngxresub), but does global substitution.

Here is some examples:

```lua

 local newstr, n, err = ngx.re.gsub("hello, world", "([a-z])[a-z]+", "[$0,$1]", "i")
 if not newstr then
     ngx.log(ngx.ERR, "error: ", err)
     return
 end

 -- newstr == "[hello,h], [world,w]"
 -- n == 2
```

```lua

 local func = function (m)
     return "[" .. m[0] .. "," .. m[1] .. "]"
 end
 local newstr, n, err = ngx.re.gsub("hello, world", "([a-z])[a-z]+", func, "i")
 -- newstr == "[hello,h], [world,w]"
 -- n == 2
```

This method requires the PCRE library enabled in Nginx ([Known Issue With Special Escaping Sequences](#special-escaping-sequences)).

This feature was first introduced in the `v0.2.1rc15` release.

## ngx.shared.DICT

**syntax:** _dict = ngx.shared.DICT_

**syntax:** _dict = ngx.shared\[name_var\]_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Fetching the shm-based Lua dictionary object for the shared memory zone named `DICT` defined by the [lua_shared_dict](#lua_shared_dict) directive.

Shared memory zones are always shared by all the Nginx worker processes in the current Nginx server instance.

The resulting object `dict` has the following methods:

- [get](#ngxshareddictget)
- [get_stale](#ngxshareddictget_stale)
- [set](#ngxshareddictset)
- [safe_set](#ngxshareddictsafe_set)
- [add](#ngxshareddictadd)
- [safe_add](#ngxshareddictsafe_add)
- [replace](#ngxshareddictreplace)
- [delete](#ngxshareddictdelete)
- [incr](#ngxshareddictincr)
- [lpush](#ngxshareddictlpush)
- [rpush](#ngxshareddictrpush)
- [lpop](#ngxshareddictlpop)
- [rpop](#ngxshareddictrpop)
- [llen](#ngxshareddictllen)
- [ttl](#ngxshareddictttl)
- [expire](#ngxshareddictexpire)
- [flush_all](#ngxshareddictflush_all)
- [flush_expired](#ngxshareddictflush_expired)
- [get_keys](#ngxshareddictget_keys)
- [capacity](#ngxshareddictcapacity)
- [free_space](#ngxshareddictfree_space)

All these methods are _atomic_ operations, that is, safe from concurrent accesses from multiple Nginx worker processes for the same `lua_shared_dict` zone.

Here is an example:

```nginx

 http {
     lua_shared_dict dogs 10m;
     server {
         location /set {
             content_by_lua_block {
                 local dogs = ngx.shared.dogs
                 dogs:set("Jim", 8)
                 ngx.say("STORED")
             }
         }
         location /get {
             content_by_lua_block {
                 local dogs = ngx.shared.dogs
                 ngx.say(dogs:get("Jim"))
             }
         }
     }
 }
```

Let us test it:

```bash

 $ curl localhost/set
 STORED

 $ curl localhost/get
 8

 $ curl localhost/get
 8
```

The number `8` will be consistently output when accessing `/get` regardless of how many Nginx workers there are because the `dogs` dictionary resides in the shared memory and visible to _all_ of the worker processes.

The shared dictionary will retain its contents through a server config reload (either by sending the `HUP` signal to the Nginx process or by using the `-s reload` command-line option).

The contents in the dictionary storage will be lost, however, when the Nginx server quits.

This feature was first introduced in the `v0.3.1rc22` release.

## ngx.shared.DICT.get

**syntax:** _value, flags = ngx.shared.DICT:get(key)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Retrieving the value in the dictionary [ngx.shared.DICT](#ngxshareddict) for the key `key`. If the key does not exist or has expired, then `nil` will be returned.

In case of errors, `nil` and a string describing the error will be returned.

The value returned will have the original data type when they were inserted into the dictionary, for example, Lua booleans, numbers, or strings.

The first argument to this method must be the dictionary object itself, for example,

```lua

 local cats = ngx.shared.cats
 local value, flags = cats.get(cats, "Marry")
```

or use Lua's syntactic sugar for method calls:

```lua

 local cats = ngx.shared.cats
 local value, flags = cats:get("Marry")
```

These two forms are fundamentally equivalent.

If the user flags is `0` (the default), then no flags value will be returned.

This feature was first introduced in the `v0.3.1rc22` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.get_stale

**syntax:** _value, flags, stale = ngx.shared.DICT:get_stale(key)_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Similar to the [get](#ngxshareddictget) method but returns the value even if the key has already expired.

Returns a 3rd value, `stale`, indicating whether the key has expired or not.

Note that the value of an expired key is not guaranteed to be available so one should never rely on the availability of expired items.

This method was first introduced in the `0.8.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.set

**syntax:** _success, err, forcible = ngx.shared.DICT:set(key, value, exptime?, flags?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Unconditionally sets a key-value pair into the shm-based dictionary [ngx.shared.DICT](#ngxshareddict). Returns three values:

- `success`: boolean value to indicate whether the key-value pair is stored or not.
- `err`: textual error message, can be `"no memory"`.
- `forcible`: a boolean value to indicate whether other valid items have been removed forcibly when out of storage in the shared memory zone.

The `value` argument inserted can be Lua booleans, numbers, strings, or `nil`. Their value type will also be stored into the dictionary and the same data type can be retrieved later via the [get](#ngxshareddictget) method.

The optional `exptime` argument specifies expiration time (in seconds) for the inserted key-value pair. The time resolution is `0.001` seconds. If the `exptime` takes the value `0` (which is the default), then the item will never expire.

The optional `flags` argument specifies a user flags value associated with the entry to be stored. It can also be retrieved later with the value. The user flags is stored as an unsigned 32-bit integer internally. Defaults to `0`. The user flags argument was first introduced in the `v0.5.0rc2` release.

When it fails to allocate memory for the current key-value item, then `set` will try removing existing items in the storage according to the Least-Recently Used (LRU) algorithm. Note that, LRU takes priority over expiration time here. If up to tens of existing items have been removed and the storage left is still insufficient (either due to the total capacity limit specified by [lua_shared_dict](#lua_shared_dict) or memory segmentation), then the `err` return value will be `no memory` and `success` will be `false`.

If the sizes of items in the dictionary are not multiples or even powers of a certain value (like 2), it is easier to encounter `no memory` error because of memory fragmentation. It is recommended to use different dictionaries for different sizes of items.

When you encounter `no memory` error, you can also evict more least-recently-used items by retrying this method call more times to to make room for the current item.

If this method succeeds in storing the current item by forcibly removing other not-yet-expired items in the dictionary via LRU, the `forcible` return value will be `true`. If it stores the item without forcibly removing other valid items, then the return value `forcible` will be `false`.

The first argument to this method must be the dictionary object itself, for example,

```lua

 local cats = ngx.shared.cats
 local succ, err, forcible = cats.set(cats, "Marry", "it is a nice cat!")
```

or use Lua's syntactic sugar for method calls:

```lua

 local cats = ngx.shared.cats
 local succ, err, forcible = cats:set("Marry", "it is a nice cat!")
```

These two forms are fundamentally equivalent.

This feature was first introduced in the `v0.3.1rc22` release.

Please note that while internally the key-value pair is set atomically, the atomicity does not go across the method call boundary.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.safe_set

**syntax:** _ok, err = ngx.shared.DICT:safe_set(key, value, exptime?, flags?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Similar to the [set](#ngxshareddictset) method, but never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".

This feature was first introduced in the `v0.7.18` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.add

**syntax:** _success, err, forcible = ngx.shared.DICT:add(key, value, exptime?, flags?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Just like the [set](#ngxshareddictset) method, but only stores the key-value pair into the dictionary [ngx.shared.DICT](#ngxshareddict) if the key does _not_ exist.

If the `key` argument already exists in the dictionary (and not expired for sure), the `success` return value will be `false` and the `err` return value will be `"exists"`.

This feature was first introduced in the `v0.3.1rc22` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.safe_add

**syntax:** _ok, err = ngx.shared.DICT:safe_add(key, value, exptime?, flags?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Similar to the [add](#ngxshareddictadd) method, but never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".

This feature was first introduced in the `v0.7.18` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.replace

**syntax:** _success, err, forcible = ngx.shared.DICT:replace(key, value, exptime?, flags?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Just like the [set](#ngxshareddictset) method, but only stores the key-value pair into the dictionary [ngx.shared.DICT](#ngxshareddict) if the key _does_ exist.

If the `key` argument does _not_ exist in the dictionary (or expired already), the `success` return value will be `false` and the `err` return value will be `"not found"`.

This feature was first introduced in the `v0.3.1rc22` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.delete

**syntax:** _ngx.shared.DICT:delete(key)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Unconditionally removes the key-value pair from the shm-based dictionary [ngx.shared.DICT](#ngxshareddict).

It is equivalent to `ngx.shared.DICT:set(key, nil)`.

This feature was first introduced in the `v0.3.1rc22` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.incr

**syntax:** _newval, err, forcible? = ngx.shared.DICT:incr(key, value, init?, init_ttl?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

**optional requirement:** `resty.core.shdict` or `resty.core`

Increments the (numerical) value for `key` in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict) by the step value `value`. Returns the new resulting number if the operation is successfully completed or `nil` and an error message otherwise.

When the key does not exist or has already expired in the shared dictionary,

1. if the `init` argument is not specified or takes the value `nil`, this method will return `nil` and the error string `"not found"`, or
1. if the `init` argument takes a number value, this method will create a new `key` with the value `init + value`.

Like the [add](#ngxshareddictadd) method, it also overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone.

The optional `init_ttl` argument specifies expiration time (in seconds) of the value when it is initialized via the `init` argument. The time resolution is `0.001` seconds. If `init_ttl` takes the value `0` (which is the default), then the item will never expire. This argument cannot be provided without providing the `init` argument as well, and has no effect if the value already exists (e.g., if it was previously inserted via [set](#ngxshareddictset) or the likes).

**Note:** Usage of the `init_ttl` argument requires the `resty.core.shdict` or `resty.core` modules from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library. Example:

```lua

 require "resty.core"

 local cats = ngx.shared.cats
 local newval, err = cats:incr("black_cats", 1, 0, 0.1)

 print(newval) -- 1

 ngx.sleep(0.2)

 local val, err = cats:get("black_cats")
 print(val) -- nil
```

The `forcible` return value will always be `nil` when the `init` argument is not specified.

If this method succeeds in storing the current item by forcibly removing other not-yet-expired items in the dictionary via LRU, the `forcible` return value will be `true`. If it stores the item without forcibly removing other valid items, then the return value `forcible` will be `false`.

If the original value is not a valid Lua number in the dictionary, it will return `nil` and `"not a number"`.

The `value` argument and `init` argument can be any valid Lua numbers, like negative numbers or floating-point numbers.

This method was first introduced in the `v0.3.1rc22` release.

The optional `init` parameter was first added in the `v0.10.6` release.

The optional `init_ttl` parameter was introduced in the `v0.10.12rc2` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.lpush

**syntax:** _length, err = ngx.shared.DICT:lpush(key, value)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Inserts the specified (numerical or string) `value` at the head of the list named `key` in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict). Returns the number of elements in the list after the push operation.

If `key` does not exist, it is created as an empty list before performing the push operation. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.

It never overrides the (least recently used) unexpired items in the store when running out of storage in the shared memory zone. In this case, it will immediately return `nil` and the string "no memory".

This feature was first introduced in the `v0.10.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.rpush

**syntax:** _length, err = ngx.shared.DICT:rpush(key, value)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Similar to the [lpush](#ngxshareddictlpush) method, but inserts the specified (numerical or string) `value` at the tail of the list named `key`.

This feature was first introduced in the `v0.10.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.lpop

**syntax:** _val, err = ngx.shared.DICT:lpop(key)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Removes and returns the first element of the list named `key` in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict).

If `key` does not exist, it will return `nil`. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.

This feature was first introduced in the `v0.10.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.rpop

**syntax:** _val, err = ngx.shared.DICT:rpop(key)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Removes and returns the last element of the list named `key` in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict).

If `key` does not exist, it will return `nil`. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.

This feature was first introduced in the `v0.10.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.llen

**syntax:** _len, err = ngx.shared.DICT:llen(key)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Returns the number of elements in the list named `key` in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict).

If key does not exist, it is interpreted as an empty list and 0 is returned. When the `key` already takes a value that is not a list, it will return `nil` and `"value not a list"`.

This feature was first introduced in the `v0.10.6` release.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.ttl

**syntax:** _ttl, err = ngx.shared.DICT:ttl(key)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

**requires:** `resty.core.shdict` or `resty.core`

Retrieves the remaining TTL (time-to-live in seconds) of a key-value pair in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict). Returns the TTL as a number if the operation is successfully completed or `nil` and an error message otherwise.

If the key does not exist (or has already expired), this method will return `nil` and the error string `"not found"`.

The TTL is originally determined by the `exptime` argument of the [set](#ngxshareddictset), [add](#ngxshareddictadd), [replace](#ngxshareddictreplace) (and the likes) methods. It has a time resolution of `0.001` seconds. A value of `0` means that the item will never expire.

Example:

```lua

 require "resty.core"

 local cats = ngx.shared.cats
 local succ, err = cats:set("Marry", "a nice cat", 0.5)

 ngx.sleep(0.2)

 local ttl, err = cats:ttl("Marry")
 ngx.say(ttl) -- 0.3
```

This feature was first introduced in the `v0.10.11` release.

**Note:** This method requires the `resty.core.shdict` or `resty.core` modules from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.expire

**syntax:** _success, err = ngx.shared.DICT:expire(key, exptime)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

**requires:** `resty.core.shdict` or `resty.core`

Updates the `exptime` (in second) of a key-value pair in the shm-based dictionary [ngx.shared.DICT](#ngxshareddict). Returns a boolean indicating success if the operation completes or `nil` and an error message otherwise.

If the key does not exist, this method will return `nil` and the error string `"not found"`.

The `exptime` argument has a resolution of `0.001` seconds. If `exptime` is `0`, then the item will never expire.

Example:

```lua

 require "resty.core"

 local cats = ngx.shared.cats
 local succ, err = cats:set("Marry", "a nice cat", 0.1)

 succ, err = cats:expire("Marry", 0.5)

 ngx.sleep(0.2)

 local val, err = cats:get("Marry")
 ngx.say(val) -- "a nice cat"
```

This feature was first introduced in the `v0.10.11` release.

**Note:** This method requires the `resty.core.shdict` or `resty.core` modules from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.flush_all

**syntax:** _ngx.shared.DICT:flush_all()_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Flushes out all the items in the dictionary. This method does not actually free up all the memory blocks in the dictionary but just marks all the existing items as expired.

This feature was first introduced in the `v0.5.0rc17` release.

See also [ngx.shared.DICT.flush_expired](#ngxshareddictflush_expired) and [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.flush_expired

**syntax:** _flushed = ngx.shared.DICT:flush_expired(max_count?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Flushes out the expired items in the dictionary, up to the maximal number specified by the optional `max_count` argument. When the `max_count` argument is given `0` or not given at all, then it means unlimited. Returns the number of items that have actually been flushed.

Unlike the [flush_all](#ngxshareddictflush_all) method, this method actually frees up the memory used by the expired items.

This feature was first introduced in the `v0.6.3` release.

See also [ngx.shared.DICT.flush_all](#ngxshareddictflush_all) and [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.get_keys

**syntax:** _keys = ngx.shared.DICT:get_keys(max_count?)_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Fetch a list of the keys from the dictionary, up to `<max_count>`.

By default, only the first 1024 keys (if any) are returned. When the `<max_count>` argument is given the value `0`, then all the keys will be returned even there is more than 1024 keys in the dictionary.

**CAUTION** Avoid calling this method on dictionaries with a very large number of keys as it may lock the dictionary for significant amount of time and block Nginx worker processes trying to access the dictionary.

This feature was first introduced in the `v0.7.3` release.

## ngx.shared.DICT.capacity

**syntax:** _capacity_bytes = ngx.shared.DICT:capacity()_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

**requires:** `resty.core.shdict` or `resty.core`

Retrieves the capacity in bytes for the shm-based dictionary [ngx.shared.DICT](#ngxshareddict) declared with
the [lua_shared_dict](#lua_shared_dict) directive.

Example:

```lua

 require "resty.core.shdict"

 local cats = ngx.shared.cats
 local capacity_bytes = cats:capacity()
```

This feature was first introduced in the `v0.10.11` release.

**Note:** This method requires the `resty.core.shdict` or `resty.core` modules from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library.

This feature requires at least Nginx core version `0.7.3`.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.shared.DICT.free_space

**syntax:** _free_page_bytes = ngx.shared.DICT:free_space()_

**context:** _init_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

**requires:** `resty.core.shdict` or `resty.core`

Retrieves the free page size in bytes for the shm-based dictionary [ngx.shared.DICT](#ngxshareddict).

**Note:** The memory for ngx.shared.DICT is allocated via the Nginx slab allocator which has each slot for
data size ranges like \~8, 9\~16, 17\~32, ..., 1025\~2048, 2048\~ bytes. And pages are assigned to a slot if there
is no room in already assigned pages for the slot.

So even if the return value of the `free_space` method is zero, there may be room in already assigned pages, so
you may successfully set a new key value pair to the shared dict without getting `true` for `forcible` or
non nil `err` from the `ngx.shared.DICT.set`.

On the other hand, if already assigned pages for a slot are full and a new key value pair is added to the
slot and there is no free page, you may get `true` for `forcible` or non nil `err` from the
`ngx.shared.DICT.set` method.

Example:

```lua

 require "resty.core.shdict"

 local cats = ngx.shared.cats
 local free_page_bytes = cats:free_space()
```

This feature was first introduced in the `v0.10.11` release.

**Note:** This method requires the `resty.core.shdict` or `resty.core` modules from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library.

This feature requires at least Nginx core version `1.11.7`.

See also [ngx.shared.DICT](#ngxshareddict).

## ngx.socket.udp

**syntax:** _udpsock = ngx.socket.udp()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Creates and returns a UDP or datagram-oriented unix domain socket object (also known as one type of the "cosocket" objects). The following methods are supported on this object:

- [setpeername](#udpsocksetpeername)
- [send](#udpsocksend)
- [receive](#udpsockreceive)
- [close](#udpsockclose)
- [settimeout](#udpsocksettimeout)

It is intended to be compatible with the UDP API of the [LuaSocket](http://w3.impa.br/~diego/software/luasocket/udp.html) library but is 100% nonblocking out of the box.

This feature was first introduced in the `v0.5.7` release.

See also [ngx.socket.tcp](#ngxsockettcp).

## udpsock:setpeername

**syntax:** _ok, err = udpsock:setpeername(host, port)_

**syntax:** _ok, err = udpsock:setpeername("unix:/path/to/unix-domain.socket")_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Attempts to connect a UDP socket object to a remote server or to a datagram unix domain socket file. Because the datagram protocol is actually connection-less, this method does not really establish a "connection", but only just set the name of the remote peer for subsequent read/write operations.

Both IP addresses and domain names can be specified as the `host` argument. In case of domain names, this method will use Nginx core's dynamic resolver to parse the domain name without blocking and it is required to configure the [resolver](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive in the `nginx.conf` file like this:

```nginx

 resolver 8.8.8.8;  # use Google's public DNS nameserver
```

If the nameserver returns multiple IP addresses for the host name, this method will pick up one randomly.

In case of error, the method returns `nil` followed by a string describing the error. In case of success, the method returns `1`.

Here is an example for connecting to a UDP (memcached) server:

```nginx

 location /test {
     resolver 8.8.8.8;

     content_by_lua_block {
         local sock = ngx.socket.udp()
         local ok, err = sock:setpeername("my.memcached.server.domain", 11211)
         if not ok then
             ngx.say("failed to connect to memcached: ", err)
             return
         end
         ngx.say("successfully connected to memcached!")
         sock:close()
     }
 }
```

Since the `v0.7.18` release, connecting to a datagram unix domain socket file is also possible on Linux:

```lua

 local sock = ngx.socket.udp()
 local ok, err = sock:setpeername("unix:/tmp/some-datagram-service.sock")
 if not ok then
     ngx.say("failed to connect to the datagram unix domain socket: ", err)
     return
 end

 -- do something after connect
 -- such as sock:send or sock:receive
```

assuming the datagram service is listening on the unix domain socket file `/tmp/some-datagram-service.sock` and the client socket will use the "autobind" feature on Linux.

Calling this method on an already connected socket object will cause the original connection to be closed first.

This method was first introduced in the `v0.5.7` release.

## udpsock:send

**syntax:** _ok, err = udpsock:send(data)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Sends data on the current UDP or datagram unix domain socket object.

In case of success, it returns `1`. Otherwise, it returns `nil` and a string describing the error.

The input argument `data` can either be a Lua string or a (nested) Lua table holding string fragments. In case of table arguments, this method will copy all the string elements piece by piece to the underlying Nginx socket send buffers, which is usually optimal than doing string concatenation operations on the Lua land.

This feature was first introduced in the `v0.5.7` release.

## udpsock:receive

**syntax:** _data, err = udpsock:receive(size?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Receives data from the UDP or datagram unix domain socket object with an optional receive buffer size argument, `size`.

This method is a synchronous operation and is 100% nonblocking.

In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error.

If the `size` argument is specified, then this method will use this size as the receive buffer size. But when this size is greater than `8192`, then `8192` will be used instead.

If no argument is specified, then the maximal buffer size, `8192` is assumed.

Timeout for the reading operation is controlled by the [lua_socket_read_timeout](#lua_socket_read_timeout) config directive and the [settimeout](#udpsocksettimeout) method. And the latter takes priority. For example:

```lua

 sock:settimeout(1000)  -- one second timeout
 local data, err = sock:receive()
 if not data then
     ngx.say("failed to read a packet: ", err)
     return
 end
 ngx.say("successfully read a packet: ", data)
```

It is important here to call the [settimeout](#udpsocksettimeout) method _before_ calling this method.

This feature was first introduced in the `v0.5.7` release.

## udpsock:close

**syntax:** _ok, err = udpsock:close()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Closes the current UDP or datagram unix domain socket. It returns the `1` in case of success and returns `nil` with a string describing the error otherwise.

Socket objects that have not invoked this method (and associated connections) will be closed when the socket object is released by the Lua GC (Garbage Collector) or the current client HTTP request finishes processing.

This feature was first introduced in the `v0.5.7` release.

## udpsock:settimeout

**syntax:** _udpsock:settimeout(time)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Set the timeout value in milliseconds for subsequent socket operations (like [receive](#udpsockreceive)).

Settings done by this method takes priority over those config directives, like [lua_socket_read_timeout](#lua_socket_read_timeout).

This feature was first introduced in the `v0.5.7` release.

## ngx.socket.stream

Just an alias to [ngx.socket.tcp](#ngxsockettcp). If the stream-typed cosocket may also connect to a unix domain
socket, then this API name is preferred.

This API function was first added to the `v0.10.1` release.

## ngx.socket.tcp

**syntax:** _tcpsock = ngx.socket.tcp()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Creates and returns a TCP or stream-oriented unix domain socket object (also known as one type of the "cosocket" objects). The following methods are supported on this object:

- [connect](#tcpsockconnect)
- [sslhandshake](#tcpsocksslhandshake)
- [send](#tcpsocksend)
- [receive](#tcpsockreceive)
- [close](#tcpsockclose)
- [settimeout](#tcpsocksettimeout)
- [settimeouts](#tcpsocksettimeouts)
- [setoption](#tcpsocksetoption)
- [receiveany](#tcpsockreceiveany)
- [receiveuntil](#tcpsockreceiveuntil)
- [setkeepalive](#tcpsocksetkeepalive)
- [getreusedtimes](#tcpsockgetreusedtimes)

It is intended to be compatible with the TCP API of the [LuaSocket](http://w3.impa.br/~diego/software/luasocket/tcp.html) library but is 100% nonblocking out of the box. Also, we introduce some new APIs to provide more functionalities.

The cosocket object created by this API function has exactly the same lifetime as the Lua handler creating it. So never pass the cosocket object to any other Lua handler (including ngx.timer callback functions) and never share the cosocket object between different Nginx requests.

For every cosocket object's underlying connection, if you do not
explicitly close it (via [close](#tcpsockclose)) or put it back to the connection
pool (via [setkeepalive](#tcpsocksetkeepalive)), then it is automatically closed when one of
the following two events happens:

- the current request handler completes, or
- the Lua cosocket object value gets collected by the Lua GC.

Fatal errors in cosocket operations always automatically close the current
connection (note that, read timeout error is the only error that is
not fatal), and if you call [close](#tcpsockclose) on a closed connection, you will get
the "closed" error.

Starting from the `0.9.9` release, the cosocket object here is full-duplex, that is, a reader "light thread" and a writer "light thread" can operate on a single cosocket object simultaneously (both "light threads" must belong to the same Lua handler though, see reasons above). But you cannot have two "light threads" both reading (or writing or connecting) the same cosocket, otherwise you might get an error like "socket busy reading" when calling the methods of the cosocket object.

This feature was first introduced in the `v0.5.0rc1` release.

See also [ngx.socket.udp](#ngxsocketudp).

## tcpsock:connect

**syntax:** _ok, err = tcpsock:connect(host, port, options_table?)_

**syntax:** _ok, err = tcpsock:connect("unix:/path/to/unix-domain.socket", options_table?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Attempts to connect a TCP socket object to a remote server or to a stream unix domain socket file without blocking.

Before actually resolving the host name and connecting to the remote backend, this method will always look up the connection pool for matched idle connections created by previous calls of this method (or the [ngx.socket.connect](#ngxsocketconnect) function).

Both IP addresses and domain names can be specified as the `host` argument. In case of domain names, this method will use Nginx core's dynamic resolver to parse the domain name without blocking and it is required to configure the [resolver](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive in the `nginx.conf` file like this:

```nginx

 resolver 8.8.8.8;  # use Google's public DNS nameserver
```

If the nameserver returns multiple IP addresses for the host name, this method will pick up one randomly.

In case of error, the method returns `nil` followed by a string describing the error. In case of success, the method returns `1`.

Here is an example for connecting to a TCP server:

```nginx

 location /test {
     resolver 8.8.8.8;

     content_by_lua_block {
         local sock = ngx.socket.tcp()
         local ok, err = sock:connect("www.google.com", 80)
         if not ok then
             ngx.say("failed to connect to google: ", err)
             return
         end
         ngx.say("successfully connected to google!")
         sock:close()
     }
 }
```

Connecting to a Unix Domain Socket file is also possible:

```lua

 local sock = ngx.socket.tcp()
 local ok, err = sock:connect("unix:/tmp/memcached.sock")
 if not ok then
     ngx.say("failed to connect to the memcached unix domain socket: ", err)
     return
 end

 -- do something after connect
 -- such as sock:send or sock:receive
```

assuming memcached (or something else) is listening on the unix domain socket file `/tmp/memcached.sock`.

Timeout for the connecting operation is controlled by the [lua_socket_connect_timeout](#lua_socket_connect_timeout) config directive and the [settimeout](#tcpsocksettimeout) method. And the latter takes priority. For example:

```lua

 local sock = ngx.socket.tcp()
 sock:settimeout(1000)  -- one second timeout
 local ok, err = sock:connect(host, port)
```

It is important here to call the [settimeout](#tcpsocksettimeout) method _before_ calling this method.

Calling this method on an already connected socket object will cause the original connection to be closed first.

An optional Lua table can be specified as the last argument to this method to specify various connect options:

- `pool`
  specify a custom name for the connection pool being used. If omitted, then the connection pool name will be generated from the string template `"<host>:<port>"` or `"<unix-socket-path>"`.

- `pool_size`
  specify the size of the connection pool. If omitted and no
  `backlog` option was provided, no pool will be created. If omitted
  but `backlog` was provided, the pool will be created with a default
  size equal to the value of the [lua_socket_pool_size](#lua_socket_pool_size)
  directive.
  The connection pool holds up to `pool_size` alive connections
  ready to be reused by subsequent calls to [connect](#tcpsockconnect), but
  note that there is no upper limit to the total number of opened connections
  outside of the pool. If you need to restrict the total number of opened
  connections, specify the `backlog` option.
  When the connection pool would exceed its size limit, the least recently used
  (kept-alive) connection already in the pool will be closed to make room for
  the current connection.
  Note that the cosocket connection pool is per Nginx worker process rather
  than per Nginx server instance, so the size limit specified here also applies
  to every single Nginx worker process. Also note that the size of the connection
  pool cannot be changed once it has been created.
  This option was first introduced in the `v0.10.14` release.

- `backlog`
  if specified, this module will limit the total number of opened connections
  for this pool. No more connections than `pool_size` can be opened
  for this pool at any time. If the connection pool is full, subsequent
  connect operations will be queued into a queue equal to this option's
  value (the "backlog" queue).
  If the number of queued connect operations is equal to `backlog`,
  subsequent connect operations will fail and return `nil` plus the
  error string `"too many waiting connect operations"`.
  The queued connect operations will be resumed once the number of connections
  in the pool is less than `pool_size`.
  The queued connect operation will abort once they have been queued for more
  than `connect_timeout`, controlled by
  [settimeouts](#tcpsocksettimeouts), and will return `nil` plus
  the error string `"timeout"`.
  This option was first introduced in the `v0.10.14` release.

The support for the options table argument was first introduced in the `v0.5.7` release.

This method was first introduced in the `v0.5.0rc1` release.

## tcpsock:sslhandshake

**syntax:** _session, err = tcpsock:sslhandshake(reused_session?, server_name?, ssl_verify?, send_status_req?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Does SSL/TLS handshake on the currently established connection.

The optional `reused_session` argument can take a former SSL
session userdata returned by a previous `sslhandshake`
call for exactly the same target. For short-lived connections, reusing SSL
sessions can usually speed up the handshake by one order by magnitude but it
is not so useful if the connection pool is enabled. This argument defaults to
`nil`. If this argument takes the boolean `false` value, no SSL session
userdata would return by this call and only a Lua boolean will be returned as
the first return value; otherwise the current SSL session will
always be returned as the first argument in case of successes.

The optional `server_name` argument is used to specify the server
name for the new TLS extension Server Name Indication (SNI). Use of SNI can
make different servers share the same IP address on the server side. Also,
when SSL verification is enabled, this `server_name` argument is
also used to validate the server name specified in the server certificate sent from
the remote.

The optional `ssl_verify` argument takes a Lua boolean value to
control whether to perform SSL verification. When set to `true`, the server
certificate will be verified according to the CA certificates specified by
the [lua_ssl_trusted_certificate](#lua_ssl_trusted_certificate) directive.
You may also need to adjust the [lua_ssl_verify_depth](#lua_ssl_verify_depth)
directive to control how deep we should follow along the certificate chain.
Also, when the `ssl_verify` argument is true and the
`server_name` argument is also specified, the latter will be used
to validate the server name in the server certificate.

The optional `send_status_req` argument takes a boolean that controls whether to send
the OCSP status request in the SSL handshake request (which is for requesting OCSP stapling).

For connections that have already done SSL/TLS handshake, this method returns
immediately.

This method was first introduced in the `v0.9.11` release.

## tcpsock:send

**syntax:** _bytes, err = tcpsock:send(data)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Sends data without blocking on the current TCP or Unix Domain Socket connection.

This method is a synchronous operation that will not return until _all_ the data has been flushed into the system socket send buffer or an error occurs.

In case of success, it returns the total number of bytes that have been sent. Otherwise, it returns `nil` and a string describing the error.

The input argument `data` can either be a Lua string or a (nested) Lua table holding string fragments. In case of table arguments, this method will copy all the string elements piece by piece to the underlying Nginx socket send buffers, which is usually optimal than doing string concatenation operations on the Lua land.

Timeout for the sending operation is controlled by the [lua_socket_send_timeout](#lua_socket_send_timeout) config directive and the [settimeout](#tcpsocksettimeout) method. And the latter takes priority. For example:

```lua

 sock:settimeout(1000)  -- one second timeout
 local bytes, err = sock:send(request)
```

It is important here to call the [settimeout](#tcpsocksettimeout) method _before_ calling this method.

In case of any connection errors, this method always automatically closes the current connection.

This feature was first introduced in the `v0.5.0rc1` release.

## tcpsock:receive

**syntax:** _data, err, partial = tcpsock:receive(size)_

**syntax:** _data, err, partial = tcpsock:receive(pattern?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Receives data from the connected socket according to the reading pattern or size.

This method is a synchronous operation just like the [send](#tcpsocksend) method and is 100% nonblocking.

In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error and the partial data received so far.

If a number-like argument is specified (including strings that look like numbers), then it is interpreted as a size. This method will not return until it reads exactly this size of data or an error occurs.

If a non-number-like string argument is specified, then it is interpreted as a "pattern". The following patterns are supported:

- `'*a'`: reads from the socket until the connection is closed. No end-of-line translation is performed;
- `'*l'`: reads a line of text from the socket. The line is terminated by a `Line Feed` (LF) character (ASCII 10), optionally preceded by a `Carriage Return` (CR) character (ASCII 13). The CR and LF characters are not included in the returned line. In fact, all CR characters are ignored by the pattern.

If no argument is specified, then it is assumed to be the pattern `'*l'`, that is, the line reading pattern.

Timeout for the reading operation is controlled by the [lua_socket_read_timeout](#lua_socket_read_timeout) config directive and the [settimeout](#tcpsocksettimeout) method. And the latter takes priority. For example:

```lua

 sock:settimeout(1000)  -- one second timeout
 local line, err, partial = sock:receive()
 if not line then
     ngx.say("failed to read a line: ", err)
     return
 end
 ngx.say("successfully read a line: ", line)
```

It is important here to call the [settimeout](#tcpsocksettimeout) method _before_ calling this method.

Since the `v0.8.8` release, this method no longer automatically closes the current connection when the read timeout error happens. For other connection errors, this method always automatically closes the connection.

This feature was first introduced in the `v0.5.0rc1` release.

## tcpsock:receiveany

**syntax:** _data, err = tcpsock:receiveany(max)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Returns any data received by the connected socket, at most `max` bytes.

This method is a synchronous operation just like the [send](#tcpsocksend) method and is 100% nonblocking.

In case of success, it returns the data received; in case of error, it returns `nil` with a string describing the error.

If the received data is more than this size, this method will return with exactly this size of data.
The remaining data in the underlying receive buffer could be returned in the next reading operation.

Timeout for the reading operation is controlled by the [lua_socket_read_timeout](#lua_socket_read_timeout) config directive and the [settimeouts](#tcpsocksettimeouts) method. And the latter takes priority. For example:

```lua

 sock:settimeouts(1000, 1000, 1000)  -- one second timeout for connect/read/write
 local data, err = sock:receiveany(10 * 1024) -- read any data, at most 10K
 if not data then
     ngx.say("failed to read any data: ", err)
     return
 end
 ngx.say("successfully read: ", data)
```

This method doesn't automatically close the current connection when the read timeout error occurs. For other connection errors, this method always automatically closes the connection.

This feature was first introduced in the `v0.10.14` release.

## tcpsock:receiveuntil

**syntax:** _iterator = tcpsock:receiveuntil(pattern, options?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

This method returns an iterator Lua function that can be called to read the data stream until it sees the specified pattern or an error occurs.

Here is an example for using this method to read a data stream with the boundary sequence `--abcedhb`:

```lua

 local reader = sock:receiveuntil("\r\n--abcedhb")
 local data, err, partial = reader()
 if not data then
     ngx.say("failed to read the data stream: ", err)
 end
 ngx.say("read the data stream: ", data)
```

When called without any argument, the iterator function returns the received data right _before_ the specified pattern string in the incoming data stream. So for the example above, if the incoming data stream is `'hello, world! -agentzh\r\n--abcedhb blah blah'`, then the string `'hello, world! -agentzh'` will be returned.

In case of error, the iterator function will return `nil` along with a string describing the error and the partial data bytes that have been read so far.

The iterator function can be called multiple times and can be mixed safely with other cosocket method calls or other iterator function calls.

The iterator function behaves differently (i.e., like a real iterator) when it is called with a `size` argument. That is, it will read that `size` of data on each invocation and will return `nil` at the last invocation (either sees the boundary pattern or meets an error). For the last successful invocation of the iterator function, the `err` return value will be `nil` too. The iterator function will be reset after the last successful invocation that returns `nil` data and `nil` error. Consider the following example:

```lua

 local reader = sock:receiveuntil("\r\n--abcedhb")

 while true do
     local data, err, partial = reader(4)
     if not data then
         if err then
             ngx.say("failed to read the data stream: ", err)
             break
         end

         ngx.say("read done")
         break
     end
     ngx.say("read chunk: [", data, "]")
 end
```

Then for the incoming data stream `'hello, world! -agentzh\r\n--abcedhb blah blah'`, we shall get the following output from the sample code above:

```default
read chunk: [hell]
read chunk: [o, w]
read chunk: [orld]
read chunk: [! -a]
read chunk: [gent]
read chunk: [zh]
read done
```

Note that, the actual data returned _might_ be a little longer than the size limit specified by the `size` argument when the boundary pattern has ambiguity for streaming parsing. Near the boundary of the data stream, the data string actually returned could also be shorter than the size limit.

Timeout for the iterator function's reading operation is controlled by the [lua_socket_read_timeout](#lua_socket_read_timeout) config directive and the [settimeout](#tcpsocksettimeout) method. And the latter takes priority. For example:

```lua

 local readline = sock:receiveuntil("\r\n")

 sock:settimeout(1000)  -- one second timeout
 line, err, partial = readline()
 if not line then
     ngx.say("failed to read a line: ", err)
     return
 end
 ngx.say("successfully read a line: ", line)
```

It is important here to call the [settimeout](#tcpsocksettimeout) method _before_ calling the iterator function (note that the `receiveuntil` call is irrelevant here).

As from the `v0.5.1` release, this method also takes an optional `options` table argument to control the behavior. The following options are supported:

- `inclusive`

The `inclusive` takes a boolean value to control whether to include the pattern string in the returned data string. Default to `false`. For example,

```lua

 local reader = tcpsock:receiveuntil("_END_", { inclusive = true })
 local data = reader()
 ngx.say(data)
```

Then for the input data stream `"hello world _END_ blah blah blah"`, then the example above will output `hello world _END_`, including the pattern string `_END_` itself.

Since the `v0.8.8` release, this method no longer automatically closes the current connection when the read timeout error happens. For other connection errors, this method always automatically closes the connection.

This method was first introduced in the `v0.5.0rc1` release.

## tcpsock:close

**syntax:** _ok, err = tcpsock:close()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Closes the current TCP or stream unix domain socket. It returns the `1` in case of success and returns `nil` with a string describing the error otherwise.

Note that there is no need to call this method on socket objects that have invoked the [setkeepalive](#tcpsocksetkeepalive) method because the socket object is already closed (and the current connection is saved into the built-in connection pool).

Socket objects that have not invoked this method (and associated connections) will be closed when the socket object is released by the Lua GC (Garbage Collector) or the current client HTTP request finishes processing.

This feature was first introduced in the `v0.5.0rc1` release.

## tcpsock:settimeout

**syntax:** _tcpsock:settimeout(time)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Set the timeout value in milliseconds for subsequent socket operations ([connect](#tcpsockconnect), [receive](#tcpsockreceive), and iterators returned from [receiveuntil](#tcpsockreceiveuntil)).

Settings done by this method take priority over those specified via config directives (i.e. [lua_socket_connect_timeout](#lua_socket_connect_timeout), [lua_socket_send_timeout](#lua_socket_send_timeout), and [lua_socket_read_timeout](#lua_socket_read_timeout)).

Note that this method does _not_ affect the [lua_socket_keepalive_timeout](#lua_socket_keepalive_timeout) setting; the `timeout` argument to the [setkeepalive](#tcpsocksetkeepalive) method should be used for this purpose instead.

This feature was first introduced in the `v0.5.0rc1` release.

## tcpsock:settimeouts

**syntax:** _tcpsock:settimeouts(connect_timeout, send_timeout, read_timeout)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Respectively sets the connect, send, and read timeout thresholds (in milliseconds) for subsequent socket
operations ([connect](#tcpsockconnect), [send](#tcpsocksend), [receive](#tcpsockreceive), and iterators returned from [receiveuntil](#tcpsockreceiveuntil)).

Settings done by this method take priority over those specified via config directives (i.e. [lua_socket_connect_timeout](#lua_socket_connect_timeout), [lua_socket_send_timeout](#lua_socket_send_timeout), and [lua_socket_read_timeout](#lua_socket_read_timeout)).

It is recommended to use [settimeouts](#tcpsocksettimeouts) instead of [settimeout](#tcpsocksettimeout).

Note that this method does _not_ affect the [lua_socket_keepalive_timeout](#lua_socket_keepalive_timeout) setting; the `timeout` argument to the [setkeepalive](#tcpsocksetkeepalive) method should be used for this purpose instead.

This feature was first introduced in the `v0.10.7` release.

## tcpsock:setoption

**syntax:** _ok, err = tcpsock:setoption(option, value?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

This function is added for [LuaSocket](http://w3.impa.br/~diego/software/luasocket/tcp.html) API compatibility and does nothing for now. Its functionality is implemented `v0.10.18`.

This feature was first introduced in the `v0.5.0rc1` release.

In case of success, it returns `true`. Otherwise, it returns nil and a string describing the error.

The `option` is a string with the option name, and the value depends on the option being set:

- `keepalive`

  Setting this option to true enables sending of keep-alive messages on
  connection-oriented sockets. Make sure the `connect` function
  had been called before, for example,

  ```lua

  local ok, err = tcpsock:setoption("keepalive", true)
  if not ok then
      ngx.say("setoption keepalive failed: ", err)
  end
  ```

- `reuseaddr`

  Enabling this option indicates that the rules used in validating addresses
  supplied in a call to bind should allow reuse of local addresses. Make sure
  the `connect` function had been called before, for example,

  ```lua

  local ok, err = tcpsock:setoption("reuseaddr", 0)
  if not ok then
      ngx.say("setoption reuseaddr failed: ", err)
  end
  ```

- `tcp-nodelay`

  Setting this option to true disables the Nagle's algorithm for the connection.
  Make sure the `connect` function had been called before, for example,

  ```lua

  local ok, err = tcpsock:setoption("tcp-nodelay", true)
  if not ok then
      ngx.say("setoption tcp-nodelay failed: ", err)
  end
  ```

- `sndbuf`

  Sets the maximum socket send buffer in bytes. The kernel doubles this value
  (to allow space for bookkeeping overhead) when it is set using setsockopt().
  Make sure the `connect` function had been called before, for example,

  ```lua

  local ok, err = tcpsock:setoption("sndbuf", 1024 * 10)
  if not ok then
      ngx.say("setoption sndbuf failed: ", err)
  end
  ```

- `rcvbuf`

  Sets the maximum socket receive buffer in bytes. The kernel doubles this value
  (to allow space for bookkeeping overhead) when it is set using setsockopt. Make
  sure the `connect` function had been called before, for example,

  ```lua

  local ok, err = tcpsock:setoption("rcvbuf", 1024 * 10)
  if not ok then
      ngx.say("setoption rcvbuf failed: ", err)
  end
  ```

NOTE: Once the option is set, it will become effective until the connection is closed. If you know the connection is from the connection pool and all the in-pool connections already have called the setoption() method with the desired socket option state, then you can just skip calling setoption() again to avoid the overhead of repeated calls, for example,

```lua

 local count, err = tcpsock:getreusedtimes()
 if not count then
     ngx.say("getreusedtimes failed: ", err)
     return
 end

 if count == 0 then
     local ok, err = tcpsock:setoption("rcvbuf", 1024 * 10)
     if not ok then
         ngx.say("setoption rcvbuf failed: ", err)
         return
     end
 end
```

These options described above are supported in `v0.10.18`, and more options will be implemented in future.

## tcpsock:setkeepalive

**syntax:** _ok, err = tcpsock:setkeepalive(timeout?, size?)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Puts the current socket's connection immediately into the cosocket built-in connection pool and keep it alive until other [connect](#tcpsockconnect) method calls request it or the associated maximal idle timeout is expired.

The first optional argument, `timeout`, can be used to specify the maximal idle timeout (in milliseconds) for the current connection. If omitted, the default setting in the [lua_socket_keepalive_timeout](#lua_socket_keepalive_timeout) config directive will be used. If the `0` value is given, then the timeout interval is unlimited.

The second optional argument `size` is considered deprecated since
the `v0.10.14` release of this module, in favor of the
`pool_size` option of the [connect](#tcpsockconnect) method.
Since the `v0.10.14` release, this option will only take effect if
the call to [connect](#tcpsockconnect) did not already create a connection
pool.
When this option takes effect (no connection pool was previously created by
[connect](#tcpsockconnect)), it will specify the size of the connection pool,
and create it.
If omitted (and no pool was previously created), the default size is the value
of the [lua_socket_pool_size](#lua_socket_pool_size) directive.
The connection pool holds up to `size` alive connections ready to be
reused by subsequent calls to [connect](#tcpsockconnect), but note that there
is no upper limit to the total number of opened connections outside of the
pool.
When the connection pool would exceed its size limit, the least recently used
(kept-alive) connection already in the pool will be closed to make room for
the current connection.
Note that the cosocket connection pool is per Nginx worker process rather
than per Nginx server instance, so the size limit specified here also applies
to every single Nginx worker process. Also note that the size of the connection
pool cannot be changed once it has been created.
If you need to restrict the total number of opened connections, specify both
the `pool_size` and `backlog` option in the call to
[connect](#tcpsockconnect).

In case of success, this method returns `1`; otherwise, it returns `nil` and a string describing the error.

When the system receive buffer for the current connection has unread data, then this method will return the "connection in dubious state" error message (as the second return value) because the previous session has unread data left behind for the next session and the connection is not safe to be reused.

This method also makes the current cosocket object enter the "closed" state, so there is no need to manually call the [close](#tcpsockclose) method on it afterwards.

This feature was first introduced in the `v0.5.0rc1` release.

## tcpsock:getreusedtimes

**syntax:** _count, err = tcpsock:getreusedtimes()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

This method returns the (successfully) reused times for the current connection. In case of error, it returns `nil` and a string describing the error.

If the current connection does not come from the built-in connection pool, then this method always returns `0`, that is, the connection has never been reused (yet). If the connection comes from the connection pool, then the return value is always non-zero. So this method can also be used to determine if the current connection comes from the pool.

This feature was first introduced in the `v0.5.0rc1` release.

## ngx.socket.connect

**syntax:** _tcpsock, err = ngx.socket.connect(host, port)_

**syntax:** _tcpsock, err = ngx.socket.connect("unix:/path/to/unix-domain.socket")_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*_

This function is a shortcut for combining [ngx.socket.tcp()](#ngxsockettcp) and the [connect()](#tcpsockconnect) method call in a single operation. It is actually implemented like this:

```lua

 local sock = ngx.socket.tcp()
 local ok, err = sock:connect(...)
 if not ok then
     return nil, err
 end
 return sock
```

There is no way to use the [settimeout](#tcpsocksettimeout) method to specify connecting timeout for this method and the [lua_socket_connect_timeout](#lua_socket_connect_timeout) directive must be set at configure time instead.

This feature was first introduced in the `v0.5.0rc1` release.

## ngx.get_phase

**syntax:** _str = ngx.get_phase()_

**context:** _init_by_lua\*, init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Retrieves the current running phase name. Possible return values are

- `init`
  for the context of [init_by_lua\*](#init_by_lua).
- `init_worker`
  for the context of [init_worker_by_lua\*](#init_worker_by_lua).
- `ssl_cert`
  for the context of [ssl_certificate_by_lua\*](#ssl_certificate_by_lua_block).
- `ssl_session_fetch`
  for the context of [ssl_session_fetch_by_lua\*](#ssl_session_fetch_by_lua_block).
- `ssl_session_store`
  for the context of [ssl_session_store_by_lua\*](#ssl_session_store_by_lua_block).
- `set`
  for the context of [set_by_lua\*](#set_by_lua).
- `rewrite`
  for the context of [rewrite_by_lua\*](#rewrite_by_lua).
- `balancer`
  for the context of [balancer_by_lua\*](#balancer_by_lua_block).
- `access`
  for the context of [access_by_lua\*](#access_by_lua).
- `content`
  for the context of [content_by_lua\*](#content_by_lua).
- `header_filter`
  for the context of [header_filter_by_lua\*](#header_filter_by_lua).
- `body_filter`
  for the context of [body_filter_by_lua\*](#body_filter_by_lua).
- `log`
  for the context of [log_by_lua\*](#log_by_lua).
- `timer`
  for the context of user callback functions for [ngx.timer.\*](#ngxtimerat).
- `exit_worker`
  for the context of [exit_worker_by_lua\*](#exit_worker_by_lua).

This API was first introduced in the `v0.5.10` release.

## ngx.thread.spawn

**syntax:** _co = ngx.thread.spawn(func, arg1, arg2, ...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Spawns a new user "light thread" with the Lua function `func` as well as those optional arguments `arg1`, `arg2`, and etc. Returns a Lua thread (or Lua coroutine) object represents this "light thread".

"Light threads" are just a special kind of Lua coroutines that are scheduled by the ngx_lua module.

Before `ngx.thread.spawn` returns, the `func` will be called with those optional arguments until it returns, aborts with an error, or gets yielded due to I/O operations via the [Nginx API for Lua](#nginx-api-for-lua) (like [tcpsock:receive](#tcpsockreceive)).

After `ngx.thread.spawn` returns, the newly-created "light thread" will keep running asynchronously usually at various I/O events.

All the Lua code chunks running by [rewrite_by_lua](#rewrite_by_lua), [access_by_lua](#access_by_lua), and [content_by_lua](#content_by_lua) are in a boilerplate "light thread" created automatically by ngx_lua. Such boilerplate "light thread" are also called "entry threads".

By default, the corresponding Nginx handler (e.g., [rewrite_by_lua](#rewrite_by_lua) handler) will not terminate until

1. both the "entry thread" and all the user "light threads" terminates,
1. a "light thread" (either the "entry thread" or a user "light thread") aborts by calling [ngx.exit](#ngxexit), [ngx.exec](#ngxexec), [ngx.redirect](#ngxredirect), or [ngx.req.set_uri(uri, true)](#ngxreqset_uri), or
1. the "entry thread" terminates with a Lua error.

When the user "light thread" terminates with a Lua error, however, it will not abort other running "light threads" like the "entry thread" does.

Due to the limitation in the Nginx subrequest model, it is not allowed to abort a running Nginx subrequest in general. So it is also prohibited to abort a running "light thread" that is pending on one ore more Nginx subrequests. You must call [ngx.thread.wait](#ngxthreadwait) to wait for those "light thread" to terminate before quitting the "world". A notable exception here is that you can abort pending subrequests by calling [ngx.exit](#ngxexit) with and only with the status code `ngx.ERROR` (-1), `408`, `444`, or `499`.

The "light threads" are not scheduled in a pre-emptive way. In other words, no time-slicing is performed automatically. A "light thread" will keep running exclusively on the CPU until

1. a (nonblocking) I/O operation cannot be completed in a single run,
1. it calls [coroutine.yield](#coroutineyield) to actively give up execution, or
1. it is aborted by a Lua error or an invocation of [ngx.exit](#ngxexit), [ngx.exec](#ngxexec), [ngx.redirect](#ngxredirect), or [ngx.req.set_uri(uri, true)](#ngxreqset_uri).

For the first two cases, the "light thread" will usually be resumed later by the ngx_lua scheduler unless a "stop-the-world" event happens.

User "light threads" can create "light threads" themselves. And normal user coroutines created by [coroutine.create](#coroutinecreate) can also create "light threads". The coroutine (be it a normal Lua coroutine or a "light thread") that directly spawns the "light thread" is called the "parent coroutine" for the "light thread" newly spawned.

The "parent coroutine" can call [ngx.thread.wait](#ngxthreadwait) to wait on the termination of its child "light thread".

You can call coroutine.status() and coroutine.yield() on the "light thread" coroutines.

The status of the "light thread" coroutine can be "zombie" if

1. the current "light thread" already terminates (either successfully or with an error),
1. its parent coroutine is still alive, and
1. its parent coroutine is not waiting on it with [ngx.thread.wait](#ngxthreadwait).

The following example demonstrates the use of coroutine.yield() in the "light thread" coroutines
to do manual time-slicing:

```lua

 local yield = coroutine.yield

 function f()
     local self = coroutine.running()
     ngx.say("f 1")
     yield(self)
     ngx.say("f 2")
     yield(self)
     ngx.say("f 3")
 end

 local self = coroutine.running()
 ngx.say("0")
 yield(self)

 ngx.say("1")
 ngx.thread.spawn(f)

 ngx.say("2")
 yield(self)

 ngx.say("3")
 yield(self)

 ngx.say("4")
```

Then it will generate the output

```default
0
1
f 1
2
f 2
3
f 3
4
```

"Light threads" are mostly useful for making concurrent upstream requests in a single Nginx request handler, much like a generalized version of [ngx.location.capture_multi](#ngxlocationcapture_multi) that can work with all the [Nginx API for Lua](#nginx-api-for-lua). The following example demonstrates parallel requests to MySQL, Memcached, and upstream HTTP services in a single Lua handler, and outputting the results in the order that they actually return (similar to Facebook's BigPipe model):

```lua

 -- query mysql, memcached, and a remote http service at the same time,
 -- output the results in the order that they
 -- actually return the results.

 local mysql = require "resty.mysql"
 local memcached = require "resty.memcached"

 local function query_mysql()
     local db = mysql:new()
     db:connect{
                 host = "127.0.0.1",
                 port = 3306,
                 database = "test",
                 user = "monty",
                 password = "mypass"
               }
     local res, err, errno, sqlstate =
             db:query("select * from cats order by id asc")
     db:set_keepalive(0, 100)
     ngx.say("mysql done: ", cjson.encode(res))
 end

 local function query_memcached()
     local memc = memcached:new()
     memc:connect("127.0.0.1", 11211)
     local res, err = memc:get("some_key")
     ngx.say("memcached done: ", res)
 end

 local function query_http()
     local res = ngx.location.capture("/my-http-proxy")
     ngx.say("http done: ", res.body)
 end

 ngx.thread.spawn(query_mysql)      -- create thread 1
 ngx.thread.spawn(query_memcached)  -- create thread 2
 ngx.thread.spawn(query_http)       -- create thread 3
```

This API was first enabled in the `v0.7.0` release.

## ngx.thread.wait

**syntax:** _ok, res1, res2, ... = ngx.thread.wait(thread1, thread2, ...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Waits on one or more child "light threads" and returns the results of the first "light thread" that terminates (either successfully or with an error).

The arguments `thread1`, `thread2`, and etc are the Lua thread objects returned by earlier calls of [ngx.thread.spawn](#ngxthreadspawn).

The return values have exactly the same meaning as [coroutine.resume](#coroutineresume), that is, the first value returned is a boolean value indicating whether the "light thread" terminates successfully or not, and subsequent values returned are the return values of the user Lua function that was used to spawn the "light thread" (in case of success) or the error object (in case of failure).

Only the direct "parent coroutine" can wait on its child "light thread", otherwise a Lua exception will be raised.

The following example demonstrates the use of `ngx.thread.wait` and [ngx.location.capture](#ngxlocationcapture) to emulate [ngx.location.capture_multi](#ngxlocationcapture_multi):

```lua

 local capture = ngx.location.capture
 local spawn = ngx.thread.spawn
 local wait = ngx.thread.wait
 local say = ngx.say

 local function fetch(uri)
     return capture(uri)
 end

 local threads = {
     spawn(fetch, "/foo"),
     spawn(fetch, "/bar"),
     spawn(fetch, "/baz")
 }

 for i = 1, #threads do
     local ok, res = wait(threads[i])
     if not ok then
         say(i, ": failed to run: ", res)
     else
         say(i, ": status: ", res.status)
         say(i, ": body: ", res.body)
     end
 end
```

Here it essentially implements the "wait all" model.

And below is an example demonstrating the "wait any" model:

```lua

 function f()
     ngx.sleep(0.2)
     ngx.say("f: hello")
     return "f done"
 end

 function g()
     ngx.sleep(0.1)
     ngx.say("g: hello")
     return "g done"
 end

 local tf, err = ngx.thread.spawn(f)
 if not tf then
     ngx.say("failed to spawn thread f: ", err)
     return
 end

 ngx.say("f thread created: ", coroutine.status(tf))

 local tg, err = ngx.thread.spawn(g)
 if not tg then
     ngx.say("failed to spawn thread g: ", err)
     return
 end

 ngx.say("g thread created: ", coroutine.status(tg))

 ok, res = ngx.thread.wait(tf, tg)
 if not ok then
     ngx.say("failed to wait: ", res)
     return
 end

 ngx.say("res: ", res)

 -- stop the "world", aborting other running threads
 ngx.exit(ngx.OK)
```

And it will generate the following output:

```default
f thread created: running
g thread created: running
g: hello
res: g done
```

This API was first enabled in the `v0.7.0` release.

## ngx.thread.kill

**syntax:** _ok, err = ngx.thread.kill(thread)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, ngx.timer.\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*_

Kills a running "light thread" created by [ngx.thread.spawn](#ngxthreadspawn). Returns a true value when successful or `nil` and a string describing the error otherwise.

According to the current implementation, only the parent coroutine (or "light thread") can kill a thread. Also, a running "light thread" with pending Nginx subrequests (initiated by [ngx.location.capture](#ngxlocationcapture) for example) cannot be killed due to a limitation in the Nginx core.

This API was first enabled in the `v0.9.9` release.

## ngx.on_abort

**syntax:** _ok, err = ngx.on_abort(callback)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*_

Registers a user Lua function as the callback which gets called automatically when the client closes the (downstream) connection prematurely.

Returns `1` if the callback is registered successfully or returns `nil` and a string describing the error otherwise.

All the [Nginx API for Lua](#nginx-api-for-lua) can be used in the callback function because the function is run in a special "light thread", just as those "light threads" created by [ngx.thread.spawn](#ngxthreadspawn).

The callback function can decide what to do with the client abortion event all by itself. For example, it can simply ignore the event by doing nothing and the current Lua request handler will continue executing without interruptions. And the callback function can also decide to terminate everything by calling [ngx.exit](#ngxexit), for example,

```lua

 local function my_cleanup()
     -- custom cleanup work goes here, like cancelling a pending DB transaction

     -- now abort all the "light threads" running in the current request handler
     ngx.exit(499)
 end

 local ok, err = ngx.on_abort(my_cleanup)
 if not ok then
     ngx.log(ngx.ERR, "failed to register the on_abort callback: ", err)
     ngx.exit(500)
 end
```

When [lua_check_client_abort](#lua_check_client_abort) is set to `off` (which is the default), then this function call will always return the error message "lua_check_client_abort is off".

According to the current implementation, this function can only be called once in a single request handler; subsequent calls will return the error message "duplicate call".

This API was first introduced in the `v0.7.4` release.

See also [lua_check_client_abort](#lua_check_client_abort).

## ngx.timer.at

**syntax:** _hdl, err = ngx.timer.at(delay, callback, user_arg1, user_arg2, ...)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Creates an Nginx timer with a user callback function as well as optional user arguments.

The first argument, `delay`, specifies the delay for the timer,
in seconds. One can specify fractional seconds like `0.001` to mean 1
millisecond here. `0` delay can also be specified, in which case the
timer will immediately expire when the current handler yields
execution.

The second argument, `callback`, can
be any Lua function, which will be invoked later in a background
"light thread" after the delay specified. The user callback will be
called automatically by the Nginx core with the arguments `premature`,
`user_arg1`, `user_arg2`, and etc, where the `premature`
argument takes a boolean value indicating whether it is a premature timer
expiration or not, and `user_arg1`, `user_arg2`, and etc, are
those (extra) user arguments specified when calling `ngx.timer.at`
as the remaining arguments.

Premature timer expiration happens when the Nginx worker process is
trying to shut down, as in an Nginx configuration reload triggered by
the `HUP` signal or in an Nginx server shutdown. When the Nginx worker
is trying to shut down, one can no longer call `ngx.timer.at` to
create new timers with nonzero delays and in that case `ngx.timer.at` will return a "conditional false" value and
a string describing the error, that is, "process exiting".

Starting from the `v0.9.3` release, it is allowed to create zero-delay timers even when the Nginx worker process starts shutting down.

When a timer expires, the user Lua code in the timer callback is
running in a "light thread" detached completely from the original
request creating the timer. So objects with the same lifetime as the
request creating them, like [cosockets](#ngxsockettcp), cannot be shared between the
original request and the timer user callback function.

Here is a simple example:

```nginx

 location / {
     ...
     log_by_lua_block {
         local function push_data(premature, uri, args, status)
             -- push the data uri, args, and status to the remote
             -- via ngx.socket.tcp or ngx.socket.udp
             -- (one may want to buffer the data in Lua a bit to
             -- save I/O operations)
         end
         local ok, err = ngx.timer.at(0, push_data,
                                      ngx.var.uri, ngx.var.args, ngx.header.status)
         if not ok then
             ngx.log(ngx.ERR, "failed to create timer: ", err)
             return
         end

         -- other job in log_by_lua_block
     }
 }
```

One can also create infinite re-occurring timers, for instance, a timer getting triggered every `5` seconds, by calling `ngx.timer.at` recursively in the timer callback function. Here is such an example,

```lua

 local delay = 5
 local handler
 handler = function (premature)
     -- do some routine job in Lua just like a cron job
     if premature then
         return
     end
     local ok, err = ngx.timer.at(delay, handler)
     if not ok then
         ngx.log(ngx.ERR, "failed to create the timer: ", err)
         return
     end

     -- do something in timer
 end

 local ok, err = ngx.timer.at(delay, handler)
 if not ok then
     ngx.log(ngx.ERR, "failed to create the timer: ", err)
     return
 end

 -- do other jobs
```

It is recommended, however, to use the [ngx.timer.every](#ngxtimerevery) API function
instead for creating recurring timers since it is more robust.

Because timer callbacks run in the background and their running time
will not add to any client request's response time, they can easily
accumulate in the server and exhaust system resources due to either
Lua programming mistakes or just too much client traffic. To prevent
extreme consequences like crashing the Nginx server, there are
built-in limitations on both the number of "pending timers" and the
number of "running timers" in an Nginx worker process. The "pending
timers" here mean timers that have not yet been expired and "running
timers" are those whose user callbacks are currently running.

The maximal number of pending timers allowed in an Nginx
worker is controlled by the [lua_max_pending_timers](#lua_max_pending_timers)
directive. The maximal number of running timers is controlled by the
[lua_max_running_timers](#lua_max_running_timers) directive.

According to the current implementation, each "running timer" will
take one (fake) connection record from the global connection record
list configured by the standard [worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections) directive in
`nginx.conf`. So ensure that the
[worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections) directive is set to
a large enough value that takes into account both the real connections
and fake connections required by timer callbacks (as limited by the
[lua_max_running_timers](#lua_max_running_timers) directive).

A lot of the Lua APIs for Nginx are enabled in the context of the timer
callbacks, like stream/datagram cosockets ([ngx.socket.tcp](#ngxsockettcp) and [ngx.socket.udp](#ngxsocketudp)), shared
memory dictionaries ([ngx.shared.DICT](#ngxshareddict)), user coroutines ([coroutine.\*](#coroutinecreate)),
user "light threads" ([ngx.thread.\*](#ngxthreadspawn)), [ngx.exit](#ngxexit), [ngx.now](#ngxnow)/[ngx.time](#ngxtime),
[ngx.md5](#ngxmd5)/[ngx.sha1_bin](#ngxsha1_bin), are all allowed. But the subrequest API (like
[ngx.location.capture](#ngxlocationcapture)), the [ngx.req.\*](#ngxreqstart_time) API, the downstream output API
(like [ngx.say](#ngxsay), [ngx.print](#ngxprint), and [ngx.flush](#ngxflush)) are explicitly disabled in
this context.

You can pass most of the standard Lua values (nils, booleans, numbers, strings, tables, closures, file handles, and etc) into the timer callback, either explicitly as user arguments or implicitly as upvalues for the callback closure. There are several exceptions, however: you _cannot_ pass any thread objects returned by [coroutine.create](#coroutinecreate) and [ngx.thread.spawn](#ngxthreadspawn) or any cosocket objects returned by [ngx.socket.tcp](#ngxsockettcp), [ngx.socket.udp](#ngxsocketudp), and [ngx.req.socket](#ngxreqsocket) because these objects' lifetime is bound to the request context creating them while the timer callback is detached from the creating request's context (by design) and runs in its own (fake) request context. If you try to share the thread or cosocket objects across the boundary of the creating request, then you will get the "no co ctx found" error (for threads) or "bad request" (for cosockets). It is fine, however, to create all these objects inside your timer callback.

This API was first introduced in the `v0.8.0` release.

## ngx.timer.every

**syntax:** _hdl, err = ngx.timer.every(delay, callback, user_arg1, user_arg2, ...)_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Similar to the [ngx.timer.at](#ngxtimerat) API function, but

1. `delay` _cannot_ be zero,
1. timer will be created every `delay` seconds until the current Nginx worker process starts exiting.

Like [ngx.timer.at](#ngxtimerat), the `callback` argument will be called
automatically with the arguments `premature`, `user_arg1`, `user_arg2`, etc.

When success, returns a "conditional true" value (but not a `true`). Otherwise, returns a "conditional false" value and a string describing the error.

This API also respect the [lua_max_pending_timers](#lua_max_pending_timers) and [lua_max_running_timers](#lua_max_running_timers).

This API was first introduced in the `v0.10.9` release.

## ngx.timer.running_count

**syntax:** _count = ngx.timer.running_count()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns the number of timers currently running.

This directive was first introduced in the `v0.9.20` release.

## ngx.timer.pending_count

**syntax:** _count = ngx.timer.pending_count()_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

Returns the number of pending timers.

This directive was first introduced in the `v0.9.20` release.

## ngx.config.subsystem

**syntax:** _subsystem = ngx.config.subsystem_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

This string field indicates the Nginx subsystem the current Lua environment is based on. For this module, this field always takes the string value `"http"`. For
[ngx_stream_lua_module](https://github.com/openresty/stream-lua-nginx-module#readme), however, this field takes the value `"stream"`.

This field was first introduced in the `0.10.1`.

## ngx.config.debug

**syntax:** _debug = ngx.config.debug_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

This boolean field indicates whether the current Nginx is a debug build, i.e., being built by the `./configure` option `--with-debug`.

This field was first introduced in the `0.8.7`.

## ngx.config.prefix

**syntax:** _prefix = ngx.config.prefix()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

Returns the Nginx server "prefix" path, as determined by the `-p` command-line option when running the Nginx executable, or the path specified by the `--prefix` command-line option when building Nginx with the `./configure` script.

This function was first introduced in the `0.9.2`.

## ngx.config.nginx_version

**syntax:** _ver = ngx.config.nginx_version_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

This field take an integral value indicating the version number of the current Nginx core being used. For example, the version number `1.4.3` results in the Lua number 1004003.

This API was first introduced in the `0.9.3` release.

## ngx.config.nginx_configure

**syntax:** _str = ngx.config.nginx_configure()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*_

This function returns a string for the Nginx `./configure` command's arguments string.

This API was first introduced in the `0.9.5` release.

## ngx.config.ngx_lua_version

**syntax:** _ver = ngx.config.ngx_lua_version_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*_

This field take an integral value indicating the version number of the current `ngx_lua` module being used. For example, the version number `0.9.3` results in the Lua number 9003.

This API was first introduced in the `0.9.3` release.

## ngx.worker.exiting

**syntax:** _exiting = ngx.worker.exiting()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

This function returns a boolean value indicating whether the current Nginx worker process already starts exiting. Nginx worker process exiting happens on Nginx server quit or configuration reload (aka HUP reload).

This API was first introduced in the `0.9.3` release.

## ngx.worker.pid

**syntax:** _pid = ngx.worker.pid()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

This function returns a Lua number for the process ID (PID) of the current Nginx worker process. This API is more efficient than `ngx.var.pid` and can be used in contexts where the [ngx.var.VARIABLE](#ngxvarvariable) API cannot be used (like [init_worker_by_lua](#init_worker_by_lua)).

This API was first introduced in the `0.9.5` release.

## ngx.worker.count

**syntax:** _count = ngx.worker.count()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_by_lua\*, init_worker_by_lua\*, exit_worker_by_lua\*_

Returns the total number of the Nginx worker processes (i.e., the value configured
by the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes)
directive in `nginx.conf`).

This API was first introduced in the `0.9.20` release.

## ngx.worker.id

**syntax:** _id = ngx.worker.id()_

**context:** _set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, init_worker_by_lua\*, exit_worker_by_lua\*_

Returns the ordinal number of the current Nginx worker processes (starting from number 0).

So if the total number of workers is `N`, then this method may return a number between 0
and `N - 1` (inclusive).

This function returns meaningful values only for Nginx 1.9.1+. With earlier versions of Nginx, it
always returns `nil`.

See also [ngx.worker.count](#ngxworkercount).

This API was first introduced in the `0.9.20` release.

## ngx.semaphore

**syntax:** _local semaphore = require "ngx.semaphore"_

This is a Lua module that implements a classic-style semaphore API for efficient synchronizations among
different "light threads". Sharing the same semaphore among different "light threads" created in different (request)
contexts are also supported as long as the "light threads" reside in the same Nginx worker process
and the [lua_code_cache](#lua_code_cache) directive is turned on (which is the default).

This Lua module does not ship with this ngx_lua module itself rather it is shipped with
the
[lua-resty-core](https://github.com/openresty/lua-resty-core) library.

Please refer to the [documentation](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/semaphore.md)
for this `ngx.semaphore` Lua module in [lua-resty-core](https://github.com/openresty/lua-resty-core)
for more details.

This feature requires at least ngx_lua `v0.10.0`.

## ngx.balancer

**syntax:** _local balancer = require "ngx.balancer"_

This is a Lua module that provides a Lua API to allow defining completely dynamic load balancers
in pure Lua.

This Lua module does not ship with this ngx_lua module itself rather it is shipped with
the
[lua-resty-core](https://github.com/openresty/lua-resty-core) library.

Please refer to the [documentation](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/balancer.md)
for this `ngx.balancer` Lua module in [lua-resty-core](https://github.com/openresty/lua-resty-core)
for more details.

This feature requires at least ngx_lua `v0.10.0`.

## ngx.ssl

**syntax:** _local ssl = require "ngx.ssl"_

This Lua module provides API functions to control the SSL handshake process in contexts like
[ssl_certificate_by_lua\*](#ssl_certificate_by_lua_block).

This Lua module does not ship with this ngx_lua module itself rather it is shipped with
the
[lua-resty-core](https://github.com/openresty/lua-resty-core) library.

Please refer to the [documentation](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md)
for this `ngx.ssl` Lua module for more details.

This feature requires at least ngx_lua `v0.10.0`.

## ngx.ocsp

**syntax:** _local ocsp = require "ngx.ocsp"_

This Lua module provides API to perform OCSP queries, OCSP response validations, and
OCSP stapling planting.

Usually, this module is used together with the [ngx.ssl](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md)
module in the
context of [ssl_certificate_by_lua\*](#ssl_certificate_by_lua_block).

This Lua module does not ship with this ngx_lua module itself rather it is shipped with
the
[lua-resty-core](https://github.com/openresty/lua-resty-core) library.

Please refer to the [documentation](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ocsp.md)
for this `ngx.ocsp` Lua module for more details.

This feature requires at least ngx_lua `v0.10.0`.

## ndk.set_var.DIRECTIVE

**syntax:** _res = ndk.set_var.DIRECTIVE_NAME_

**context:** _init_worker_by_lua\*, set_by_lua\*, rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, header_filter_by_lua\*, body_filter_by_lua\*, log_by_lua\*, ngx.timer.\*, balancer_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*, exit_worker_by_lua\*_

This mechanism allows calling other Nginx C modules' directives that are implemented by [Nginx Devel Kit](https://github.com/simplresty/ngx_devel_kit) (NDK)'s set_var submodule's `ndk_set_var_value`.

For example, the following [set-misc-nginx-module](http://github.com/openresty/set-misc-nginx-module) directives can be invoked this way:

- [set_quote_sql_str](http://github.com/openresty/set-misc-nginx-module#set_quote_sql_str)
- [set_quote_pgsql_str](http://github.com/openresty/set-misc-nginx-module#set_quote_pgsql_str)
- [set_quote_json_str](http://github.com/openresty/set-misc-nginx-module#set_quote_json_str)
- [set_unescape_uri](http://github.com/openresty/set-misc-nginx-module#set_unescape_uri)
- [set_escape_uri](http://github.com/openresty/set-misc-nginx-module#set_escape_uri)
- [set_encode_base32](http://github.com/openresty/set-misc-nginx-module#set_encode_base32)
- [set_decode_base32](http://github.com/openresty/set-misc-nginx-module#set_decode_base32)
- [set_encode_base64](http://github.com/openresty/set-misc-nginx-module#set_encode_base64)
- [set_decode_base64](http://github.com/openresty/set-misc-nginx-module#set_decode_base64)
- [set_encode_hex](http://github.com/openresty/set-misc-nginx-module#set_encode_base64)
- [set_decode_hex](http://github.com/openresty/set-misc-nginx-module#set_decode_base64)
- [set_sha1](http://github.com/openresty/set-misc-nginx-module#set_encode_base64)
- [set_md5](http://github.com/openresty/set-misc-nginx-module#set_decode_base64)

For instance,

```lua

 local res = ndk.set_var.set_escape_uri('a/b')
 -- now res == 'a%2fb'
```

Similarly, the following directives provided by [encrypted-session-nginx-module](http://github.com/openresty/encrypted-session-nginx-module) can be invoked from within Lua too:

- [set_encrypt_session](http://github.com/openresty/encrypted-session-nginx-module#set_encrypt_session)
- [set_decrypt_session](http://github.com/openresty/encrypted-session-nginx-module#set_decrypt_session)

This feature requires the [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit) module.

## coroutine.create

**syntax:** _co = coroutine.create(f)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Creates a user Lua coroutines with a Lua function, and returns a coroutine object.

Similar to the standard Lua [coroutine.create](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.create) API, but works in the context of the Lua coroutines created by ngx_lua.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first introduced in the `v0.6.0` release.

## coroutine.resume

**syntax:** _ok, ... = coroutine.resume(co, ...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Resumes the executation of a user Lua coroutine object previously yielded or just created.

Similar to the standard Lua [coroutine.resume](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.resume) API, but works in the context of the Lua coroutines created by ngx_lua.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first introduced in the `v0.6.0` release.

## coroutine.yield

**syntax:** _... = coroutine.yield(...)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Yields the execution of the current user Lua coroutine.

Similar to the standard Lua [coroutine.yield](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.yield) API, but works in the context of the Lua coroutines created by ngx_lua.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first introduced in the `v0.6.0` release.

## coroutine.wrap

**syntax:** _co = coroutine.wrap(f)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Similar to the standard Lua [coroutine.wrap](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.wrap) API, but works in the context of the Lua coroutines created by ngx_lua.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first introduced in the `v0.6.0` release.

## coroutine.running

**syntax:** _co = coroutine.running()_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Identical to the standard Lua [coroutine.running](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.running) API.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first enabled in the `v0.6.0` release.

## coroutine.status

**syntax:** _status = coroutine.status(co)_

**context:** _rewrite_by_lua\*, access_by_lua\*, content_by_lua\*, init_by_lua\*, ngx.timer.\*, header_filter_by_lua\*, body_filter_by_lua\*, ssl_certificate_by_lua\*, ssl_session_fetch_by_lua\*, ssl_session_store_by_lua\*_

Identical to the standard Lua [coroutine.status](https://www.lua.org/manual/5.1/manual.html#pdf-coroutine.status) API.

This API was first usable in the context of [init_by_lua\*](#init_by_lua) since the `0.9.2`.

This API was first enabled in the `v0.6.0` release.
