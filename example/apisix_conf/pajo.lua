local core = require("apisix.core")
local base = require("apisix.plugins.pajo.init")


-- avoid unexpected data sharing
local pajo = core.table.clone(base)
pajo.access = base.restrict


return pajo