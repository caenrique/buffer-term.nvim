M = {}

M.instances = {}
M.index = {}
M.last = nil

function M.hide_if_is_terminal()
  local buffer = vim.api.nvim_win_get_buf(0)
  local term_id = M.lookup(buffer)
  if M.instances[term_id] then
    M.instances[term_id].visible = false
  end
end

function M.new_terminal(term_id)
  local origin_buffer = M.get_origin_buffer()

  M.hide_if_is_terminal()

  vim.cmd.terminal()

  local buffer = vim.api.nvim_win_get_buf(0)

  local term = {
    visible = true,
    origin_buffer = origin_buffer,
    terminal_buffer = buffer,
    -- channel = channel,
  }

  M.instances[term_id] = term
  M.index[buffer] = term_id

  return term
end

function M.get_origin_buffer()
  local buffer = vim.api.nvim_win_get_buf(0)
  local buftype = vim.api.nvim_buf_get_option(buffer, 'buftype')
  local term_id = M.index[buffer]
  if buftype == 'terminal' and term_id then
    return M.get(term_id).origin_buffer
  else
    return buffer
  end
end

function M.get(term_id)
  return M.instances[term_id]
end

function M.lookup(buffer)
  return M.index[buffer]
end

function M.hide(term_id)
  M.instances[term_id].visible = false
  local t = M.get(term_id)

  if t.terminal_buffer == t.origin_buffer then
    local empty_buf = vim.api.nvim_create_buf(true, false)
    M.instances[term_id].origin_buffer = empty_buf
  end
  vim.api.nvim_win_set_buf(0, M.get(term_id).origin_buffer)
end

function M.show(term_id)
  M.hide_if_is_terminal()
  M.instances[term_id].visible = true
  M.instances[term_id].origin_buffer = M.get_origin_buffer()
  vim.api.nvim_win_set_buf(0, M.get(term_id).terminal_buffer)
end

function M.delete(buffer)
  local buftype = vim.api.nvim_buf_get_option(buffer, 'buftype')
  local term_id = M.lookup(buffer)
  if buftype == 'terminal' and term_id then
    M.instances[term_id] = nil
    M.index[buffer] = nil
    if M.last == term_id then
      M.last = nil
    end
  end
end

return M
