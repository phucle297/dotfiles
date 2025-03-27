-- File: ~/.config/nvim/lua/config/options.lua
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmode = false
opt.laststatus = 3
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
--
-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath "data" .. "/undodir"
vim.opt.modifiable = true
opt.fileencoding = "utf-8"

-- Performance
opt.hidden = true
opt.history = 100
opt.lazyredraw = true
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menuone,noselect"
opt.pumheight = 10

-- Fold
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldenable = true
-- Copy between vim and system clipboard
opt.clipboard = "unnamedplus"
