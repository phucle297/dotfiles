local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better navigation
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better paste
map("v", "p", '"_dP', { desc = "Better paste" })

--- Tiny diagnostic float
map("n", "gj", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float" })
-- Reference
map("n", "<leader>fr", "<cmd>Lspsaga finder<CR>")

-- Leap
-- Unbind `s` and `S` to restore default behavior
map({ "n", "x", "o" }, "s", "<Nop>", { desc = "Disable override of s" })
map({ "n", "x", "o" }, "S", "<Nop>", { desc = "Disable override of S" })
map({ "n", "x", "o" }, "t", function()
  require("leap").leap({ target_windows = { vim.fn.win_getid() } })
end, { desc = "Leap" })
map({ "n", "x", "o" }, "ga", function()
  require("leap.treesitter").select()
end)
map({ "n", "x", "o" }, "gA", 'V<cmd>lua require("leap.treesitter").select()<cr>')

-- Set up terminal mappings
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    -- Map <C-k> to move to the above buffer
    map("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
    -- Map <C-j> to move to the below buffer
    map("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
    -- Additional terminal navigation mappings (optional)
    map("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
    map("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
  end,
})

-- Select All
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { silent = true })

-- Copy All
vim.api.nvim_set_keymap("n", "<C-c>", "ggVGy", { silent = true })

-- Logsitter
map("n", "<leader>lg", "<cmd>:lua require('logsitter').log()<CR>", { desc = "Log Sitter", nowait = true })

-- Close buffer
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

-- ToggleTerm
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal horizontal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle terminal vertical" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle terminal float" })
