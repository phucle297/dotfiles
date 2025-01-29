-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "doomchad",
  hl_override = {
    TelescopeResultsTitle = {
      bg = "#FFCC66",
    },
  },
}
M.ui = {
  cmp = {
    style = "atom_colored",
  },
  statusline = {
    theme = "minimal",
    separator_style = "default",
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "██████╗ ███████╗██████╗ ███╗   ███╗███████╗███████╗███████╗",
    "██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝██╔════╝██╔════╝",
    "██████╔╝█████╗  ██████╔╝██╔████╔██║█████╗  █████╗  ███████╗",
    "██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██╔══╝  ╚════██║",
    "██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████╗███████║",
    "╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝",
  },

  buttons = {
    { "  Find File", "Spc f f", "Telescope find_files" },
    -- { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
    -- { "  Find Word", "Spc f w", "Telescope live_grep" },
    -- { "  Bookmarks", "Spc m a", "Telescope marks" },
    -- { "  Themes", "Spc t h", "Telescope themes" },
  },
}

vim.o.foldcolumn = "0"
return M
