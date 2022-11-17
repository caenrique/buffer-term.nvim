local M = {}

local terminal = require('buffer-term.terminal')
local config = require('buffer-term.config')

local window_options = {}

local function save_window_options()
  window_options.number = vim.wo.number
  window_options.relativenumber = vim.wo.relativenumber
  window_options.numberwidth = vim.wo.numberwidth
  window_options.signcolumn = vim.wo.signcolumn
end

local function restore_options()
  for key, value in pairs(window_options) do
    vim.wo[key] = value
  end
end

local function configure_terminal()
  if config.terminal_options.no_numbers then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.numberwidth = 1
  end
  vim.wo.signcolumn = 'no'
end

local function start_insert_autocmd(buf, group)
  vim.api.nvim_create_autocmd('BufWinEnter', {
    callback = function()
      vim.cmd('startinsert!')
    end,
    buffer = buf,
    group = group,
  })
  vim.cmd('startinsert!')
end

function M.toggle(term_id)
  -- if term_id does not exists, then create a new terminal
  terminal.last = term_id
  local term = terminal.get(term_id)

  if not term then
    term = terminal.new_terminal(term_id)
  end

  local current_buf = vim.api.nvim_get_current_buf()
  if terminal.lookup(current_buf) then -- is this buffer a terminal?
    -- YES:
    if current_buf == term.terminal_buffer then -- is the same as term_id?
      -- YES: Hide it and restore window options
      terminal.hide(term_id)
      restore_options()
    else
      -- NO: Show it
      terminal.show(term_id)
      configure_terminal()
    end
  else
    -- NO: save window options and Show it
    save_window_options()
    terminal.show(term_id)
    configure_terminal()
  end
end

function M.toggle_last()
  vim.pretty_print(terminal)
  if terminal.last then
    M.toggle(terminal.last)
  end
end

function M.setup(opts)
  config.setup(opts)

  local group = vim.api.nvim_create_augroup('buffer-terminal', { clear = true })

  if config.terminal_options then
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function(args)
        if config.terminal_options.start_insert then
          start_insert_autocmd(args.buf, group)
        end
      end,
      group = group,
    })
  end

  vim.api.nvim_create_autocmd('TermClose', {
    callback = function(args)
      terminal.delete(args.buf)
    end,
    group = group,
  })
end

return M
