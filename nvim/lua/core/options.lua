local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = 'yes'

opt.mouse = 'a'
opt.clipboard = 'unnamedplus'

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 200
opt.timeoutlen = 400

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.completeopt = { 'menu', 'menuone', 'noselect' }

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.fillchars = { eob = ' ' }

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
