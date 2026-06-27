local M = {}

M.buf = nil
M.win = nil

local function create_float()
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.85)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then M.buf = vim.api.nvim_create_buf(false, true) end

  M.win = vim.api.nvim_open_win(M.buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })

  if vim.bo[M.buf].buftype ~= 'terminal' then vim.cmd 'terminal' end

  vim.cmd 'startinsert'
end

function M.toggle()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
    return
  end

  create_float()
end

vim.keymap.set('n', '<leader>tf', M.toggle, { desc = 'Toggle float terminal' })
vim.keymap.set('t', '<leader>tf', [[<C-\><C-n><cmd>lua require("config.float_terminal").toggle()<CR>]])

vim.keymap.set('t', '<C-h>', [[<C-\><C-n><cmd>lua require("plugins.term").toggle()<CR>]], { silent = true })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><cmd>lua require("plugins.term").toggle()<CR>]], { silent = true })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><cmd>lua require("plugins.term").toggle()<CR>]], { silent = true })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><cmd>lua require("plugins.term").toggle()<CR>]], { silent = true })
return M
