-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/
-- Add any additional keymaps here
local map = vim.keymap.set
local nomap = vim.keymap.del
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "gj", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float" })

map({ "n", "v" }, "gh", "^", { desc = "Go to start of line" })
map({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal horizontal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle terminal vertical" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle terminal float" })

map("n", "<C-c>", "<cmd>:%y+<CR>", { noremap = true, silent = true })
map("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
map("v", "<", "<gv")
map("v", ">", ">gv")
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- local opts = { noremap = true, silent = true, buffer = true }
    -- Map <C-k> to move to the above buffer
    map("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
    -- Map <C-j> to move to the below buffer
    map("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
    -- Additional terminal navigation mappings (optional)
    map("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
    map("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
  end,
})
