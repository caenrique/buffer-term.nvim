local config = require('buffer-term.config')

local M = {}

M.window_options = {}

---Saves the window local options we changed to restore them later
function M.save_options()
  M.window_options.number = vim.wo.number
  M.window_options.relativenumber = vim.wo.relativenumber
  M.window_options.numberwidth = vim.wo.numberwidth
  M.window_options.signcolumn = vim.wo.signcolumn
end

---Restores the window options
function M.restore_options()
  for key, value in pairs(M.window_options) do
    vim.wo[key] = value
  end
end

---Apply the window local options for the terminal window
function M.configure_terminal()
  if config.terminal_options.no_numbers then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.numberwidth = 1
  end
  vim.wo.signcolumn = 'no'
end

return M
