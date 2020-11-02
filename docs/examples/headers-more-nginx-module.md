# Example - headers-more-nginx-module

```lua
# set the Server output header
more_set_headers 'Server: my-server';

# set and clear output headers
location /bar {
    more_set_headers 'X-MyHeader: blah' 'X-MyHeader2: foo';
    more_set_headers -t 'text/plain text/css' 'Content-Type: text/foo';
    more_set_headers -s '400 404 500 503' -s 413 'Foo: Bar';
    more_clear_headers 'Content-Type';

    # your proxy_pass/memcached_pass/or any other config goes here...
}

# set output headers
location /type {
    more_set_headers 'Content-Type: text/plain';
    # ...
}

# set input headers
location /foo {
    set $my_host 'my dog';
    more_set_input_headers 'Host: $my_host';
    more_set_input_headers -t 'text/plain' 'X-Foo: bah';

    # now $host and $http_host have their new values...
    # ...
}

# replace input header X-Foo *only* if it already exists
more_set_input_headers -r 'X-Foo: howdy';
```
