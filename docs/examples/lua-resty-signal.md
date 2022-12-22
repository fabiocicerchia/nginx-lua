# Example - lua-resty-signal

```lua
local resty_signal = require "resty.signal"
local pid = 12345

local ok, err = resty_signal.kill(pid, "TERM")
if not ok then
    ngx.log(ngx.ERR, "failed to kill process of pid ", pid, ": ", err)
    return
end

-- send the signal 0 to check the existence of a process
local ok, err = resty_signal.kill(pid, "NONE")

local ok, err = resty_signal.kill(pid, "HUP")

local ok, err = resty_signal.kill(pid, "KILL")
```
