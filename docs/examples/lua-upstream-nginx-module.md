```nginx
http {
    upstream foo.com {
        server 127.0.0.1 fail_timeout=53 weight=4 max_fails=100;
        server agentzh.org:81;
    }

    upstream bar {
        server 127.0.0.2;
    }

    server {
        listen 8080;

        # sample output for the following /upstream interface:
        # upstream foo.com:
        #     addr = 127.0.0.1:80, weight = 4, fail_timeout = 53, max_fails = 100
        #     addr = 106.184.1.99:81, weight = 1, fail_timeout = 10, max_fails = 1
        # upstream bar:
        #     addr = 127.0.0.2:80, weight = 1, fail_timeout = 10, max_fails = 1

        location = /upstreams {
            default_type text/plain;
            content_by_lua_block {
                local concat = table.concat
                local upstream = require "ngx.upstream"
                local get_servers = upstream.get_servers
                local get_upstreams = upstream.get_upstreams

                local us = get_upstreams()
                for _, u in ipairs(us) do
                    ngx.say("upstream ", u, ":")
                    local srvs, err = get_servers(u)
                    if not srvs then
                        ngx.say("failed to get servers in upstream ", u)
                    else
                        for _, srv in ipairs(srvs) do
                            local first = true
                            for k, v in pairs(srv) do
                                if first then
                                    first = false
                                    ngx.print("    ")
                                else
                                    ngx.print(", ")
                                end
                                if type(v) == "table" then
                                    ngx.print(k, " = {", concat(v, ", "), "}")
                                else
                                    ngx.print(k, " = ", v)
                                end
                            end
                            ngx.print("\n")
                        end
                    end
                end
            }
        }
    }
}
```