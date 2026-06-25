local map = vim.keymap.set

local opts = { noremap = true, silent = true }

local function with_desc(desc) return vim.tbl_extend('force', opts, { desc = desc }) end

-- Move lines
map('n', '<A-j>', ':m .+1<CR>==', with_desc 'Move line down')
map('n', '<A-k>', ':m .-2<CR>==', with_desc 'Move line up')
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', with_desc 'Move line down')
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', with_desc 'Move line up')
map('v', '<A-j>', ":m '>+1<CR>gv=gv", with_desc 'Move selection down')
map('v', '<A-k>', ":m '<-2<CR>gv=gv", with_desc 'Move selection up')
map({ 'n', 'i', 'v', 's' }, '<C-s>', '<Esc><Cmd>update<CR>', with_desc 'Save')
-- end

-- Clipboard
map('n', '<C-c>', function() vim.cmd '%y+' end, with_desc 'Copy entire buffer')

map('n', '<C-a>', 'ggVG', with_desc 'Select all')
-- end

-- Better paste
map('x', 'p', '"_dP', opts)
map('x', 'P', '"_dP', opts)
-- end

-- Window navigation
map('n', '<C-h>', '<C-w>h', with_desc 'Go to left window')
map('n', '<C-j>', '<C-w>j', with_desc 'Go to lower window')
map('n', '<C-k>', '<C-w>k', with_desc 'Go to upper window')
map('n', '<C-l>', '<C-w>l', with_desc 'Go to right window')
-- end

-- Search
map('n', '<Esc>', '<Cmd>nohlsearch<CR><Esc>', with_desc 'Clear search highlight')
map('n', 'n', 'nzzzv', with_desc 'Next search result')
map('n', 'N', 'Nzzzv', with_desc 'Previous search result')
-- end

-- Scrolling
map('n', '<C-d>', '<C-d>zz', with_desc 'Half page down')
map('n', '<C-u>', '<C-u>zz', with_desc 'Half page up')
-- end

-- Editing
map('n', 'J', 'mzJ`z', with_desc 'Join lines')
map('v', '<', '<gv', with_desc 'Indent left')
map('v', '>', '>gv', with_desc 'Indent right')
-- end

-- Hover
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
-- end

-- Flash
map(
  { 'n', 'x', 'o' },
  's',
  function()
    require('flash').jump {
      search = {
        mode = 'exact',
        incremental = true,
      },
      label = {
        min_pattern_length = 1,
      },
      highlight = {
        backdrop = true,
        matches = true,
      },
    }
  end,
  { desc = 'Flash jump' }
)
-- end

-- Buffer barbar
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Next / Previous buffer
map('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<Tab>', '<Cmd>BufferNext<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
-- end
