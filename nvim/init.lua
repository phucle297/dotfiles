local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.rtp:prepend(lazypath)

require "configs.options"
require "configs.autocmds"

local lazy_config = require "configs.lazy"

require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

require "configs.keymaps"
require "configs.options-after-lazy"
