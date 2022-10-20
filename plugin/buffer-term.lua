local terminal = require('buffer-term.terminal')
local config = require('buffer-term.config')

local group = vim.api.nvim_create_augroup('buffer-terminal', { clear = true })

local function configure_terminal()
  if config.no_numbers then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.numberwidth = 1
  end

  vim.wo.signcolumn = 'no'
  vim.bo.modified = false

  vim.bo.buflisted = config.buf_listed
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

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    configure_terminal()
    if config.start_insert then
      start_insert_autocmd(args.buf)
    end
  end,
  group = group,
})

vim.api.nvim_create_autocmd('TermClose', {
  callback = function(args)
    terminal.delete(args.buf)
  end,
  group = group,
})
