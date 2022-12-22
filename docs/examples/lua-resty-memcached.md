# Example - lua-resty-memcached

```nginx
lua_package_path "/path/to/lua-resty-memcached/lib/?.lua;;";

server {
    location /test {
        content_by_lua '
            local memcached = require "resty.memcached"
            local memc, err = memcached:new()
            if not memc then
                ngx.say("failed to instantiate memc: ", err)
                return
            end

            memc:set_timeout(1000) -- 1 sec

            -- or connect to a unix domain socket file listened
            -- by a memcached server:
            --     local ok, err = memc:connect("unix:/path/to/memc.sock")

            local ok, err = memc:connect("127.0.0.1", 11211)
            if not ok then
                ngx.say("failed to connect: ", err)
                return
            end

            local ok, err = memc:flush_all()
            if not ok then
                ngx.say("failed to flush all: ", err)
                return
            end

            local ok, err = memc:set("dog", 32)
            if not ok then
                ngx.say("failed to set dog: ", err)
                return
            end

            local res, flags, err = memc:get("dog")
            if err then
                ngx.say("failed to get dog: ", err)
                return
            end

            if not res then
                ngx.say("dog not found")
                return
            end

            ngx.say("dog: ", res)

            -- put it into the connection pool of size 100,
            -- with 10 seconds max idle timeout
            local ok, err = memc:set_keepalive(10000, 100)
            if not ok then
                ngx.say("cannot set keepalive: ", err)
                return
            end

            -- or just close the connection right away:
            -- local ok, err = memc:close()
            -- if not ok then
            --     ngx.say("failed to close: ", err)
            --     return
            -- end
        ';
    }
}
```
