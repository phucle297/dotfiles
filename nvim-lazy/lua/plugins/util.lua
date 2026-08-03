return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown" },
    },
    ft = { "markdown" },
  },
  {
    "oysandvik94/curl.nvim",
    keys = {
      {
        "<leader>cc",
        function()
          require("curl").open_curl_tab()
        end,
        desc = "Open curl tab (scoped)",
      },
      {
        "<leader>co",
        function()
          require("curl").open_global_tab()
        end,
        desc = "Open curl tab (global)",
      },
      {
        "<leader>csc",
        function()
          require("curl").create_scoped_collection()
        end,
        desc = "Create scoped collection",
      },
      {
        "<leader>cgc",
        function()
          require("curl").create_global_collection()
        end,
        desc = "Create global collection",
      },
      {
        "<leader>fsc",
        function()
          require("curl").pick_scoped_collection()
        end,
        desc = "Pick scoped collection",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "gaelph/logsitter.nvim",
    keys = {
      {
        "<leader>lg",
        "<cmd>:lua require('logsitter').log()<CR>",
        desc = "Log current node",
      },
    },
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
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "single",
          width = function()
            return math.floor(vim.o.columns * 0.8)
          end, -- 80% of the screen width
          height = function()
            return math.floor(vim.o.lines * 0.6)
          end, -- 60% of the screen height
          -- width = 200,
          -- height = 50,
          winblend = 3,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "enter" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
