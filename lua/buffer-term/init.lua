local M = {}

local config = require('buffer-term.config')
local window = require('buffer-term.window')

local terminal = require('buffer-term.terminal')
local state = require('buffer-term.state')

---Toggle the terminal buffer associated with the key `term_id`
---@param term_id any
---@usage `require("buffer-term").toggle('a')`
function M.toggle(term_id)
  if not term_id then return end

  -- if term_id does not exists, then create a new terminal
  local term = state.find_by_id(term_id)

  if not term then
    term = terminal:new(term_id)
  end

  state.last = term.id

  local current_buf = vim.api.nvim_get_current_buf()
  if state.find_by_buffer(current_buf) then -- is this buffer a terminal?
    -- YES:
    if current_buf == term.terminal_buffer then -- is the same as term_id?
      -- YES: Hide it and restore window options
      term:hide(state)
      window.restore_options()
    else
      -- NO: Show it
      term:show(state)
      window.configure_terminal()
    end
  else
    -- NO: save window options and Show it
    window.save_options()
    term:show(state)
    window.configure_terminal()
  end
end

---Toggle the last terminal buffer used
---@usage `require("buffer-term").toggle_last()`
function M.toggle_last()
  M.toggle(state.last)
end

---Initialize the required configurations and hooks for the plugin
function M.setup(opts)
  config.setup(opts)

  local group = vim.api.nvim_create_augroup('buffer-terminal', { clear = true })

  if config.terminal_options then
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function(args)
        if config.terminal_options.start_insert then
          vim.api.nvim_create_autocmd('BufWinEnter', {
            callback = function()
              vim.cmd('startinsert!')
            end,
            buffer = args.buf,
            group = group,
          })
          vim.cmd('startinsert!')
        end
      end,
      group = group,
    })
  end

  vim.api.nvim_create_autocmd('TermClose', {
    callback = function(args)
      state.delete(args.buf)
    end,
    group = group,
  })
end

return M
