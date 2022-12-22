# Example - lua-resty-core

```nginx
# nginx.conf

http {
    # you do NOT need to configure the following line when you
    # are using the OpenResty bundle 1.4.3.9+.
    lua_package_path "/path/to/lua-resty-core/lib/?.lua;;";

    init_by_lua_block {
        require "resty.core"
        collectgarbage("collect")  -- just to collect any garbage
    }

    ...
}
```
