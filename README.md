# Buffer Term

Manage terminal buffers and toggle them easily!

## Features

- Create/toggle terminal buffers with `require('buffer-term').toggle(<id>)` where `<id>` can be anything that's a valid lua table key
- Toggle the last used terminal with `require('buffer-term').toggle_last()`
- Default configiguration for the terminal. see [Terminal default options](#terminal-defaults)

## Setup

Using Packer:

```lua
use 'caenrique/buffer-term.nvim'
```

## Default config

```lua
require('buffer-term').setup({
  terminal_options = {
      start_insert = true,
      buf_listed = false,
      no_numbers = true,
  }
})
```

## Example usage

Use it by setting some keymaps. For example the letters in the home row for your left hand:

```lua
local buffer_term = require('buffer-term')

buffer_term.setup() -- default config

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set({ 'n', 't' }, ';a', function() buffer_term.toggle('a') end)
vim.keymap.set({ 'n', 't' }, ';s', function() buffer_term.toggle('s') end)
vim.keymap.set({ 'n', 't' }, ';d', function() buffer_term.toggle('d') end)
vim.keymap.set({ 'n', 't' }, ';f', function() buffer_term.toggle('f') end)
vim.keymap.set({ 'n', 't' }, '<c-;>', buffer_term.toggle_last)
```

## Terminal defaults

By default, these options are set for all terminal buffers using the `TermOpen` event:

```lua
vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.numberwidth = 1
vim.wo.signcolumn = 'no'
vim.bo.modified = false
```

If you don't want any configuration applied set `configure_terminal = false` in the setup function.

## Roadmap

This is a personal project. I created it to use it myself and to fulfill my needs.
Feel free to add issues or pull requests about bugfixes, but I won't add any features that I don't see myself using.

- [ ] add docs
- [ ] statusline integration
- [ ] keepjumps (not available for lua functions yet!)

## Non goals

- Manage windows (split / floating / tabs)
- Send commands to terminal
