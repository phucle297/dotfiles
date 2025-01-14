local function mergeObjects(...)
  local result = {}
  for _, tbl in ipairs { ... } do
    for _, v in ipairs(tbl) do
      table.insert(result, v)
    end
  end
  return result
end

local ai = {
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require("codecompanion").setup {
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
      }
    end,
  },
}
local logSitter = {
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
}
local conform = {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
}
local lspConfig = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
}
local cmp = {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, conf)
      conf.mapping["<Tab>"] = nil
      conf.mapping["<S-Tab>"] = nil
    end,
  },
}
local lspSaga = {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("lspsaga").setup {
        ui = {
          title = true,
          -- Border type can be single, double, rounded, solid, shadow.
          border = "single",
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "",
          incoming = " ",
          outgoing = " ",
          hover = " ",
          kind = {},
        },
      }
    end,
  },
}
local hlslens = {
  "kevinhwang91/nvim-hlslens",
  event = "BufRead",
  opts = {
    calm_down = true,
    nearest_only = true,
  },
}
local tinyInline = {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- needs to be loaded in first
  },
}
local treeSitter = {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- needs to be loaded in first
  },
}
local leap = {
  {
    "ggandor/leap.nvim",
    event = "BufRead",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
local nvimTree = {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    opts = require "configs.nvimtree",
  },
}
local tsAutoTag = {
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
  },
}
local smoothScroll = {
  {
    "karb94/neoscroll.nvim",
    event = "BufEnter",
    config = function()
      require("neoscroll").setup {}
    end,
  },
}
local git = {
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true, -- if you want to enable the plugin
      message_template = "<author> • <date> • <summary> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}
local noice = {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup {
        cmdline = {
          view = "cmdline_popup", -- Floating command-line
        },
        popupmenu = {
          backend = "cmp", -- Optional integration with nvim-cmp
        },
        -- Enable Wilder only for specific use cases
        filter_options = function()
          if vim.fn.mode() == ":" then
            -- Prefer Wilder for command-line suggestions
            vim.cmd "WilderEnable"
          else
            -- Use Noice for other modes
            vim.cmd "NoiceEnable"
          end
        end,
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
local wilder = {
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    dependencies = {
      "romgrk/fzy-lua-native",
    },
    config = require "configs.wilder",
  },
}
local rainbowSmoothCursor = {
  {
    "gen740/SmoothCursor.nvim",
    event = "BufEnter",
    config = function()
      require("smoothcursor").setup {
        autostart = true, -- Automatically start the smooth cursor
        cursor = "", -- Customize the cursor symbol (e.g., an arrow, dot, etc.)
        texthl = "SmoothCursor", -- Highlight group for the cursor
        linehl = nil, -- Disable line highlight
        type = "default", -- Animation type: "default", "exp", "exp2", or "linear"
        fancy = {
          enable = true, -- Enable fancy cursor trails
          head = { cursor = "◉", texthl = "SmoothCursor" },
          body = {
            { cursor = "•", texthl = "SmoothCursorRed" },
            { cursor = "•", texthl = "SmoothCursorOrange" },
            { cursor = "•", texthl = "SmoothCursorYellow" },
            { cursor = "•", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorBlue" },
            { cursor = "•", texthl = "SmoothCursorIndigo" },
            { cursor = "•", texthl = "SmoothCursorPurple" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" },
        },
        speed = 25, -- Cursor movement speed (higher values are faster)
        intervals = 35, -- Time interval for animation in milliseconds
        threshold = 2, -- Minimum distance for triggering smooth movement
        timeout = 3000, -- Timeout for cursor animation in milliseconds
      }
    end,
  },
}
local ufo = {
  {
    "kevinhwang91/nvim-ufo",
    event = "LspAttach",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
      provider_selector = function(_, __, ___)
        return { "treesitter", "indent" }
      end,
    },
  },
}

return mergeObjects(
  ai,
  cmp,
  conform,
  git,
  hlslens,
  leap,
  logSitter,
  lspConfig,
  lspSaga,
  noice,
  nvimTree,
  rainbowSmoothCursor,
  smoothScroll,
  tinyInline,
  tsAutoTag,
  treeSitter,
  ufo,
  wilder
)
