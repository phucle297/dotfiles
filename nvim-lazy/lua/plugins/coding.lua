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
    "poljar/typos.nvim",
    config = function()
      require("typos").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local h = require("null-ls.helpers")

      local typos = h.make_builtin({
        name = "typos",
        meta = {
          url = "https://github.com/crate-ci/typos",
          description = "A fast, feature-rich typo checker.",
        },
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "markdown", "text", "lua", "python", "typescript", "javascript" },
        generator_opts = {
          command = "typos",
          args = { "$FILENAME" },
          to_stdin = false,
          from_stderr = false,
          format = "line",
          on_output = function(line)
            local _, _, row, col, message = line:find("([^:]+):(%d+):(%d+):%s+(.+)")
            if row and col and message then
              return {
                row = tonumber(row),
                col = tonumber(col),
                message = message,
                severity = 2,
                source = "typos",
              }
            end
          end,
        },
        factory = h.generator_factory,
      })

      table.insert(opts.sources, typos)
    end,
  },
}
