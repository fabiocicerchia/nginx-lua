# Example - lua-nginx-module

```nginx
# set search paths for pure Lua external libraries (';;' is the default path):
lua_package_path '/foo/bar/?.lua;/blah/?.lua;;';

# set search paths for Lua external libraries written in C (can also use ';;'):
lua_package_cpath '/bar/baz/?.so;/blah/blah/?.so;;';

server {
    location /lua_content {
        # MIME type determined by default_type:
        default_type 'text/plain';

        content_by_lua_block {
            ngx.say('Hello,world!')
        }
    }

    location /nginx_var {
        # MIME type determined by default_type:
        default_type 'text/plain';

        # try access /nginx_var?a=hello,world
        content_by_lua_block {
            ngx.say(ngx.var.arg_a)
        }
    }

    location = /request_body {
        client_max_body_size 50k;
        client_body_buffer_size 50k;

        content_by_lua_block {
            ngx.req.read_body()  -- explicitly read the req body
            local data = ngx.req.get_body_data()
            if data then
                ngx.say("body data:")
                ngx.print(data)
                return
            end

            -- body may get buffered in a temp file:
            local file = ngx.req.get_body_file()
            if file then
                ngx.say("body is in file ", file)
            else
                ngx.say("no body found")
            end
        }
    }

    # transparent non-blocking I/O in Lua via subrequests
    # (well, a better way is to use cosockets)
    location = /lua {
        # MIME type determined by default_type:
        default_type 'text/plain';

        content_by_lua_block {
            local res = ngx.location.capture("/some_other_location")
            if res then
                ngx.say("status: ", res.status)
                ngx.say("body:")
                ngx.print(res.body)
            end
        }
    }

    location = /foo {
        rewrite_by_lua_block {
            res = ngx.location.capture("/memc",
                { args = { cmd = "incr", key = ngx.var.uri } }
            )
        }

        proxy_pass http://blah.blah.com;
    }

    location = /mixed {
        rewrite_by_lua_file /path/to/rewrite.lua;
        access_by_lua_file /path/to/access.lua;
        content_by_lua_file /path/to/content.lua;
    }

    # use nginx var in code path
    # CAUTION: contents in nginx var must be carefully filtered,
    # otherwise there'll be great security risk!
    location ~ ^/app/([-_a-zA-Z0-9/]+) {
        set $path $1;
        content_by_lua_file /path/to/lua/app/root/$path.lua;
    }

    location / {
      client_max_body_size 100k;
      client_body_buffer_size 100k;

      access_by_lua_block {
          -- check the client IP address is in our black list
          if ngx.var.remote_addr == "132.5.72.3" then
              ngx.exit(ngx.HTTP_FORBIDDEN)
          end

          -- check if the URI contains bad words
          if ngx.var.uri and
                  string.match(ngx.var.request_body, "evil")
          then
              return ngx.redirect("/terms_of_use.html")
          end

          -- tests passed
      }

      # proxy_pass/fastcgi_pass/etc settings
    }
}
```
