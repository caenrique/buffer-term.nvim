local M = {}

local function defaults()
  return {
    start_insert = true,
    buf_listed = false,
    no_numbers = true,
  }
end

local config = defaults()

function M.setup(opts)
  local new_config = vim.tbl_deep_extend('force', {}, defaults(), opts or {})

  for _, key in ipairs(vim.tbl_keys(config)) do
    config[key] = nil
  end
  for key, val in pairs(new_config) do
    config[key] = val
  end
end

return setmetatable(config, { __index = M })
