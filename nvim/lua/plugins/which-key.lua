-- which-key: shows pending keys + descriptions in a popup.
-- Reads `desc` from `vim.keymap.set` automatically; this file adds group labels
-- so prefix keys (e.g. <leader>f) show a category header in the popup.

local wk = require 'which-key'

wk.setup {
  plugins = {
    marks = true, -- show marks
    registers = true, -- show registers
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = false, -- disable `=`/`d`/`y`/`c`/`v` operator presets
    },
  },
  icons = {
    mappings = vim.g.have_nerd_font and {
      ['<leader>'] = { icon = '', color = 'pink' },
    } or nil,
  },
  win = {
    border = 'rounded',
    padding = { 1, 1 },
  },
}

-- Group labels (render as header when prefix is pressed)
local f_group = {
  ['f'] = { icon = '', desc = '+ find/search' }, -- <leader>f …
  -- file-style finders (sub-grouping shown when user presses f)
  ff = { icon = '', desc = 'files (cwd)' },
  fF = { icon = '', desc = 'files (git root)' },
  fw = { icon = '', desc = 'live grep (cwd)' },
  fW = { icon = '', desc = 'live grep (git root)' },
  fo = { icon = '', desc = 'recent (cwd)' },
  fO = { icon = '', desc = 'recent (git root)' },
}

local b_group = {
  ['b'] = { icon = '', desc = '+ buffer' },
  bd = { icon = '', desc = 'wipe buffer' },
  bD = { icon = '', desc = 'wipe + close window' },
}

local g_group = {
  -- window nav (Ctrl-h/j/k/l) doesn't show via <leader>; nothing to register
  ['<A-'] = { icon = '', desc = '+ move' },
  ['<A-j>'] = { desc = 'move down' },
  ['<A-k>'] = { desc = 'move up' },
  ['<C-s>'] = { desc = 'save' },
  ['<C-a>'] = { desc = 'select all' },
  ['<C-c>'] = { desc = 'copy buffer' },
}

wk.add(f_group)
wk.add(b_group)
wk.add(g_group)