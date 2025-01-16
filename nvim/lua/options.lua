require "nvchad.options"

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search

-- fold
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldcolumn = "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- Highlight on yank
vim.cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="curSearch", timeout=100})
augroup END
]]

-- Change theme telescope
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#ffea61", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#ffea61" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#ffea61" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#ffea61" })
