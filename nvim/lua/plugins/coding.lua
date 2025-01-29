return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "html",
          "javascript",
          "json",
          "lua",
          "luap",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
          "rust",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      }
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
  },

  -- -- Surround
  -- {
  --   "kylechui/nvim-surround",
  --   event = "VeryLazy",
  --   config = true,
  -- },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Logsitter
  {
    "gaelph/logsitter.nvim",
    event = "BufEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("logsitter").setup {
        path_format = "default",
        prefix = "🚀",
        separator = "->",
      }
    end,
  },

  -- Searching
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufRead",
    opts = {
      calm_down = true,
      nearest_only = true,
    },
  },
  {
    "ggandor/leap.nvim",
    event = "BufRead",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
