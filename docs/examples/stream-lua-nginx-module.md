```nginx
events {
    worker_connections 1024;
}

stream {
    # define a TCP server listening on the port 1234:
    server {
        listen 1234;

        content_by_lua_block {
            ngx.say("Hello, Lua!")
        }
    }
}
```

---

```nginx
stream {
    server {
        listen 4343 ssl;

        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         AES128-SHA:AES256-SHA:RC4-SHA:DES-CBC3-SHA:RC4-MD5;
        ssl_certificate     /path/to/cert.pem;
        ssl_certificate_key /path/to/cert.key;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;

        content_by_lua_block {
            local sock = assert(ngx.req.socket(true))
            local data = sock:receive()  -- read a line from downstream
            if data == "thunder!" then
                ngx.say("flash!")  -- output data
            else
                ngx.say("boom!")
            end
            ngx.say("the end...")
        }
    }
}
```

---

```nginx
stream {
    server {
        listen unix:/tmp/nginx.sock;

        content_by_lua_block {
            ngx.say("What's up?")
            ngx.flush(true)  -- flush any pending output and wait
            ngx.sleep(3)  -- sleeping for 3 sec
            ngx.say("Bye bye...")
        }
    }
}
```