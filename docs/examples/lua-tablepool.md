# Example - lua-tablepool

```nginx
local tablepool = require "tablepool"

local pool_name = "some_tag"

local my_tb = tablepool.fetch(pool_name, 0, 10)

-- using my_tb for some purposes...

tablepool.release(pool_name, my_tb)
```
