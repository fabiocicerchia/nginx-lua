Directives
==========

* [lua_load_resty_core](#lua_load_resty_core)
* [lua_capture_error_log](#lua_capture_error_log)
* [lua_use_default_type](#lua_use_default_type)
* [lua_malloc_trim](#lua_malloc_trim)
* [lua_code_cache](#lua_code_cache)
* [lua_thread_cache_max_entries](#lua_thread_cache_max_entries)
* [lua_regex_cache_max_entries](#lua_regex_cache_max_entries)
* [lua_regex_match_limit](#lua_regex_match_limit)
* [lua_package_path](#lua_package_path)
* [lua_package_cpath](#lua_package_cpath)
* [init_by_lua](#init_by_lua)
* [init_by_lua_block](#init_by_lua_block)
* [init_by_lua_file](#init_by_lua_file)
* [init_worker_by_lua](#init_worker_by_lua)
* [init_worker_by_lua_block](#init_worker_by_lua_block)
* [init_worker_by_lua_file](#init_worker_by_lua_file)
* [exit_worker_by_lua_block](#exit_worker_by_lua_block)
* [exit_worker_by_lua_file](#exit_worker_by_lua_file)
* [set_by_lua](#set_by_lua)
* [set_by_lua_block](#set_by_lua_block)
* [set_by_lua_file](#set_by_lua_file)
* [content_by_lua](#content_by_lua)
* [content_by_lua_block](#content_by_lua_block)
* [content_by_lua_file](#content_by_lua_file)
* [rewrite_by_lua](#rewrite_by_lua)
* [rewrite_by_lua_block](#rewrite_by_lua_block)
* [rewrite_by_lua_file](#rewrite_by_lua_file)
* [access_by_lua](#access_by_lua)
* [access_by_lua_block](#access_by_lua_block)
* [access_by_lua_file](#access_by_lua_file)
* [header_filter_by_lua](#header_filter_by_lua)
* [header_filter_by_lua_block](#header_filter_by_lua_block)
* [header_filter_by_lua_file](#header_filter_by_lua_file)
* [body_filter_by_lua](#body_filter_by_lua)
* [body_filter_by_lua_block](#body_filter_by_lua_block)
* [body_filter_by_lua_file](#body_filter_by_lua_file)
* [log_by_lua](#log_by_lua)
* [log_by_lua_block](#log_by_lua_block)
* [log_by_lua_file](#log_by_lua_file)
* [balancer_by_lua_block](#balancer_by_lua_block)
* [balancer_by_lua_file](#balancer_by_lua_file)
* [lua_need_request_body](#lua_need_request_body)
* [ssl_certificate_by_lua_block](#ssl_certificate_by_lua_block)
* [ssl_certificate_by_lua_file](#ssl_certificate_by_lua_file)
* [ssl_session_fetch_by_lua_block](#ssl_session_fetch_by_lua_block)
* [ssl_session_fetch_by_lua_file](#ssl_session_fetch_by_lua_file)
* [ssl_session_store_by_lua_block](#ssl_session_store_by_lua_block)
* [ssl_session_store_by_lua_file](#ssl_session_store_by_lua_file)
* [lua_shared_dict](#lua_shared_dict)
* [lua_socket_connect_timeout](#lua_socket_connect_timeout)
* [lua_socket_send_timeout](#lua_socket_send_timeout)
* [lua_socket_send_lowat](#lua_socket_send_lowat)
* [lua_socket_read_timeout](#lua_socket_read_timeout)
* [lua_socket_buffer_size](#lua_socket_buffer_size)
* [lua_socket_pool_size](#lua_socket_pool_size)
* [lua_socket_keepalive_timeout](#lua_socket_keepalive_timeout)
* [lua_socket_log_errors](#lua_socket_log_errors)
* [lua_ssl_ciphers](#lua_ssl_ciphers)
* [lua_ssl_crl](#lua_ssl_crl)
* [lua_ssl_protocols](#lua_ssl_protocols)
* [lua_ssl_trusted_certificate](#lua_ssl_trusted_certificate)
* [lua_ssl_verify_depth](#lua_ssl_verify_depth)
* [lua_http10_buffering](#lua_http10_buffering)
* [rewrite_by_lua_no_postpone](#rewrite_by_lua_no_postpone)
* [access_by_lua_no_postpone](#access_by_lua_no_postpone)
* [lua_transform_underscores_in_response_headers](#lua_transform_underscores_in_response_headers)
* [lua_check_client_abort](#lua_check_client_abort)
* [lua_max_pending_timers](#lua_max_pending_timers)
* [lua_max_running_timers](#lua_max_running_timers)
* [lua_sa_restart](#lua_sa_restart)


The basic building blocks of scripting Nginx with Lua are directives. Directives are used to specify when the user Lua code is run and
how the result will be used. Below is a diagram showing the order in which directives are executed.

![Lua Nginx Modules Directives](https://cloud.githubusercontent.com/assets/2137369/15272097/77d1c09e-1a37-11e6-97ef-d9767035fc3e.png)

[Back to TOC](#table-of-contents)

lua_load_resty_core
-------------------

**syntax:** *lua_load_resty_core on|off*

**default:** *lua_load_resty_core on*

**context:** *http*

This directive is deprecated since the `v0.10.16` release of this
module. The `resty.core` module from
[lua-resty-core](https://github.com/openresty/lua-resty-core) is now mandatorily
loaded during the Lua VM initialization. Specifying this directive will have no
effect.

This directive was first introduced in the `v0.10.15` release and
used to optionally load the `resty.core` module.

lua_capture_error_log
---------------------

**syntax:** *lua_capture_error_log size*

**default:** *none*

**context:** *http*

Enables a buffer of the specified `size` for capturing all the Nginx error log message data (not just those produced
by this module or the Nginx http subsystem, but everything) without touching files or disks.

You can use units like `k` and `m` in the `size` value, as in

```nginx

 lua_capture_error_log 100k;
```

As a rule of thumb, a 4KB buffer can usually hold about 20 typical error log messages. So do the maths!

This buffer never grows. If it is full, new error log messages will replace the oldest ones in the buffer.

The size of the buffer must be bigger than the maximum length of a single error log message (which is 4K in OpenResty and 2K in stock NGINX).

You can read the messages in the buffer on the Lua land via the
[get_logs()](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/errlog.md#get_logs)
function of the
[ngx.errlog](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/errlog.md#readme)
module of the [lua-resty-core](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/errlog.md#readme)
library. This Lua API function will return the captured error log messages and
also remove these already read from the global capturing buffer, making room
for any new error log data. For this reason, the user should not configure this
buffer to be too big if the user read the buffered error log data fast enough.

Note that the log level specified in the standard [error_log](https://nginx.org/r/error_log) directive
*does* have effect on this capturing facility. It only captures log
messages of a level no lower than the specified log level in the [error_log](https://nginx.org/r/error_log) directive.
The user can still choose to set an even higher filtering log level on the fly via the Lua API function
[errlog.set_filter_level](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/errlog.md#set_filter_level).
So it is more flexible than the static [error_log](https://nginx.org/r/error_log) directive.

It is worth noting that there is no way to capture the debugging logs
without building OpenResty or Nginx with the `./configure`
option `--with-debug`. And enabling debugging logs is
strongly discouraged in production builds due to high overhead.

This directive was first introduced in the `v0.10.9` release.

lua_use_default_type
--------------------

**syntax:** *lua_use_default_type on | off*

**default:** *lua_use_default_type on*

**context:** *http, server, location, location if*

Specifies whether to use the MIME type specified by the [default_type](https://nginx.org/en/docs/http/ngx_http_core_module.html#default_type) directive for the default value of the `Content-Type` response header. Deactivate this directive if a default `Content-Type` response header for Lua request handlers is not desired.

This directive is turned on by default.

This directive was first introduced in the `v0.9.1` release.

lua_malloc_trim
---------------

**syntax:** *lua_malloc_trim &lt;request-count&gt;*

**default:** *lua_malloc_trim 1000*

**context:** *http*

Asks the underlying `libc` runtime library to release its cached free memory back to the operating system every
`N` requests processed by the Nginx core. By default, `N` is 1000. You can configure the request count
by using your own numbers. Smaller numbers mean more frequent releases, which may introduce higher CPU time consumption and
smaller memory footprint while larger numbers usually lead to less CPU time overhead and relatively larger memory footprint.
Just tune the number for your own use cases.

Configuring the argument to `0` essentially turns off the periodical memory trimming altogether.

```nginx

 lua_malloc_trim 0;  # turn off trimming completely
```

The current implementation uses an Nginx log phase handler to do the request counting. So the appearance of the
[log_subrequest on](https://nginx.org/en/docs/http/ngx_http_core_module.html#log_subrequest) directives in `nginx.conf`
may make the counting faster when subrequests are involved. By default, only "main requests" count.

Note that this directive does *not* affect the memory allocated by LuaJIT's own allocator based on the `mmap`
system call.

This directive was first introduced in the `v0.10.7` release.

lua_code_cache
--------------
**syntax:** *lua_code_cache on | off*

**default:** *lua_code_cache on*

**context:** *http, server, location, location if*

Enables or disables the Lua code cache for Lua code in `*_by_lua_file` directives (like [set_by_lua_file](#set_by_lua_file) and
[content_by_lua_file](#content_by_lua_file)) and Lua modules.

When turning off, every request served by ngx_lua will run in a separate Lua VM instance, starting from the `0.9.3` release. So the Lua files referenced in [set_by_lua_file](#set_by_lua_file),
[content_by_lua_file](#content_by_lua_file), [access_by_lua_file](#access_by_lua_file),
and etc will not be cached
and all Lua modules used will be loaded from scratch. With this in place, developers can adopt an edit-and-refresh approach.

Please note however, that Lua code written inlined within nginx.conf
such as those specified by [set_by_lua](#set_by_lua), [content_by_lua](#content_by_lua),
[access_by_lua](#access_by_lua), and [rewrite_by_lua](#rewrite_by_lua) will not be updated when you edit the inlined Lua code in your `nginx.conf` file because only the Nginx config file parser can correctly parse the `nginx.conf`
file and the only way is to reload the config file
by sending a `HUP` signal or just to restart Nginx.

Even when the code cache is enabled, Lua files which are loaded by `dofile` or `loadfile`
in *_by_lua_file cannot be cached (unless you cache the results yourself). Usually you can either use the [init_by_lua](#init_by_lua)
or [init_by_lua_file](#init-by_lua_file) directives to load all such files or just make these Lua files true Lua modules
and load them via `require`.

The ngx_lua module does not support the `stat` mode available with the
Apache `mod_lua` module (yet).

Disabling the Lua code cache is strongly
discouraged for production use and should only be used during
development as it has a significant negative impact on overall performance. For example, the performance of a "hello world" Lua example can drop by an order of magnitude after disabling the Lua code cache.

lua_thread_cache_max_entries
----------------------------

**syntax:** *lua_thread_cache_max_entries &lt;num&gt;*

**default:** *lua_thread_cache_max_entries 1024*

**context:** *http*

Specifies the maximum number of entries allowed in the worker process level lua thread object cache.

This cache recycles the lua thread GC objects among all our "light threads".

A zero value of `<num>` disables the cache.

Note that this feature requires OpenResty's LuaJIT with the new C API `lua_resetthread`.

This feature was first introduced in verson `v0.10.9`.

lua_regex_cache_max_entries
---------------------------

**syntax:** *lua_regex_cache_max_entries &lt;num&gt;*

**default:** *lua_regex_cache_max_entries 1024*

**context:** *http*

Specifies the maximum number of entries allowed in the worker process level compiled regex cache.

The regular expressions used in [ngx.re.match](#ngxrematch), [ngx.re.gmatch](#ngxregmatch), [ngx.re.sub](#ngxresub), and [ngx.re.gsub](#ngxregsub) will be cached within this cache if the regex option `o` (i.e., compile-once flag) is specified.

The default number of entries allowed is 1024 and when this limit is reached, new regular expressions will not be cached (as if the `o` option was not specified) and there will be one, and only one, warning in the `error.log` file:


    2011/08/27 23:18:26 [warn] 31997#0: *1 lua exceeding regex cache max entries (1024), ...


If you are using the `ngx.re.*` implementation of [lua-resty-core](https://github.com/openresty/lua-resty-core) by loading the `resty.core.regex` module (or just the `resty.core` module), then an LRU cache is used for the regex cache being used here.

Do not activate the `o` option for regular expressions (and/or `replace` string arguments for [ngx.re.sub](#ngxresub) and [ngx.re.gsub](#ngxregsub)) that are generated *on the fly* and give rise to infinite variations to avoid hitting the specified limit.

lua_regex_match_limit
---------------------

**syntax:** *lua_regex_match_limit &lt;num&gt;*

**default:** *lua_regex_match_limit 0*

**context:** *http*

Specifies the "match limit" used by the PCRE library when executing the [ngx.re API](#ngxrematch). To quote the PCRE manpage, "the limit ... has the effect of limiting the amount of backtracking that can take place."

When the limit is hit, the error string "pcre_exec() failed: -8" will be returned by the [ngx.re API](#ngxrematch) functions on the Lua land.

When setting the limit to 0, the default "match limit" when compiling the PCRE library is used. And this is the default value of this directive.

This directive was first introduced in the `v0.8.5` release.

lua_package_path
----------------

**syntax:** *lua_package_path &lt;lua-style-path-str&gt;*

**default:** *The content of LUA_PATH environment variable or Lua's compiled-in defaults.*

**context:** *http*

Sets the Lua module search path used by scripts specified by [set_by_lua](#set_by_lua),
[content_by_lua](#content_by_lua) and others. The path string is in standard Lua path form, and `;;`
can be used to stand for the original search paths.

As from the `v0.5.0rc29` release, the special notation `$prefix` or `${prefix}` can be used in the search path string to indicate the path of the `server prefix` usually determined by the `-p PATH` command-line option while starting the Nginx server.

lua_package_cpath
-----------------

**syntax:** *lua_package_cpath &lt;lua-style-cpath-str&gt;*

**default:** *The content of LUA_CPATH environment variable or Lua's compiled-in defaults.*

**context:** *http*

Sets the Lua C-module search path used by scripts specified by [set_by_lua](#set_by_lua),
[content_by_lua](#content_by_lua) and others. The cpath string is in standard Lua cpath form, and `;;`
can be used to stand for the original cpath.

As from the `v0.5.0rc29` release, the special notation `$prefix` or `${prefix}` can be used in the search path string to indicate the path of the `server prefix` usually determined by the `-p PATH` command-line option while starting the Nginx server.

init_by_lua
-----------

**syntax:** *init_by_lua &lt;lua-script-str&gt;*

**context:** *http*

**phase:** *loading-config*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [init_by_lua_block](#init_by_lua_block) directive instead.

Runs the Lua code specified by the argument `<lua-script-str>` on the global Lua VM level when the Nginx master process (if any) is loading the Nginx config file.

When Nginx receives the `HUP` signal and starts reloading the config file, the Lua VM will also be re-created and `init_by_lua` will run again on the new Lua VM. In case that the [lua_code_cache](#lua_code_cache) directive is turned off (default on), the `init_by_lua` handler will run upon every request because in this special mode a standalone Lua VM is always created for each request.

Usually you can pre-load Lua modules at server start-up by means of this hook and take advantage of modern operating systems' copy-on-write (COW) optimization. Here is an example for pre-loading Lua modules:

```nginx

 # this runs before forking out nginx worker processes:
 init_by_lua_block { require "cjson" }

 server {
     location = /api {
         content_by_lua_block {
             -- the following require() will just  return
             -- the already loaded module from package.loaded:
             ngx.say(require "cjson".encode{dog = 5, cat = 6})
         }
     }
 }
```

You can also initialize the [lua_shared_dict](#lua_shared_dict) shm storage at this phase. Here is an example for this:

```nginx

 lua_shared_dict dogs 1m;

 init_by_lua_block {
     local dogs = ngx.shared.dogs
     dogs:set("Tom", 56)
 }

 server {
     location = /api {
         content_by_lua_block {
             local dogs = ngx.shared.dogs
             ngx.say(dogs:get("Tom"))
         }
     }
 }
```

But note that, the [lua_shared_dict](#lua_shared_dict)'s shm storage will not be cleared through a config reload (via the `HUP` signal, for example). So if you do *not* want to re-initialize the shm storage in your `init_by_lua` code in this case, then you just need to set a custom flag in the shm storage and always check the flag in your `init_by_lua` code.

Because the Lua code in this context runs before Nginx forks its worker processes (if any), data or code loaded here will enjoy the [Copy-on-write (COW)](https://en.wikipedia.org/wiki/Copy-on-write) feature provided by many operating systems among all the worker processes, thus saving a lot of memory.

Do *not* initialize your own Lua global variables in this context because use of Lua global variables have performance penalties and can lead to global namespace pollution (see the [Lua Variable Scope](#lua-variable-scope) section for more details). The recommended way is to use proper [Lua module](https://www.lua.org/manual/5.1/manual.html#5.3) files (but do not use the standard Lua function [module()](https://www.lua.org/manual/5.1/manual.html#pdf-module) to define Lua modules because it pollutes the global namespace as well) and call [require()](https://www.lua.org/manual/5.1/manual.html#pdf-require) to load your own module files in `init_by_lua` or other contexts ([require()](https://www.lua.org/manual/5.1/manual.html#pdf-require) does cache the loaded Lua modules in the global `package.loaded` table in the Lua registry so your modules will only loaded once for the whole Lua VM instance).

Only a small set of the [Nginx API for Lua](#nginx-api-for-lua) is supported in this context:

* Logging APIs: [ngx.log](#ngxlog) and [print](#print),
* Shared Dictionary API: [ngx.shared.DICT](#ngxshareddict).

More Nginx APIs for Lua may be supported in this context upon future user requests.

Basically you can safely use Lua libraries that do blocking I/O in this very context because blocking the master process during server start-up is completely okay. Even the Nginx core does blocking I/O (at least on resolving upstream's host names) at the configure-loading phase.

You should be very careful about potential security vulnerabilities in your Lua code registered in this context because the Nginx master process is often run under the `root` account.

This directive was first introduced in the `v0.5.5` release.

See also the following blog posts for more details on OpenResty and Nginx's shared memory zones:

* [How OpenResty and Nginx Shared Memory Zones Consume RAM](https://blog.openresty.com/en/how-nginx-shm-consume-ram/?src=gh_ngxlua)
* [Memory Fragmentation in OpenResty and Nginx's Shared Memory Zones](https://blog.openresty.com/en/nginx-shm-frag/?src=gh_ngxlua)

init_by_lua_block
-----------------

**syntax:** *init_by_lua_block { lua-script }*

**context:** *http*

**phase:** *loading-config*

Similar to the [init_by_lua](#init_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 init_by_lua_block {
     print("I need no extra escaping here, for example: \r\nblah")
 }
```

This directive was first introduced in the `v0.9.17` release.

init_by_lua_file
----------------

**syntax:** *init_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http*

**phase:** *loading-config*

Equivalent to [init_by_lua](#init_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code or [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.5.5` release.

init_worker_by_lua
------------------

**syntax:** *init_worker_by_lua &lt;lua-script-str&gt;*

**context:** *http*

**phase:** *starting-worker*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [init_worker_by_lua_block](#init_worker_by_lua_block) directive instead.

Runs the specified Lua code upon every Nginx worker process's startup when the master process is enabled. When the master process is disabled, this hook will just run after [init_by_lua*](#init_by_lua).

This hook is often used to create per-worker reoccurring timers (via the [ngx.timer.at](#ngxtimerat) Lua API), either for backend health-check or other timed routine work. Below is an example,

```nginx

 init_worker_by_lua '
     local delay = 3  -- in seconds
     local new_timer = ngx.timer.at
     local log = ngx.log
     local ERR = ngx.ERR
     local check

     check = function(premature)
         if not premature then
             -- do the health check or other routine work
             local ok, err = new_timer(delay, check)
             if not ok then
                 log(ERR, "failed to create timer: ", err)
                 return
             end
         end

         -- do something in timer
     end

     local hdl, err = new_timer(delay, check)
     if not hdl then
         log(ERR, "failed to create timer: ", err)
         return
     end

     -- other job in init_worker_by_lua
 ';
```

This directive was first introduced in the `v0.9.5` release.

This hook no longer runs in the cache manager and cache loader processes since the `v0.10.12` release.

init_worker_by_lua_block
------------------------

**syntax:** *init_worker_by_lua_block { lua-script }*

**context:** *http*

**phase:** *starting-worker*

Similar to the [init_worker_by_lua](#init_worker_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 init_worker_by_lua_block {
     print("I need no extra escaping here, for example: \r\nblah")
 }
```

This directive was first introduced in the `v0.9.17` release.

This hook no longer runs in the cache manager and cache loader processes since the `v0.10.12` release.

init_worker_by_lua_file
-----------------------

**syntax:** *init_worker_by_lua_file &lt;lua-file-path&gt;*

**context:** *http*

**phase:** *starting-worker*

Similar to [init_worker_by_lua](#init_worker_by_lua), but accepts the file path to a Lua source file or Lua bytecode file.

This directive was first introduced in the `v0.9.5` release.

This hook no longer runs in the cache manager and cache loader processes since the `v0.10.12` release.

exit_worker_by_lua_block
------------------------

**syntax:** *exit_worker_by_lua_block { lua-script }*

**context:** *http*

**phase:** *exiting-worker*

Runs the specified Lua code upon every Nginx worker process's exit when the master process is enabled. When the master process is disabled, this hook will run before the Nginx process exits.

This hook is often used to release resources allocated by each worker (e.g. resources allocated by [init_worker_by_lua*](#init_worker_by_lua)), or to prevent workers from exiting abnormally.

For example,

```nginx

 exit_worker_by_lua_block {
     print("log from exit_worker_by_lua_block")
 }
```

This directive was first introduced in the `v0.10.18` release.

exit_worker_by_lua_file
-----------------------

**syntax:** *exit_worker_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http*

**phase:** *exiting-worker*

Similar to [exit_worker_by_lua_block](#exit_worker_by_lua_block), but accepts the file path to a Lua source file or Lua bytecode file.

This directive was first introduced in the `v0.10.18` release.

set_by_lua
----------

**syntax:** *set_by_lua $res &lt;lua-script-str&gt; [$arg1 $arg2 ...]*

**context:** *server, server if, location, location if*

**phase:** *rewrite*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [set_by_lua_block](#set_by_lua_block) directive instead.

Executes code specified in `<lua-script-str>` with optional input arguments `$arg1 $arg2 ...`, and returns string output to `$res`.
The code in `<lua-script-str>` can make [API calls](#nginx-api-for-lua) and can retrieve input arguments from the `ngx.arg` table (index starts from `1` and increases sequentially).

This directive is designed to execute short, fast running code blocks as the Nginx event loop is blocked during code execution. Time consuming code sequences should therefore be avoided.

This directive is implemented by injecting custom commands into the standard [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)'s command list. Because [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html) does not support nonblocking I/O in its commands, Lua APIs requiring yielding the current Lua "light thread" cannot work in this directive.

At least the following API functions are currently disabled within the context of `set_by_lua`:

* Output API functions (e.g., [ngx.say](#ngxsay) and [ngx.send_headers](#ngxsend_headers))
* Control API functions (e.g., [ngx.exit](#ngxexit))
* Subrequest API functions (e.g., [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi))
* Cosocket API functions (e.g., [ngx.socket.tcp](#ngxsockettcp) and [ngx.req.socket](#ngxreqsocket)).
* Sleeping API function [ngx.sleep](#ngxsleep).

In addition, note that this directive can only write out a value to a single Nginx variable at
a time. However, a workaround is possible using the [ngx.var.VARIABLE](#ngxvarvariable) interface.

```nginx

 location /foo {
     set $diff ''; # we have to predefine the $diff variable here

     set_by_lua $sum '
         local a = 32
         local b = 56

         ngx.var.diff = a - b  -- write to $diff directly
         return a + b          -- return the $sum value normally
     ';

     echo "sum = $sum, diff = $diff";
 }
```

This directive can be freely mixed with all directives of the [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html), [set-misc-nginx-module](http://github.com/openresty/set-misc-nginx-module), and [array-var-nginx-module](http://github.com/openresty/array-var-nginx-module) modules. All of these directives will run in the same order as they appear in the config file.

```nginx

 set $foo 32;
 set_by_lua $bar 'return tonumber(ngx.var.foo) + 1';
 set $baz "bar: $bar";  # $baz == "bar: 33"
```

As from the `v0.5.0rc29` release, Nginx variable interpolation is disabled in the `<lua-script-str>` argument of this directive and therefore, the dollar sign character (`$`) can be used directly.

This directive requires the [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit) module.

set_by_lua_block
----------------

**syntax:** *set_by_lua_block $res { lua-script }*

**context:** *server, server if, location, location if*

**phase:** *rewrite*

Similar to the [set_by_lua](#set_by_lua) directive except that

1. this directive inlines the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping), and
1. this directive does not support extra arguments after the Lua script as in [set_by_lua](#set_by_lua).

For example,

```nginx

 set_by_lua_block $res { return 32 + math.cos(32) }
 # $res now has the value "32.834223360507" or alike.
```

No special escaping is required in the Lua code block.

This directive was first introduced in the `v0.9.17` release.

set_by_lua_file
---------------

**syntax:** *set_by_lua_file $res &lt;path-to-lua-script-file&gt; [$arg1 $arg2 ...]*

**context:** *server, server if, location, location if*

**phase:** *rewrite*

Equivalent to [set_by_lua](#set_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

Nginx variable interpolation is supported in the `<path-to-lua-script-file>` argument string of this directive. But special care must be taken for injection attacks.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

When the Lua code cache is turned on (by default), the user code is loaded once at the first request and cached
and the Nginx config must be reloaded each time the Lua source file is modified.
The Lua code cache can be temporarily disabled during development by
switching [lua_code_cache](#lua_code_cache) `off` in `nginx.conf` to avoid reloading Nginx.

This directive requires the [ngx_devel_kit](https://github.com/simplresty/ngx_devel_kit) module.

content_by_lua
--------------

**syntax:** *content_by_lua &lt;lua-script-str&gt;*

**context:** *location, location if*

**phase:** *content*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [content_by_lua_block](#content_by_lua_block) directive instead.

Acts as a "content handler" and executes Lua code string specified in `<lua-script-str>` for every request.
The Lua code may make [API calls](#nginx-api-for-lua) and is executed as a new spawned coroutine in an independent global environment (i.e. a sandbox).

Do not use this directive and other content handler directives in the same location. For example, this directive and the [proxy_pass](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass) directive should not be used in the same location.

content_by_lua_block
--------------------

**syntax:** *content_by_lua_block { lua-script }*

**context:** *location, location if*

**phase:** *content*

Similar to the [content_by_lua](#content_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 content_by_lua_block {
     ngx.say("I need no extra escaping here, for example: \r\nblah")
 }
```

This directive was first introduced in the `v0.9.17` release.

content_by_lua_file
-------------------

**syntax:** *content_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *location, location if*

**phase:** *content*

Equivalent to [content_by_lua](#content_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

Nginx variables can be used in the `<path-to-lua-script-file>` string to provide flexibility. This however carries some risks and is not ordinarily recommended.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

When the Lua code cache is turned on (by default), the user code is loaded once at the first request and cached
and the Nginx config must be reloaded each time the Lua source file is modified.
The Lua code cache can be temporarily disabled during development by
switching [lua_code_cache](#lua_code_cache) `off` in `nginx.conf` to avoid reloading Nginx.

Nginx variables are supported in the file path for dynamic dispatch, for example:

```nginx

 # CAUTION: contents in nginx var must be carefully filtered,
 # otherwise there'll be great security risk!
 location ~ ^/app/([-_a-zA-Z0-9/]+) {
     set $path $1;
     content_by_lua_file /path/to/lua/app/root/$path.lua;
 }
```

But be very careful about malicious user inputs and always carefully validate or filter out the user-supplied path components.

rewrite_by_lua
--------------

**syntax:** *rewrite_by_lua &lt;lua-script-str&gt;*

**context:** *http, server, location, location if*

**phase:** *rewrite tail*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [rewrite_by_lua_block](#rewrite_by_lua_block) directive instead.

Acts as a rewrite phase handler and executes Lua code string specified in `<lua-script-str>` for every request.
The Lua code may make [API calls](#nginx-api-for-lua) and is executed as a new spawned coroutine in an independent global environment (i.e. a sandbox).

Note that this handler always runs *after* the standard [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html). So the following will work as expected:

```nginx

 location /foo {
     set $a 12; # create and initialize $a
     set $b ""; # create and initialize $b
     rewrite_by_lua 'ngx.var.b = tonumber(ngx.var.a) + 1';
     echo "res = $b";
 }
```

because `set $a 12` and `set $b ""` run *before* [rewrite_by_lua](#rewrite_by_lua).

On the other hand, the following will not work as expected:

```nginx

 ?  location /foo {
 ?      set $a 12; # create and initialize $a
 ?      set $b ''; # create and initialize $b
 ?      rewrite_by_lua 'ngx.var.b = tonumber(ngx.var.a) + 1';
 ?      if ($b = '13') {
 ?         rewrite ^ /bar redirect;
 ?         break;
 ?      }
 ?
 ?      echo "res = $b";
 ?  }
```

because `if` runs *before* [rewrite_by_lua](#rewrite_by_lua) even if it is placed after [rewrite_by_lua](#rewrite_by_lua) in the config.

The right way of doing this is as follows:

```nginx

 location /foo {
     set $a 12; # create and initialize $a
     set $b ''; # create and initialize $b
     rewrite_by_lua '
         ngx.var.b = tonumber(ngx.var.a) + 1
         if tonumber(ngx.var.b) == 13 then
             return ngx.redirect("/bar")
         end
     ';

     echo "res = $b";
 }
```

Note that the [ngx_eval](http://www.grid.net.ru/nginx/eval.en.html) module can be approximated by using [rewrite_by_lua](#rewrite_by_lua). For example,

```nginx

 location / {
     eval $res {
         proxy_pass http://foo.com/check-spam;
     }

     if ($res = 'spam') {
         rewrite ^ /terms-of-use.html redirect;
     }

     fastcgi_pass ...;
 }
```

can be implemented in ngx_lua as:

```nginx

 location = /check-spam {
     internal;
     proxy_pass http://foo.com/check-spam;
 }

 location / {
     rewrite_by_lua '
         local res = ngx.location.capture("/check-spam")
         if res.body == "spam" then
             return ngx.redirect("/terms-of-use.html")
         end
     ';

     fastcgi_pass ...;
 }
```

Just as any other rewrite phase handlers, [rewrite_by_lua](#rewrite_by_lua) also runs in subrequests.

Note that when calling `ngx.exit(ngx.OK)` within a [rewrite_by_lua](#rewrite_by_lua) handler, the Nginx request processing control flow will still continue to the content handler. To terminate the current request from within a [rewrite_by_lua](#rewrite_by_lua) handler, call [ngx.exit](#ngxexit) with status >= 200 (`ngx.HTTP_OK`) and status < 300 (`ngx.HTTP_SPECIAL_RESPONSE`) for successful quits and `ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)` (or its friends) for failures.

If the [ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)'s [rewrite](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directive is used to change the URI and initiate location re-lookups (internal redirections), then any [rewrite_by_lua](#rewrite_by_lua) or [rewrite_by_lua_file](#rewrite_by_lua_file) code sequences within the current location will not be executed. For example,

```nginx

 location /foo {
     rewrite ^ /bar;
     rewrite_by_lua 'ngx.exit(503)';
 }
 location /bar {
     ...
 }
```

Here the Lua code `ngx.exit(503)` will never run. This will be the case if `rewrite ^ /bar last` is used as this will similarly initiate an internal redirection. If the `break` modifier is used instead, there will be no internal redirection and the `rewrite_by_lua` code will be executed.

The `rewrite_by_lua` code will always run at the end of the `rewrite` request-processing phase unless [rewrite_by_lua_no_postpone](#rewrite_by_lua_no_postpone) is turned on.

rewrite_by_lua_block
--------------------

**syntax:** *rewrite_by_lua_block { lua-script }*

**context:** *http, server, location, location if*

**phase:** *rewrite tail*

Similar to the [rewrite_by_lua](#rewrite_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 rewrite_by_lua_block {
     do_something("hello, world!\nhiya\n")
 }
```

This directive was first introduced in the `v0.9.17` release.

rewrite_by_lua_file
-------------------

**syntax:** *rewrite_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http, server, location, location if*

**phase:** *rewrite tail*

Equivalent to [rewrite_by_lua](#rewrite_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

Nginx variables can be used in the `<path-to-lua-script-file>` string to provide flexibility. This however carries some risks and is not ordinarily recommended.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

When the Lua code cache is turned on (by default), the user code is loaded once at the first request and cached and the Nginx config must be reloaded each time the Lua source file is modified. The Lua code cache can be temporarily disabled during development by switching [lua_code_cache](#lua_code_cache) `off` in `nginx.conf` to avoid reloading Nginx.

The `rewrite_by_lua_file` code will always run at the end of the `rewrite` request-processing phase unless [rewrite_by_lua_no_postpone](#rewrite_by_lua_no_postpone) is turned on.

Nginx variables are supported in the file path for dynamic dispatch just as in [content_by_lua_file](#content_by_lua_file).

access_by_lua
-------------

**syntax:** *access_by_lua &lt;lua-script-str&gt;*

**context:** *http, server, location, location if*

**phase:** *access tail*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [access_by_lua_block](#access_by_lua_block) directive instead.

Acts as an access phase handler and executes Lua code string specified in `<lua-script-str>` for every request.
The Lua code may make [API calls](#nginx-api-for-lua) and is executed as a new spawned coroutine in an independent global environment (i.e. a sandbox).

Note that this handler always runs *after* the standard [ngx_http_access_module](http://nginx.org/en/docs/http/ngx_http_access_module.html). So the following will work as expected:

```nginx

 location / {
     deny    192.168.1.1;
     allow   192.168.1.0/24;
     allow   10.1.1.0/16;
     deny    all;

     access_by_lua '
         local res = ngx.location.capture("/mysql", { ... })
         ...
     ';

     # proxy_pass/fastcgi_pass/...
 }
```

That is, if a client IP address is in the blacklist, it will be denied before the MySQL query for more complex authentication is executed by [access_by_lua](#access_by_lua).

Note that the [ngx_auth_request](http://mdounin.ru/hg/ngx_http_auth_request_module/) module can be approximated by using [access_by_lua](#access_by_lua):

```nginx

 location / {
     auth_request /auth;

     # proxy_pass/fastcgi_pass/postgres_pass/...
 }
```

can be implemented in ngx_lua as:

```nginx

 location / {
     access_by_lua '
         local res = ngx.location.capture("/auth")

         if res.status == ngx.HTTP_OK then
             return
         end

         if res.status == ngx.HTTP_FORBIDDEN then
             ngx.exit(res.status)
         end

         ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
     ';

     # proxy_pass/fastcgi_pass/postgres_pass/...
 }
```

As with other access phase handlers, [access_by_lua](#access_by_lua) will *not* run in subrequests.

Note that when calling `ngx.exit(ngx.OK)` within a [access_by_lua](#access_by_lua) handler, the Nginx request processing control flow will still continue to the content handler. To terminate the current request from within a [access_by_lua](#access_by_lua) handler, call [ngx.exit](#ngxexit) with status >= 200 (`ngx.HTTP_OK`) and status < 300 (`ngx.HTTP_SPECIAL_RESPONSE`) for successful quits and `ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)` (or its friends) for failures.

Starting from the `v0.9.20` release, you can use the [access_by_lua_no_postpone](#access_by_lua_no_postpone)
directive to control when to run this handler inside the "access" request-processing phase
of Nginx.

access_by_lua_block
-------------------

**syntax:** *access_by_lua_block { lua-script }*

**context:** *http, server, location, location if*

**phase:** *access tail*

Similar to the [access_by_lua](#access_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 access_by_lua_block {
     do_something("hello, world!\nhiya\n")
 }
```

This directive was first introduced in the `v0.9.17` release.

access_by_lua_file
------------------

**syntax:** *access_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http, server, location, location if*

**phase:** *access tail*

Equivalent to [access_by_lua](#access_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

Nginx variables can be used in the `<path-to-lua-script-file>` string to provide flexibility. This however carries some risks and is not ordinarily recommended.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

When the Lua code cache is turned on (by default), the user code is loaded once at the first request and cached
and the Nginx config must be reloaded each time the Lua source file is modified.
The Lua code cache can be temporarily disabled during development by switching [lua_code_cache](#lua_code_cache) `off` in `nginx.conf` to avoid repeatedly reloading Nginx.

Nginx variables are supported in the file path for dynamic dispatch just as in [content_by_lua_file](#content_by_lua_file).

header_filter_by_lua
--------------------

**syntax:** *header_filter_by_lua &lt;lua-script-str&gt;*

**context:** *http, server, location, location if*

**phase:** *output-header-filter*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [header_filter_by_lua_block](#header_filter_by_lua_block) directive instead.

Uses Lua code specified in `<lua-script-str>` to define an output header filter.

Note that the following API functions are currently disabled within this context:

* Output API functions (e.g., [ngx.say](#ngxsay) and [ngx.send_headers](#ngxsend_headers))
* Control API functions (e.g., [ngx.redirect](#ngxredirect) and [ngx.exec](#ngxexec))
* Subrequest API functions (e.g., [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi))
* Cosocket API functions (e.g., [ngx.socket.tcp](#ngxsockettcp) and [ngx.req.socket](#ngxreqsocket)).

Here is an example of overriding a response header (or adding one if absent) in our Lua header filter:

```nginx

 location / {
     proxy_pass http://mybackend;
     header_filter_by_lua 'ngx.header.Foo = "blah"';
 }
```

This directive was first introduced in the `v0.2.1rc20` release.

header_filter_by_lua_block
--------------------------

**syntax:** *header_filter_by_lua_block { lua-script }*

**context:** *http, server, location, location if*

**phase:** *output-header-filter*

Similar to the [header_filter_by_lua](#header_filter_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 header_filter_by_lua_block {
     ngx.header["content-length"] = nil
 }
```

This directive was first introduced in the `v0.9.17` release.

header_filter_by_lua_file
-------------------------

**syntax:** *header_filter_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http, server, location, location if*

**phase:** *output-header-filter*

Equivalent to [header_filter_by_lua](#header_filter_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.2.1rc20` release.

body_filter_by_lua
------------------

**syntax:** *body_filter_by_lua &lt;lua-script-str&gt;*

**context:** *http, server, location, location if*

**phase:** *output-body-filter*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [body_filter_by_lua_block](#body_filter_by_lua_block) directive instead.

Uses Lua code specified in `<lua-script-str>` to define an output body filter.

The input data chunk is passed via [ngx.arg](#ngxarg)\[1\] (as a Lua string value) and the "eof" flag indicating the end of the response body data stream is passed via [ngx.arg](#ngxarg)\[2\] (as a Lua boolean value).

Behind the scene, the "eof" flag is just the `last_buf` (for main requests) or `last_in_chain` (for subrequests) flag of the Nginx chain link buffers. (Before the `v0.7.14` release, the "eof" flag does not work at all in subrequests.)

The output data stream can be aborted immediately by running the following Lua statement:

```lua

 return ngx.ERROR
```

This will truncate the response body and usually result in incomplete and also invalid responses.

The Lua code can pass its own modified version of the input data chunk to the downstream Nginx output body filters by overriding [ngx.arg](#ngxarg)\[1\] with a Lua string or a Lua table of strings. For example, to transform all the lowercase letters in the response body, we can just write:

```nginx

 location / {
     proxy_pass http://mybackend;
     body_filter_by_lua 'ngx.arg[1] = string.upper(ngx.arg[1])';
 }
```

When setting `nil` or an empty Lua string value to `ngx.arg[1]`, no data chunk will be passed to the downstream Nginx output filters at all.

Likewise, new "eof" flag can also be specified by setting a boolean value to [ngx.arg](#ngxarg)\[2\]. For example,

```nginx

 location /t {
     echo hello world;
     echo hiya globe;

     body_filter_by_lua '
         local chunk = ngx.arg[1]
         if string.match(chunk, "hello") then
             ngx.arg[2] = true  -- new eof
             return
         end

         -- just throw away any remaining chunk data
         ngx.arg[1] = nil
     ';
 }
```

Then `GET /t` will just return the output


    hello world


That is, when the body filter sees a chunk containing the word "hello", then it will set the "eof" flag to true immediately, resulting in truncated but still valid responses.

When the Lua code may change the length of the response body, then it is required to always clear out the `Content-Length` response header (if any) in a header filter to enforce streaming output, as in

```nginx

 location /foo {
     # fastcgi_pass/proxy_pass/...

     header_filter_by_lua_block { ngx.header.content_length = nil }
     body_filter_by_lua 'ngx.arg[1] = string.len(ngx.arg[1]) .. "\\n"';
 }
```

Note that the following API functions are currently disabled within this context due to the limitations in Nginx output filter's current implementation:

* Output API functions (e.g., [ngx.say](#ngxsay) and [ngx.send_headers](#ngxsend_headers))
* Control API functions (e.g., [ngx.exit](#ngxexit) and [ngx.exec](#ngxexec))
* Subrequest API functions (e.g., [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi))
* Cosocket API functions (e.g., [ngx.socket.tcp](#ngxsockettcp) and [ngx.req.socket](#ngxreqsocket)).

Nginx output filters may be called multiple times for a single request because response body may be delivered in chunks. Thus, the Lua code specified by in this directive may also run multiple times in the lifetime of a single HTTP request.

This directive was first introduced in the `v0.5.0rc32` release.

body_filter_by_lua_block
------------------------

**syntax:** *body_filter_by_lua_block { lua-script-str }*

**context:** *http, server, location, location if*

**phase:** *output-body-filter*

Similar to the [body_filter_by_lua](#body_filter_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 body_filter_by_lua_block {
     local data, eof = ngx.arg[1], ngx.arg[2]
 }
```

This directive was first introduced in the `v0.9.17` release.

body_filter_by_lua_file
-----------------------

**syntax:** *body_filter_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http, server, location, location if*

**phase:** *output-body-filter*

Equivalent to [body_filter_by_lua](#body_filter_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.5.0rc32` release.

log_by_lua
----------

**syntax:** *log_by_lua &lt;lua-script-str&gt;*

**context:** *http, server, location, location if*

**phase:** *log*

**NOTE** Use of this directive is *discouraged* following the `v0.9.17` release. Use the [log_by_lua_block](#log_by_lua_block) directive instead.

Runs the Lua source code inlined as the `<lua-script-str>` at the `log` request processing phase. This does not replace the current access logs, but runs before.

Note that the following API functions are currently disabled within this context:

* Output API functions (e.g., [ngx.say](#ngxsay) and [ngx.send_headers](#ngxsend_headers))
* Control API functions (e.g., [ngx.exit](#ngxexit))
* Subrequest API functions (e.g., [ngx.location.capture](#ngxlocationcapture) and [ngx.location.capture_multi](#ngxlocationcapture_multi))
* Cosocket API functions (e.g., [ngx.socket.tcp](#ngxsockettcp) and [ngx.req.socket](#ngxreqsocket)).

Here is an example of gathering average data for [$upstream_response_time](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#var_upstream_response_time):

```nginx

 lua_shared_dict log_dict 5M;

 server {
     location / {
         proxy_pass http://mybackend;

         log_by_lua '
             local log_dict = ngx.shared.log_dict
             local upstream_time = tonumber(ngx.var.upstream_response_time)

             local sum = log_dict:get("upstream_time-sum") or 0
             sum = sum + upstream_time
             log_dict:set("upstream_time-sum", sum)

             local newval, err = log_dict:incr("upstream_time-nb", 1)
             if not newval and err == "not found" then
                 log_dict:add("upstream_time-nb", 0)
                 log_dict:incr("upstream_time-nb", 1)
             end
         ';
     }

     location = /status {
         content_by_lua_block {
             local log_dict = ngx.shared.log_dict
             local sum = log_dict:get("upstream_time-sum")
             local nb = log_dict:get("upstream_time-nb")

             if nb and sum then
                 ngx.say("average upstream response time: ", sum / nb,
                         " (", nb, " reqs)")
             else
                 ngx.say("no data yet")
             end
         }
     }
 }
```

This directive was first introduced in the `v0.5.0rc31` release.

log_by_lua_block
----------------

**syntax:** *log_by_lua_block { lua-script }*

**context:** *http, server, location, location if*

**phase:** *log*

Similar to the [log_by_lua](#log_by_lua) directive except that this directive inlines
the Lua source directly
inside a pair of curly braces (`{}`) instead of in an Nginx string literal (which requires
special character escaping).

For instance,

```nginx

 log_by_lua_block {
     print("I need no extra escaping here, for example: \r\nblah")
 }
```

This directive was first introduced in the `v0.9.17` release.

log_by_lua_file
---------------

**syntax:** *log_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http, server, location, location if*

**phase:** *log*

Equivalent to [log_by_lua](#log_by_lua), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.5.0rc31` release.

balancer_by_lua_block
---------------------

**syntax:** *balancer_by_lua_block { lua-script }*

**context:** *upstream*

**phase:** *content*

This directive runs Lua code as an upstream balancer for any upstream entities defined
by the `upstream {}` configuration block.

For instance,

```nginx

 upstream foo {
     server 127.0.0.1;
     balancer_by_lua_block {
         -- use Lua to do something interesting here
         -- as a dynamic balancer
     }
 }

 server {
     location / {
         proxy_pass http://foo;
     }
 }
```

The resulting Lua load balancer can work with any existing Nginx upstream modules
like [ngx_proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html) and
[ngx_fastcgi](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html).

Also, the Lua load balancer can work with the standard upstream connection pool mechanism,
i.e., the standard [keepalive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) directive.
Just ensure that the [keepalive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) directive
is used *after* this `balancer_by_lua_block` directive in a single `upstream {}` configuration block.

The Lua load balancer can totally ignore the list of servers defined in the `upstream {}` block
and select peer from a completely dynamic server list (even changing per request) via the
[ngx.balancer](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/balancer.md) module
from the [lua-resty-core](https://github.com/openresty/lua-resty-core) library.

The Lua code handler registered by this directive might get called more than once in a single
downstream request when the Nginx upstream mechanism retries the request on conditions
specified by directives like the [proxy_next_upstream](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)
directive.

This Lua code execution context does not support yielding, so Lua APIs that may yield
(like cosockets and "light threads") are disabled in this context. One can usually work
around this limitation by doing such operations in an earlier phase handler (like
[access_by_lua*](#access_by_lua)) and passing along the result into this context
via the [ngx.ctx](#ngxctx) table.

This directive was first introduced in the `v0.10.0` release.

balancer_by_lua_file
--------------------

**syntax:** *balancer_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *upstream*

**phase:** *content*

Equivalent to [balancer_by_lua_block](#balancer_by_lua_block), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.10.0` release.

lua_need_request_body
---------------------

**syntax:** *lua_need_request_body &lt;on|off&gt;*

**default:** *off*

**context:** *http, server, location, location if*

**phase:** *depends on usage*

Determines whether to force the request body data to be read before running rewrite/access/content_by_lua* or not. The Nginx core does not read the client request body by default and if request body data is required, then this directive should be turned `on` or the [ngx.req.read_body](#ngxreqread_body) function should be called within the Lua code.

To read the request body data within the [$request_body](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_body) variable,
[client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size) must have the same value as [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size). Because when the content length exceeds [client_body_buffer_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size) but less than [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size), Nginx will buffer the data into a temporary file on the disk, which will lead to empty value in the [$request_body](http://nginx.org/en/docs/http/ngx_http_core_module.html#var_request_body) variable.

If the current location includes [rewrite_by_lua*](#rewrite_by_lua) directives,
then the request body will be read just before the [rewrite_by_lua*](#rewrite_by_lua) code is run (and also at the
`rewrite` phase). Similarly, if only [content_by_lua](#content_by_lua) is specified,
the request body will not be read until the content handler's Lua code is
about to run (i.e., the request body will be read during the content phase).

It is recommended however, to use the [ngx.req.read_body](#ngxreqread_body) and [ngx.req.discard_body](#ngxreqdiscard_body) functions for finer control over the request body reading process instead.

This also applies to [access_by_lua*](#access_by_lua).

ssl_certificate_by_lua_block
----------------------------

**syntax:** *ssl_certificate_by_lua_block { lua-script }*

**context:** *server*

**phase:** *right-before-SSL-handshake*

This directive runs user Lua code when Nginx is about to start the SSL handshake for the downstream
SSL (https) connections.

It is particularly useful for setting the SSL certificate chain and the corresponding private key on a per-request
basis. It is also useful to load such handshake configurations nonblockingly from the remote (for example,
with the [cosocket](#ngxsockettcp) API). And one can also do per-request OCSP stapling handling in pure
Lua here as well.

Another typical use case is to do SSL handshake traffic control nonblockingly in this context,
with the help of the [lua-resty-limit-traffic#readme](https://github.com/openresty/lua-resty-limit-traffic)
library, for example.

One can also do interesting things with the SSL handshake requests from the client side, like
rejecting old SSL clients using the SSLv3 protocol or even below selectively.

The [ngx.ssl](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md)
and [ngx.ocsp](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ocsp.md) Lua modules
provided by the [lua-resty-core](https://github.com/openresty/lua-resty-core/#readme)
library are particularly useful in this context. You can use the Lua API offered by these two Lua modules
to manipulate the SSL certificate chain and private key for the current SSL connection
being initiated.

This Lua handler does not run at all, however, when Nginx/OpenSSL successfully resumes
the SSL session via SSL session IDs or TLS session tickets for the current SSL connection. In
other words, this Lua handler only runs when Nginx has to initiate a full SSL handshake.

Below is a trivial example using the
[ngx.ssl](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md) module
at the same time:

```nginx

 server {
     listen 443 ssl;
     server_name   test.com;

     ssl_certificate_by_lua_block {
         print("About to initiate a new SSL handshake!")
     }

     location / {
         root html;
     }
 }
```

See more complicated examples in the [ngx.ssl](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl.md)
and [ngx.ocsp](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ocsp.md)
Lua modules' official documentation.

Uncaught Lua exceptions in the user Lua code immediately abort the current SSL session, so does the
[ngx.exit](#ngxexit) call with an error code like `ngx.ERROR`.

This Lua code execution context *does* support yielding, so Lua APIs that may yield
(like cosockets, sleeping, and "light threads")
are enabled in this context.

Note, however, you still need to configure the [ssl_certificate](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate) and
[ssl_certificate_key](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate_key)
directives even though you will not use this static certificate and private key at all. This is
because the NGINX core requires their appearance otherwise you are seeing the following error
while starting NGINX:


    nginx: [emerg] no ssl configured for the server


This directive requires OpenSSL 1.0.2e or greater.

If you are using the [official pre-built
packages](https://openresty.org/en/linux-packages.html) for
[OpenResty](https://openresty.org/) 1.9.7.2 or later, then everything should
work out of the box.

If you are not using one of the [OpenSSL
packages](https://openresty.org/en/linux-packages.html) provided by
[OpenResty](https://openresty.org), you will need to apply patches to OpenSSL
in order to use this directive:

<https://openresty.org/en/openssl-patches.html>

Similarly, if you are not using the Nginx core shipped with
[OpenResty](https://openresty.org) 1.9.7.2 or later, you will need to apply
patches to the standard Nginx core:

<https://openresty.org/en/nginx-ssl-patches.html>

This directive was first introduced in the `v0.10.0` release.

ssl_certificate_by_lua_file
---------------------------

**syntax:** *ssl_certificate_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *server*

**phase:** *right-before-SSL-handshake*

Equivalent to [ssl_certificate_by_lua_block](#ssl_certificate_by_lua_block), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or, as from the `v0.5.0rc32` release, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.10.0` release.

ssl_session_fetch_by_lua_block
------------------------------

**syntax:** *ssl_session_fetch_by_lua_block { lua-script }*

**context:** *http*

**phase:** *right-before-SSL-handshake*

This directive runs Lua code to look up and load the SSL session (if any) according to the session ID
provided by the current SSL handshake request for the downstream.

The Lua API for obtaining the current session ID and loading a cached SSL session data
is provided in the [ngx.ssl.session](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl/session.md)
Lua module shipped with the [lua-resty-core](https://github.com/openresty/lua-resty-core#readme)
library.

Lua APIs that may yield, like [ngx.sleep](#ngxsleep) and [cosockets](#ngxsockettcp),
are enabled in this context.

This hook, together with the [ssl_session_store_by_lua*](#ssl_session_store_by_lua_block) hook,
can be used to implement distributed caching mechanisms in pure Lua (based
on the [cosocket](#ngxsockettcp) API, for example). If a cached SSL session is found
and loaded into the current SSL connection context,
SSL session resumption can then get immediately initiated and bypass the full SSL handshake process which is very expensive in terms of CPU time.

Please note that TLS session tickets are very different and it is the clients' responsibility
to cache the SSL session state when session tickets are used. SSL session resumptions based on
TLS session tickets would happen automatically without going through this hook (nor the
[ssl_session_store_by_lua*](#ssl_session_store_by_lua_block) hook). This hook is mainly
for older or less capable SSL clients that can only do SSL sessions by session IDs.

When [ssl_certificate_by_lua*](#ssl_certificate_by_lua_block) is specified at the same time,
this hook usually runs before [ssl_certificate_by_lua*](#ssl_certificate_by_lua_block).
When the SSL session is found and successfully loaded for the current SSL connection,
SSL session resumption will happen and thus bypass the [ssl_certificate_by_lua*](#ssl_certificate_by_lua_block)
hook completely. In this case, Nginx also bypasses the [ssl_session_store_by_lua*](#ssl_session_store_by_lua_block)
hook, for obvious reasons.

To easily test this hook locally with a modern web browser, you can temporarily put the following line
in your https server block to disable the TLS session ticket support:

    ssl_session_tickets off;

But do not forget to comment this line out before publishing your site to the world.

If you are using the [official pre-built packages](https://openresty.org/en/linux-packages.html) for [OpenResty](https://openresty.org/)
1.11.2.1 or later, then everything should work out of the box.

If you are not using one of the [OpenSSL
packages](https://openresty.org/en/linux-packages.html) provided by
[OpenResty](https://openresty.org), you will need to apply patches to OpenSSL
in order to use this directive:

<https://openresty.org/en/openssl-patches.html>

Similarly, if you are not using the Nginx core shipped with
[OpenResty](https://openresty.org) 1.11.2.1 or later, you will need to apply
patches to the standard Nginx core:

<https://openresty.org/en/nginx-ssl-patches.html>

This directive was first introduced in the `v0.10.6` release.

Note that this directive can only be used in the **http context** starting
with the `v0.10.7` release since SSL session resumption happens
before server name dispatch.

ssl_session_fetch_by_lua_file
-----------------------------

**syntax:** *ssl_session_fetch_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http*

**phase:** *right-before-SSL-handshake*

Equivalent to [ssl_session_fetch_by_lua_block](#ssl_session_fetch_by_lua_block), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or rather, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.10.6` release.

Note that: this directive is only allowed to used in **http context** from the `v0.10.7` release
(because SSL session resumption happens before server name dispatch).

ssl_session_store_by_lua_block
------------------------------

**syntax:** *ssl_session_store_by_lua_block { lua-script }*

**context:** *http*

**phase:** *right-after-SSL-handshake*

This directive runs Lua code to fetch and save the SSL session (if any) according to the session ID
provided by the current SSL handshake request for the downstream. The saved or cached SSL
session data can be used for future SSL connections to resume SSL sessions without going
through the full SSL handshake process (which is very expensive in terms of CPU time).

Lua APIs that may yield, like [ngx.sleep](#ngxsleep) and [cosockets](#ngxsockettcp),
are *disabled* in this context. You can still, however, use the [ngx.timer.at](#ngxtimerat) API
to create 0-delay timers to save the SSL session data asynchronously to external services (like `redis` or `memcached`).

The Lua API for obtaining the current session ID and the associated session state data
is provided in the [ngx.ssl.session](https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/ssl/session.md#readme)
Lua module shipped with the [lua-resty-core](https://github.com/openresty/lua-resty-core#readme)
library.

To easily test this hook locally with a modern web browser, you can temporarily put the following line
in your https server block to disable the TLS session ticket support:

    ssl_session_tickets off;

But do not forget to comment this line out before publishing your site to the world.

This directive was first introduced in the `v0.10.6` release.

Note that: this directive is only allowed to used in **http context** from the `v0.10.7` release
(because SSL session resumption happens before server name dispatch).

ssl_session_store_by_lua_file
-----------------------------

**syntax:** *ssl_session_store_by_lua_file &lt;path-to-lua-script-file&gt;*

**context:** *http*

**phase:** *right-after-SSL-handshake*

Equivalent to [ssl_session_store_by_lua_block](#ssl_session_store_by_lua_block), except that the file specified by `<path-to-lua-script-file>` contains the Lua code, or rather, the [LuaJIT bytecode](#luajit-bytecode-support) to be executed.

When a relative path like `foo/bar.lua` is given, they will be turned into the absolute path relative to the `server prefix` path determined by the `-p PATH` command-line option while starting the Nginx server.

This directive was first introduced in the `v0.10.6` release.

Note that: this directive is only allowed to used in **http context** from the `v0.10.7` release
(because SSL session resumption happens before server name dispatch).

lua_shared_dict
---------------

**syntax:** *lua_shared_dict &lt;name&gt; &lt;size&gt;*

**default:** *no*

**context:** *http*

**phase:** *depends on usage*

Declares a shared memory zone, `<name>`, to serve as storage for the shm based Lua dictionary `ngx.shared.<name>`.

Shared memory zones are always shared by all the Nginx worker processes in the current Nginx server instance.

The `<size>` argument accepts size units such as `k` and `m`:

```nginx

 http {
     lua_shared_dict dogs 10m;
     ...
 }
```

The hard-coded minimum size is 8KB while the practical minimum size depends
on actual user data set (some people start with 12KB).

See [ngx.shared.DICT](#ngxshareddict) for details.

This directive was first introduced in the `v0.3.1rc22` release.

lua_socket_connect_timeout
--------------------------

**syntax:** *lua_socket_connect_timeout &lt;time&gt;*

**default:** *lua_socket_connect_timeout 60s*

**context:** *http, server, location*

This directive controls the default timeout value used in TCP/unix-domain socket object's [connect](#tcpsockconnect) method and can be overridden by the [settimeout](#tcpsocksettimeout) or [settimeouts](#tcpsocksettimeouts) methods.

The `<time>` argument can be an integer, with an optional time unit, like `s` (second), `ms` (millisecond), `m` (minute). The default time unit is `s`, i.e., "second". The default setting is `60s`.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_send_timeout
-----------------------

**syntax:** *lua_socket_send_timeout &lt;time&gt;*

**default:** *lua_socket_send_timeout 60s*

**context:** *http, server, location*

Controls the default timeout value used in TCP/unix-domain socket object's [send](#tcpsocksend) method and can be overridden by the [settimeout](#tcpsocksettimeout) or [settimeouts](#tcpsocksettimeouts) methods.

The `<time>` argument can be an integer, with an optional time unit, like `s` (second), `ms` (millisecond), `m` (minute). The default time unit is `s`, i.e., "second". The default setting is `60s`.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_send_lowat
---------------------

**syntax:** *lua_socket_send_lowat &lt;size&gt;*

**default:** *lua_socket_send_lowat 0*

**context:** *http, server, location*

Controls the `lowat` (low water) value for the cosocket send buffer.

lua_socket_read_timeout
-----------------------

**syntax:** *lua_socket_read_timeout &lt;time&gt;*

**default:** *lua_socket_read_timeout 60s*

**context:** *http, server, location*

**phase:** *depends on usage*

This directive controls the default timeout value used in TCP/unix-domain socket object's [receive](#tcpsockreceive) method and iterator functions returned by the [receiveuntil](#tcpsockreceiveuntil) method. This setting can be overridden by the [settimeout](#tcpsocksettimeout) or [settimeouts](#tcpsocksettimeouts) methods.

The `<time>` argument can be an integer, with an optional time unit, like `s` (second), `ms` (millisecond), `m` (minute). The default time unit is `s`, i.e., "second". The default setting is `60s`.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_buffer_size
----------------------

**syntax:** *lua_socket_buffer_size &lt;size&gt;*

**default:** *lua_socket_buffer_size 4k/8k*

**context:** *http, server, location*

Specifies the buffer size used by cosocket reading operations.

This buffer does not have to be that big to hold everything at the same time because cosocket supports 100% non-buffered reading and parsing. So even `1` byte buffer size should still work everywhere but the performance could be terrible.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_pool_size
--------------------

**syntax:** *lua_socket_pool_size &lt;size&gt;*

**default:** *lua_socket_pool_size 30*

**context:** *http, server, location*

Specifies the size limit (in terms of connection count) for every cosocket connection pool associated with every remote server (i.e., identified by either the host-port pair or the unix domain socket file path).

Default to 30 connections for every pool.

When the connection pool exceeds the available size limit, the least recently used (idle) connection already in the pool will be closed to make room for the current connection.

Note that the cosocket connection pool is per Nginx worker process rather than per Nginx server instance, so size limit specified here also applies to every single Nginx worker process.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_keepalive_timeout
----------------------------

**syntax:** *lua_socket_keepalive_timeout &lt;time&gt;*

**default:** *lua_socket_keepalive_timeout 60s*

**context:** *http, server, location*

This directive controls the default maximal idle time of the connections in the cosocket built-in connection pool. When this timeout reaches, idle connections will be closed and removed from the pool. This setting can be overridden by cosocket objects' [setkeepalive](#tcpsocksetkeepalive) method.

The `<time>` argument can be an integer, with an optional time unit, like `s` (second), `ms` (millisecond), `m` (minute). The default time unit is `s`, i.e., "second". The default setting is `60s`.

This directive was first introduced in the `v0.5.0rc1` release.

lua_socket_log_errors
---------------------

**syntax:** *lua_socket_log_errors on|off*

**default:** *lua_socket_log_errors on*

**context:** *http, server, location*

This directive can be used to toggle error logging when a failure occurs for the TCP or UDP cosockets. If you are already doing proper error handling and logging in your Lua code, then it is recommended to turn this directive off to prevent data flushing in your Nginx error log files (which is usually rather expensive).

This directive was first introduced in the `v0.5.13` release.

lua_ssl_ciphers
---------------

**syntax:** *lua_ssl_ciphers &lt;ciphers&gt;*

**default:** *lua_ssl_ciphers DEFAULT*

**context:** *http, server, location*

Specifies the enabled ciphers for requests to a SSL/TLS server in the [tcpsock:sslhandshake](#tcpsocksslhandshake) method. The ciphers are specified in the format understood by the OpenSSL library.

The full list can be viewed using the “openssl ciphers” command.

This directive was first introduced in the `v0.9.11` release.

lua_ssl_crl
-----------

**syntax:** *lua_ssl_crl &lt;file&gt;*

**default:** *no*

**context:** *http, server, location*

Specifies a file with revoked certificates (CRL) in the PEM format used to verify the certificate of the SSL/TLS server in the [tcpsock:sslhandshake](#tcpsocksslhandshake) method.

This directive was first introduced in the `v0.9.11` release.

lua_ssl_protocols
-----------------

**syntax:** *lua_ssl_protocols \[SSLv2\] \[SSLv3\] \[TLSv1\] [TLSv1.1] [TLSv1.2] [TLSv1.3]*

**default:** *lua_ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2*

**context:** *http, server, location*

Enables the specified protocols for requests to a SSL/TLS server in the [tcpsock:sslhandshake](#tcpsocksslhandshake) method.

The support for the `TLSv1.3` parameter requires version `v0.10.12` *and* OpenSSL 1.1.1.

This directive was first introduced in the `v0.9.11` release.

lua_ssl_trusted_certificate
---------------------------

**syntax:** *lua_ssl_trusted_certificate &lt;file&gt;*

**default:** *no*

**context:** *http, server, location*

Specifies a file path with trusted CA certificates in the PEM format used to verify the certificate of the SSL/TLS server in the [tcpsock:sslhandshake](#tcpsocksslhandshake) method.

This directive was first introduced in the `v0.9.11` release.

See also [lua_ssl_verify_depth](#lua_ssl_verify_depth).

lua_ssl_verify_depth
--------------------

**syntax:** *lua_ssl_verify_depth &lt;number&gt;*

**default:** *lua_ssl_verify_depth 1*

**context:** *http, server, location*

Sets the verification depth in the server certificates chain.

This directive was first introduced in the `v0.9.11` release.

See also [lua_ssl_trusted_certificate](#lua_ssl_trusted_certificate).

lua_http10_buffering
--------------------

**syntax:** *lua_http10_buffering on|off*

**default:** *lua_http10_buffering on*

**context:** *http, server, location, location-if*

Enables or disables automatic response buffering for HTTP 1.0 (or older) requests. This buffering mechanism is mainly used for HTTP 1.0 keep-alive which relies on a proper `Content-Length` response header.

If the Lua code explicitly sets a `Content-Length` response header before sending the headers (either explicitly via [ngx.send_headers](#ngxsend_headers) or implicitly via the first [ngx.say](#ngxsay) or [ngx.print](#ngxprint) call), then the HTTP 1.0 response buffering will be disabled even when this directive is turned on.

To output very large response data in a streaming fashion (via the [ngx.flush](#ngxflush) call, for example), this directive MUST be turned off to minimize memory usage.

This directive is turned `on` by default.

This directive was first introduced in the `v0.5.0rc19` release.

rewrite_by_lua_no_postpone
--------------------------

**syntax:** *rewrite_by_lua_no_postpone on|off*

**default:** *rewrite_by_lua_no_postpone off*

**context:** *http*

Controls whether or not to disable postponing [rewrite_by_lua*](#rewrite_by_lua) directives to run at the end of the `rewrite` request-processing phase. By default, this directive is turned off and the Lua code is postponed to run at the end of the `rewrite` phase.

This directive was first introduced in the `v0.5.0rc29` release.

access_by_lua_no_postpone
-------------------------

**syntax:** *access_by_lua_no_postpone on|off*

**default:** *access_by_lua_no_postpone off*

**context:** *http*

Controls whether or not to disable postponing [access_by_lua*](#access_by_lua) directives to run at the end of the `access` request-processing phase. By default, this directive is turned off and the Lua code is postponed to run at the end of the `access` phase.

This directive was first introduced in the `v0.9.20` release.

lua_transform_underscores_in_response_headers
---------------------------------------------

**syntax:** *lua_transform_underscores_in_response_headers on|off*

**default:** *lua_transform_underscores_in_response_headers on*

**context:** *http, server, location, location-if*

Controls whether to transform underscores (`_`) in the response header names specified in the [ngx.header.HEADER](#ngxheaderheader) API to hypens (`-`).

This directive was first introduced in the `v0.5.0rc32` release.

lua_check_client_abort
----------------------

**syntax:** *lua_check_client_abort on|off*

**default:** *lua_check_client_abort off*

**context:** *http, server, location, location-if*

This directive controls whether to check for premature client connection abortion.

When this directive is on, the ngx_lua module will monitor the premature connection close event on the downstream connections and when there is such an event, it will call the user Lua function callback (registered by [ngx.on_abort](#ngxon_abort)) or just stop and clean up all the Lua "light threads" running in the current request's request handler when there is no user callback function registered.

According to the current implementation, however, if the client closes the connection before the Lua code finishes reading the request body data via [ngx.req.socket](#ngxreqsocket), then ngx_lua will neither stop all the running "light threads" nor call the user callback (if [ngx.on_abort](#ngxon_abort) has been called). Instead, the reading operation on [ngx.req.socket](#ngxreqsocket) will just return the error message "client aborted" as the second return value (the first return value is surely `nil`).

When TCP keepalive is disabled, it is relying on the client side to close the socket gracefully (by sending a `FIN` packet or something like that). For (soft) real-time web applications, it is highly recommended to configure the [TCP keepalive](http://tldp.org/HOWTO/TCP-Keepalive-HOWTO/overview.html) support in your system's TCP stack implementation in order to detect "half-open" TCP connections in time.

For example, on Linux, you can configure the standard [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen) directive in your `nginx.conf` file like this:

```nginx

 listen 80 so_keepalive=2s:2s:8;
```

On FreeBSD, you can only tune the system-wide configuration for TCP keepalive, for example:

    # sysctl net.inet.tcp.keepintvl=2000
    # sysctl net.inet.tcp.keepidle=2000

This directive was first introduced in the `v0.7.4` release.

See also [ngx.on_abort](#ngxon_abort).

lua_max_pending_timers
----------------------

**syntax:** *lua_max_pending_timers &lt;count&gt;*

**default:** *lua_max_pending_timers 1024*

**context:** *http*

Controls the maximum number of pending timers allowed.

Pending timers are those timers that have not expired yet.

When exceeding this limit, the [ngx.timer.at](#ngxtimerat) call will immediately return `nil` and the error string "too many pending timers".

This directive was first introduced in the `v0.8.0` release.

lua_max_running_timers
----------------------

**syntax:** *lua_max_running_timers &lt;count&gt;*

**default:** *lua_max_running_timers 256*

**context:** *http*

Controls the maximum number of "running timers" allowed.

Running timers are those timers whose user callback functions are still running.

When exceeding this limit, Nginx will stop running the callbacks of newly expired timers and log an error message "N lua_max_running_timers are not enough" where "N" is the current value of this directive.

This directive was first introduced in the `v0.8.0` release.

lua_sa_restart
--------------

**syntax:** *lua_sa_restart on|off*

**default:** *lua_sa_restart on*

**context:** *http*

When enabled, this module will set the `SA_RESTART` flag on Nginx workers signal dispositions.

This allows Lua I/O primitives to not be interrupted by Nginx's handling of various signals.

This directive was first introduced in the `v0.10.14` release.