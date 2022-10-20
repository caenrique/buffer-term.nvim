local M = {}

local terminal = require('buffer-term.terminal')
local config = require('buffer-term.config')

function M.toggle(term_id)
  terminal.last = term_id
  local term = terminal.get(term_id)
  if term then
    if term.visible then
      terminal.hide(term_id)
    else
      terminal.show(term_id)
    end
  else
    terminal.new_terminal(term_id)
  end
end

function M.toggle_last()
  if terminal.last then
    M.toggle(terminal.last)
  end
end

function M.setup(opts)
  config.setup(opts)
end

return M
