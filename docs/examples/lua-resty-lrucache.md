```lua
-- file myapp.lua: example "myapp" module

local _M = {}

-- alternatively: local lrucache = require "resty.lrucache.pureffi"
local lrucache = require "resty.lrucache"

-- we need to initialize the cache on the lua module level so that
-- it can be shared by all the requests served by each nginx worker process:
local c, err = lrucache.new(200)  -- allow up to 200 items in the cache
if not c then
    error("failed to create the cache: " .. (err or "unknown"))
end

function _M.go()
    c:set("dog", 32)
    c:set("cat", 56)
    ngx.say("dog: ", c:get("dog"))
    ngx.say("cat: ", c:get("cat"))

    c:set("dog", { age = 10 }, 0.1)  -- expire in 0.1 sec
    c:delete("dog")

    c:flush_all()  -- flush all the cached data
end

return _M
```

```nginx
# nginx.conf

http {
    # only if not using an official OpenResty release
    lua_package_path "/path/to/lua-resty-lrucache/lib/?.lua;;";

    server {
        listen 8080;

        location = /t {
            content_by_lua_block {
                require("myapp").go()
            }
        }
    }
}
```