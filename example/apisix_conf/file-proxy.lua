local core = require("apisix.core")
local io = require("io")
local ngx = ngx

local plugin_name = "file-proxy"

local plugin_schema = {
    type = "object",
    properties = {
        path = {
            type = "string"
        },
    },
    required = {"path"}
}

local _M = {
    version = 1.0,
    priority = 1000,
    name = plugin_name,
    schema = plugin_schema
}

function _M.check_schema(conf)
  local ok, err = core.schema.check(plugin_schema, conf)
  if not ok then
      return false, err
  end
  return true
end

function _M.access(conf, ctx)
  local fd = io.open(conf.path, "rb")
  if fd then
    local content = fd:read("*all")
    fd:close()
    ngx.header.content_length = #content
    ngx.say(content)
    ngx.exit(ngx.OK)
  else
    ngx.exit(ngx.HTTP_NOT_FOUND)
    core.log.error("File is not found: ", conf.path, ", error info: ", err)
  end
end


function _M.log(conf, ctx)
    core.log.warn("conf: ", core.json.encode(conf))
    core.log.warn("ctx: ", core.json.encode(ctx, true))
end

return _M
