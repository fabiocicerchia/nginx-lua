# Example - lua-resty-cookie

```lua
    lua_package_path "/path/to/lua-resty-cookie/lib/?.lua;;";

    server {
        location /test {
            content_by_lua '
                local ck = require "resty.cookie"
                local cookie, err = ck:new()
                if not cookie then
                    ngx.log(ngx.ERR, err)
                    return
                end

                -- get single cookie
                local field, err = cookie:get("lang")
                if not field then
                    ngx.log(ngx.ERR, err)
                    return
                end
                ngx.say("lang", " => ", field)

                -- get all cookies
                local fields, err = cookie:get_all()
                if not fields then
                    ngx.log(ngx.ERR, err)
                    return
                end

                for k, v in pairs(fields) do
                    ngx.say(k, " => ", v)
                end

                -- set one cookie
                local ok, err = cookie:set({
                    key = "Name", value = "Bob", path = "/",
                    domain = "example.com", secure = true, httponly = true,
                    expires = "Wed, 09 Jun 2021 10:18:14 GMT", max_age = 50,
                    samesite = "Strict", extension = "a4334aebaec"
                })
                if not ok then
                    ngx.log(ngx.ERR, err)
                    return
                end

                -- set another cookie, both cookies will appear in HTTP response
                local ok, err = cookie:set({
                    key = "Age", value = "20",
                })
                if not ok then
                    ngx.log(ngx.ERR, err)
                    return
                end
            ';
        }
    }
```
