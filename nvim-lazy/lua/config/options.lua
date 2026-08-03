-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- TypeScript LSP: tsgo only (not vtsls / ts_ls).
-- Requires `tsgo` on PATH: npm i -g @typescript/native-preview
-- Also enable extra: lazyvim.plugins.extras.lang.typescript.tsgo
vim.g.lazyvim_ts_lsp = "tsgo"

vim.api.nvim_set_hl(0, "FloatBorder", {
  fg = "NONE",
  bg = "NONE",
})
