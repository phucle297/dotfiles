return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      -- find
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true iGnore_current_buffer=true<cr>",
        desc = "Buffers",
      },
      { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fw", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>fW", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
    },
  },
}
