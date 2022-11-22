local state = require('buffer-term.state')

local M = {}

function M.get_status()
  local keys = {}
  local n = 0

  for k, _ in pairs(state.id) do
    n = n + 1
    keys[n] = k
  end

  return 'Terminals: [' .. table.concat(keys, ',') .. ']'
end

return M
