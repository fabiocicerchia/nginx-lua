# Example - set-misc-nginx-module

```nginx
location /foo {
    set $a $arg_a;
    set_if_empty $a 56;

    # GET /foo?a=32 will yield $a == 32
    # while GET /foo and GET /foo?a= will
    # yeild $a == 56 here.
}

location /bar {
    set $foo "hello\n\n'\"\\";
    set_quote_sql_str $foo $foo; # for mysql

    # OR in-place editing:
    #   set_quote_sql_str $foo;

    # now $foo is: 'hello\n\n\'\"\\'
}

location /bar {
    set $foo "hello\n\n'\"\\";
    set_quote_pgsql_str $foo;  # for PostgreSQL

    # now $foo is: E'hello\n\n\'\"\\'
}

location /json {
    set $foo "hello\n\n'\"\\";
    set_quote_json_str $foo $foo;

    # OR in-place editing:
    #   set_quote_json_str $foo;

    # now $foo is: "hello\n\n'\"\\"
}

location /baz {
    set $foo "hello%20world";
    set_unescape_uri $foo $foo;

    # OR in-place editing:
    #   set_unescape_uri $foo;

    # now $foo is: hello world
}

upstream_list universe moon sun earth;
upstream moon { ... }
upstream sun { ... }
upstream earth { ... }
location /foo {
    set_hashed_upstream $backend universe $arg_id;
    drizzle_pass $backend; # used with ngx_drizzle
}

location /base32 {
    set $a 'abcde';
    set_encode_base32 $a;
    set_decode_base32 $b $a;

    # now $a == 'c5h66p35' and
    # $b == 'abcde'
}

location /base64 {
    set $a 'abcde';
    set_encode_base64 $a;
    set_decode_base64 $b $a;

    # now $a == 'YWJjZGU=' and
    # $b == 'abcde'
}

location /hex {
    set $a 'abcde';
    set_encode_hex $a;
    set_decode_hex $b $a;

    # now $a == '6162636465' and
    # $b == 'abcde'
}

# GET /sha1 yields the output
#   aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
location /sha1 {
    set_sha1 $a hello;
    echo $a;
}

# ditto
location /sha1 {
    set $a hello;
    set_sha1 $a;
    echo $a;
}

# GET /today yields the date of today in local time using format 'yyyy-mm-dd'
location /today {
    set_local_today $today;
    echo $today;
}

# GET /signature yields the hmac-sha-1 signature
# given a secret and a string to sign
# this example yields the base64 encoded singature which is
# "HkADYytcoQQzqbjQX33k/ZBB/DQ="
location /signature {
    set $secret_key 'secret-key';
    set $string_to_sign "some-string-to-sign";
    set_hmac_sha1 $signature $secret_key $string_to_sign;
    set_encode_base64 $signature $signature;
    echo $signature;
}

location = /rand {
    set $from 3;
    set $to 15;
    set_random $rand $from $to;

    # or write directly
    #   set_random $rand 3 15;

    echo $rand;  # will print a random integer in the range [3, 15]
}
```
