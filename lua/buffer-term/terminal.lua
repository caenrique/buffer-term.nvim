local config = require('buffer-term.config')
local state = require('buffer-term.state')

local function get_origin_buffer()

  local buffer = vim.api.nvim_win_get_buf(0)
  local buftype = vim.api.nvim_buf_get_option(buffer, 'buftype')
  local term = state.find_by_buffer(buffer)

  if buftype == 'terminal' and term then
    return term.origin_buffer
  else
    return buffer
  end
end

local Terminal = {}

function Terminal:new(term_id)
  local origin_buffer = get_origin_buffer()

  vim.cmd.terminal()

  local terminal_buffer = vim.api.nvim_win_get_buf(0)

  vim.bo[terminal_buffer].modified = false
  vim.bo[terminal_buffer].buflisted = config.terminal_options.buf_listed
  vim.bo[terminal_buffer].bufhidden = 'hide'

  vim.api.nvim_win_set_buf(0, origin_buffer)

  local t = {
    id = term_id,
    origin_buffer = origin_buffer,
    terminal_buffer = terminal_buffer,
  }

  setmetatable(t, self)
  self.__index = self

  state.set(t)

  return t
end

function Terminal:hide()
  if self.terminal_buffer == self.origin_buffer or self.origin_buffer == nil then
    local empty_buf = vim.api.nvim_create_buf(true, false)
    self.origin_buffer = empty_buf
    state.set(self)
  end
  vim.api.nvim_win_set_buf(0, self.origin_buffer)
end

function Terminal:show()
  self.origin_buffer = get_origin_buffer()
  state.set(self)
  vim.api.nvim_win_set_buf(0, self.terminal_buffer)
end

function Terminal:delete()
  state.delete(self.terminal_buffer)
end

return Terminal
