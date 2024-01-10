# Example - lua-resty-lock

```nginx
# nginx.conf

http {
    # you do not need the following line if you are using the
    # OpenResty bundle:
    lua_package_path "/path/to/lua-resty-core/lib/?.lua;/path/to/lua-resty-lock/lib/?.lua;;";

    lua_shared_dict my_locks 100k;

    server {
        ...

        location = /t {
            content_by_lua '
                local resty_lock = require "resty.lock"
                for i = 1, 2 do
                    local lock, err = resty_lock:new("my_locks")
                    if not lock then
                        ngx.say("failed to create lock: ", err)
                    end

                    local elapsed, err = lock:lock("my_key")
                    ngx.say("lock: ", elapsed, ", ", err)

                    local ok, err = lock:unlock()
                    if not ok then
                        ngx.say("failed to unlock: ", err)
                    end
                    ngx.say("unlock: ", ok)
                end
            ';
        }
    }
}
```
