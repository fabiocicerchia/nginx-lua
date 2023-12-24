# Example - lua-resty-balancer

```nginx
    lua_package_path "/path/to/lua-resty-chash/lib/?.lua;;";
    lua_package_cpath "/path/to/lua-resty-chash/?.so;;";

    init_by_lua_block {
        local resty_chash = require "resty.chash"
        local resty_roundrobin = require "resty.roundrobin"
        local resty_swrr = require "resty.swrr"

        local server_list = {
            ["127.0.0.1:1985"] = 2,
            ["127.0.0.1:1986"] = 2,
            ["127.0.0.1:1987"] = 1,
        }

        -- XX: we can do the following steps to keep consistency with nginx chash
        local str_null = string.char(0)

        local servers, nodes = {}, {}
        for serv, weight in pairs(server_list) do
            -- XX: we can just use serv as id when we doesn't need keep consistency with nginx chash
            local id = string.gsub(serv, ":", str_null)

            servers[id] = serv
            nodes[id] = weight
        end

        local chash_up = resty_chash:new(nodes)

        package.loaded.my_chash_up = chash_up
        package.loaded.my_servers = servers

        local rr_up = resty_roundrobin:new(server_list)
        package.loaded.my_rr_up = rr_up

        local swrr_up = resty_swrr:new(server_list)
        package.loaded.my_swrr_up = swrr_up
    }

    upstream backend_chash {
        server 0.0.0.1;
        balancer_by_lua_block {
            local b = require "ngx.balancer"

            local chash_up = package.loaded.my_chash_up
            local servers = package.loaded.my_servers

            -- we can balancer by any key here
            local id = chash_up:find(ngx.var.arg_key)
            local server = servers[id]

            assert(b.set_current_peer(server))
        }
    }

    upstream backend_rr {
        server 0.0.0.1;
        balancer_by_lua_block {
            local b = require "ngx.balancer"

            local rr_up = package.loaded.my_rr_up

            -- Note that Round Robin picks the first server randomly
            local server = rr_up:find()

            assert(b.set_current_peer(server))
        }
    }

    upstream backend_swrr {
        server 0.0.0.1;
        balancer_by_lua_block {
            local b = require "ngx.balancer"

            local swrr_up = package.loaded.my_swrr_up

            -- Note that SWRR picks the first server randomly
            local server = swrr_up:find()

            assert(b.set_current_peer(server))
        }
    }

    server {
        location /chash {
            proxy_pass http://backend_chash;
        }

        location /roundrobin {
            proxy_pass http://backend_rr;
        }

        location /swrr {
            proxy_pass http://backend_swrr;
        }
    }
```
