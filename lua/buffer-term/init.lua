local M = {}

local terminal = require('buffer-term.terminal')
local config = require('buffer-term.config')

local function configure_terminal()
  vim.pretty_print(config)
  if config.terminal_options.no_numbers then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.numberwidth = 1
  end

  vim.wo.signcolumn = 'no'
  vim.bo.modified = false

  vim.bo.buflisted = config.terminal_options.buf_listed
end

local function start_insert_autocmd(buf)
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

  local group = vim.api.nvim_create_augroup('buffer-terminal', { clear = true })

  if config.terminal_options then
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function(args)
        configure_terminal()
        if config.terminal_options.start_insert then
          start_insert_autocmd(args.buf)
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
