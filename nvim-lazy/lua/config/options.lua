-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "telescope"
-- Change theme telescope
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#ffea61", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#ffea61" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#ffea61" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#ffea61" })
