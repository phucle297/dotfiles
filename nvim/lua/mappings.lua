require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del
-- remove key from nvchad
nomap("n", "<leader>wK")
nomap("n", "<leader>wk")

map("n", ";", ":", { desc = "CMD enter command mode" })
-- save on leader w
map("n", "<leader>w", "<cmd>w<CR>", { desc = "general save file", nowait = true })
-- Save with C-s in insert mode
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
-- Select All
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { silent = true })

map("n", "<leader>x", "<cmd>:lua require('nvchad.tabufline').close_buffer()<CR>")
map("n", "<leader>lg", "<cmd>:lua require('logsitter').log()<CR>")

-- Set up terminal mappings
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    -- Map <C-k> to move to the above buffer
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
    -- Map <C-j> to move to the below buffer
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
    -- Additional terminal navigation mappings (optional)
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
  end,
})
-- Setup for leap
vim.keymap.set({ "n", "x", "o" }, "ga", function()
  require("leap.treesitter").select()
end)

-- Linewise.
vim.keymap.set({ "n", "x", "o" }, "gA", 'V<cmd>lua require("leap.treesitter").select()<cr>')

-- toggle nvimtree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree", nowait = true })

--- Tiny diagnostic float
map("n", "gj", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float" })
-- reference
map("n", "<leader>fr", "<cmd> Lspsaga finder <CR>")

-- Leap
-- Unbind `s` and `S` to restore default behavior
vim.keymap.set({ "n", "x", "o" }, "s", "<Nop>", { desc = "Disable override of s" })
vim.keymap.set({ "n", "x", "o" }, "S", "<Nop>", { desc = "Disable override of S" })
vim.keymap.set({ "n", "x", "o" }, "t", function()
  require("leap").leap { target_windows = { vim.fn.win_getid() } }
end, { desc = "Leap" })
