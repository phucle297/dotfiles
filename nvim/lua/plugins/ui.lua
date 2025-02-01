local nvimtreeOpts = {}
local map = vim.keymap.set

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  map("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
  map("n", "<C-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
  map("n", "<C-i>", api.node.show_info_popup, opts "Info")
  map("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
  map("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
  map("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
  map("n", "<C-x>", api.node.open.horizontal, opts "Open: Horizontal Split")
  map("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
  map("n", "<CR>", api.node.open.edit, opts "Open")
  map("n", "<Tab>", api.node.open.preview, opts "Open Preview")
  map("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
  map("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
  map("n", ".", api.node.run.cmd, opts "Run Command")
  map("n", "-", api.tree.change_root_to_parent, opts "Up")
  map("n", "a", api.fs.create, opts "Create")
  map("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
  map("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
  map("n", "c", api.fs.copy.node, opts "Copy")
  map("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
  map("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
  map("n", "]c", api.node.navigate.git.next, opts "Next Git")
  map("n", "d", api.fs.remove, opts "Delete")
  map("n", "D", api.fs.trash, opts "Trash")
  map("n", "E", api.tree.expand_all, opts "Expand All")
  map("n", "e", api.fs.rename_basename, opts "Rename: Basename")
  map("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
  map("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
  map("n", "F", api.live_filter.clear, opts "Clean Filter")
  map("n", "f", api.live_filter.start, opts "Filter")
  map("n", "g?", api.tree.toggle_help, opts "Help")
  map("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
  map("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
  map("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")
  map("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
  map("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
  map("n", "m", api.marks.toggle, opts "Toggle Bookmark")
  map("n", "o", api.node.open.edit, opts "Open")
  map("n", "O", api.node.open.no_window_picker, opts "Open: No Window Picker")
  map("n", "p", api.fs.paste, opts "Paste")
  map("n", "P", api.node.navigate.parent, opts "Parent Directory")
  map("n", "q", api.tree.close, opts "Close")
  map("n", "r", api.fs.rename, opts "Rename")
  map("n", "R", api.tree.reload, opts "Refresh")
  map("n", "s", api.node.open.horizontal, opts "Open: Horizontal Split")
  map("n", "S", api.node.open.vertical, opts "Open: Vertical Split")
  map("n", "U", api.tree.toggle_custom_filter, opts "Toggle Hidden")
  map("n", "W", api.tree.collapse_all, opts "Collapse")
  map("n", "x", api.fs.cut, opts "Cut")
  map("n", "y", api.fs.copy.filename, opts "Copy Name")
  map("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
  map("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
  map("n", "<2-RightMouse>", api.tree.change_root_to_node, opts "CD")
  -- s and S to split and vsplit
  -- END_DEFAULT_ON_ATTACH

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  map("n", "h", api.node.navigate.parent_close, opts "Close Directory")
  map("n", "l", api.node.open.edit, opts "Open")
end
nvimtreeOpts = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },

  on_attach = on_attach,

  update_focused_file = {
    enable = true,
  },
}

return {
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = nvimtreeOpts,
  },
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
      { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
    },
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
  },

  -- Highlight syntax
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "markdown",
      },
      highlight = {
        enable = true, -- Enable syntax highlighting
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true, -- Enable smart indentation
      },
    },
  },

  -- Smooth scroll
  {
    "karb94/neoscroll.nvim",
    event = "BufEnter",
    config = function()
      require("neoscroll").setup {}
    end,
  },
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
        speed = 25,     -- Cursor movement speed (higher values are faster)
        intervals = 35, -- Time interval for animation in milliseconds
        threshold = 2,  -- Minimum distance for triggering smooth movement
        timeout = 3000, -- Timeout for cursor animation in milliseconds
      }
    end,
  },

  -- Wilder
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    dependencies = {
      "romgrk/fzy-lua-native",
    },
    config = function()
      local wilder = require "wilder"
      wilder.setup { modes = { ":", "/", "?" } }

      local highlighters = {
        wilder.pcre2_highlighter(),
        wilder.lua_fzy_highlighter(),
      }

      local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
        border = "rounded",
        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = highlighters,
        highlights = {
          accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
        },
        left = {
          " ",
          wilder.popupmenu_devicons(),
          wilder.popupmenu_buffer_flags {
            flags = " a + ",
            icons = { ["+"] = "", a = "", h = "" },
          },
        },
        right = {
          -- " ",
          wilder.popupmenu_scrollbar(),
        },
      })

      local wildmenu_renderer = wilder.wildmenu_renderer {
        highlighter = highlighters,
        separator = " · ",
        left = { " ", wilder.wildmenu_spinner(), " " },
        right = { " ", wilder.wildmenu_index() },
      }

      wilder.set_option(
        "renderer",
        wilder.renderer_mux {
          [":"] = popupmenu_renderer,
          ["/"] = wildmenu_renderer,
          substitute = wildmenu_renderer,
        }
      )
    end,
  },

  -- Hlchunk
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          style = "#ffea61",
        },
        line_num = {
          enable = false,
          style = "#a18c00",
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}
