local function on_attach(bufnr)
    local api = require("nvim-tree.api")
    local adaptive_width = false

    api.map.on_attach.default(bufnr)
    vim.keymap.set("n", "l", api.node.open.edit, { buffer = bufnr, desc = "nvim-tree: Open" })
    vim.keymap.set("n", "s", api.node.open.vertical, { buffer = bufnr, desc = "nvim-tree: Open: Vertical Split" })
    vim.keymap.set("n", "S", api.node.open.horizontal, { buffer = bufnr, desc = "nvim-tree: Open: Horizontal Split" })

    vim.keymap.set("n", "e", function()
        adaptive_width = not adaptive_width
        if adaptive_width then
            api.tree.resize({ width = { min = 30 } })
            require("nvim-tree.view").grow_from_content()
        else
            api.tree.resize()
        end
    end, { buffer = bufnr, desc = "nvim-tree: Toggle adaptive width" })
end

local function set_clipboard_highlights()
    local copied = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false })
    local cut = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })

    vim.api.nvim_set_hl(0, "NvimTreeCopiedHL", { fg = copied.fg, underdouble = true, sp = copied.fg })
    vim.api.nvim_set_hl(0, "NvimTreeCutHL", { fg = cut.fg, underdouble = true, sp = cut.fg })
end

return {
    "nvim-tree/nvim-tree.lua",
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
    opts = {
        on_attach = on_attach,
        filters = { dotfiles = false },
        disable_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        view = {
            width = 30,
            preserve_window_proportions = true,
        },
        renderer = {
            root_folder_label = false,
            highlight_git = true,
            indent_markers = { enable = true },
            icons = {
                glyphs = {
                    default = "󰈚",
                    folder = {
                        default = "",
                        empty = "",
                        empty_open = "",
                        open = "",
                        symlink = "",
                    },
                    git = { unmerged = "" },
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        set_clipboard_highlights()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("NvimTreeClipboardHighlights", { clear = true }),
            callback = set_clipboard_highlights,
        })
    end,
}
