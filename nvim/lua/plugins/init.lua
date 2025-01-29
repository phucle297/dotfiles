return {
  -- Core plugins will go here
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "onedark"
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("mason").setup()
    end,
  },
}
