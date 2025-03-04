return {
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "t", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
      { "T", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
      { "gt", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "gaelph/logsitter.nvim",
    event = "BufEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("logsitter").setup({
        path_format = "default",
        prefix = "🚀",
        separator = "->",
      })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
  },
}
