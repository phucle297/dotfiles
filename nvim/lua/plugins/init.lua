vim.pack.add {
  { src = 'https://github.com/navarasu/onedark.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/saghen/blink.lib' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/max397574/better-escape.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/folke/noice.nvim' },
  { src = 'https://github.com/folke/flash.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/shellraining/hlchunk.nvim' },
  { src = 'https://github.com/rebelot/heirline.nvim' },
  { src = 'https://github.com/romgrk/barbar.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/NvChad/nvim-colorizer.lua' },
  { src = 'https://github.com/gaelph/logsitter.nvim' },
  { src = 'https://github.com/kdheepak/lazygit.nvim' },
}

-- build native lib for blink.cmp v2
pcall(function() require('blink.cmp').build():pwait() end)

require 'plugins.theme'
require 'plugins.mini'
require 'plugins.fzf'
require 'plugins.cmp'
require 'plugins.lsp'
require 'plugins.treesitter'
require 'plugins.git'
require 'plugins.format'
require 'plugins.code'
require 'plugins.diagnostic'
require 'plugins.ui'
require 'plugins.highlights'
require 'plugins.explorer'
require 'plugins.heirline'
require 'plugins.term'
