local M = {}

local state = { win = nil, buf = nil }

local severity = {
  [vim.diagnostic.severity.ERROR] = 'E',
  [vim.diagnostic.severity.WARN] = 'W',
  [vim.diagnostic.severity.INFO] = 'I',
  [vim.diagnostic.severity.HINT] = 'H',
}

local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then vim.api.nvim_win_close(state.win, true) end
  state.win = nil
end

function M.render()
  local diagnostics = vim.diagnostic.get(0)

  if #diagnostics == 0 then
    close()
    return
  end

  table.sort(diagnostics, function(a, b) return a.lnum < b.lnum end)

  local lines = {}
  for _, d in ipairs(diagnostics) do
    local line = d.lnum + 1
    local type = severity[d.severity] or '?'
    local msg = d.message:gsub('\n', ' ')
    table.insert(lines, string.format('%s L%d: %s', type, line, msg))
  end

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].buftype = 'nofile'
    vim.bo[state.buf].bufhidden = 'wipe'
    vim.bo[state.buf].modifiable = true
  end

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  local width = math.min(55, vim.o.columns - 4)
  local height = math.min(#lines, 10)

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_config(state.win, {
      relative = 'editor',
      row = 1,
      col = vim.o.columns - width - 2,
      width = width,
      height = height,
    })
    return
  end

  state.win = vim.api.nvim_open_win(state.buf, false, {
    relative = 'editor',
    row = 1,
    col = vim.o.columns - width - 2,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    focusable = false,
    zindex = 60,
  })
end

function M.setup()
  local group = vim.api.nvim_create_augroup('DiagnosticFloatPanel', { clear = true })

  vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter', 'WinResized' }, {
    group = group,
    callback = function() vim.schedule(M.render) end,
  })
end

return M.setup()
