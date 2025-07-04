return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- enabled: false
    opts = {
      filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
      },
      window = {
        mappings = {
          -- remove default copy
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
        },
      },
    },
  },
  ---@type LazySpec
  -- {
  --   "mikavilpas/yazi.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     -- check the installation instructions at
  --     -- https://github.com/folke/snacks.nvim
  --     "folke/snacks.nvim",
  --   },
  --   keys = {
  --     -- 👇 in this section, choose your own keymappings!
  --     {
  --       "<leader>e",
  --       mode = { "n", "v" },
  --       "<cmd>Yazi<cr>",
  --       desc = "Open yazi at the current file",
  --     },
  --   },
  --   ---@type YaziConfig | {}
  --   opts = {
  --     -- if you want to open yazi instead of netrw, see below for more info
  --     open_for_directories = false,
  --     keymaps = {
  --       show_help = "g?",
  --     },
  --   },
  --   -- 👇 if you use `open_for_directories=true`, this is recommended
  --   init = function()
  --     -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  --     -- vim.g.loaded_netrw = 1
  --     vim.g.loaded_netrwPlugin = 1
  --   end,
  -- },
}
