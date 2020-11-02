# Example - lua-resty-dns

```nginx
lua_package_path "/path/to/lua-resty-dns/lib/?.lua;;";

server {
    location = /dns {
        content_by_lua_block {
            local resolver = require "resty.dns.resolver"
            local r, err = resolver:new{
                nameservers = {"8.8.8.8", {"8.8.4.4", 53} },
                retrans = 5,  -- 5 retransmissions on receive timeout
                timeout = 2000,  -- 2 sec
            }

            if not r then
                ngx.say("failed to instantiate the resolver: ", err)
                return
            end

            local answers, err, tries = r:query("www.google.com", nil, {})
            if not answers then
                ngx.say("failed to query the DNS server: ", err)
                ngx.say("retry historie:\n  ", table.concat(tries, "\n  "))
                return
            end

            if answers.errcode then
                ngx.say("server returned error code: ", answers.errcode,
                        ": ", answers.errstr)
            end

            for i, ans in ipairs(answers) do
                ngx.say(ans.name, " ", ans.address or ans.cname,
                        " type:", ans.type, " class:", ans.class,
                        " ttl:", ans.ttl)
            end
        }
    }
}
```
