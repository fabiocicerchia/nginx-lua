```lua
local shell = require "resty.shell"

local stdin = "hello"
local timeout = 1000  -- ms
local max_size = 4096  -- byte

local ok, stdout, stderr, reason, status =
    shell.run([[perl -e 'warn "he\n"; print <>']], stdin, timeout, max_size)
if not ok then
    -- ...
end
```