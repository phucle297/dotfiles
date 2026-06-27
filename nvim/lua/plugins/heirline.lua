-- heirline.nvim: lualine-like statusline
local ok, heirline = pcall(require, 'heirline')
if not ok then return end

local conditions = require 'heirline.conditions'

local CTRL_V = '\022'
local CTRL_S = '\019'

local nerd = vim.g.have_nerd_font == true
local ICONS = {
  branch = nerd and '' or 'Git:',
  diff_a = nerd and '' or '+',
  diff_c = nerd and '' or '~',
  diff_d = nerd and '' or '-',
  diag_e = nerd and '' or 'E',
  diag_w = nerd and '' or 'W',
  diag_i = nerd and '' or 'I',
  diag_h = nerd and '󰌵' or 'H',
  modified = nerd and '●' or '[+]',
  readonly = nerd and '' or '[RO]',
}

local palette = {
  bg = '#111318',
  bg2 = '#16191f',
  bg3 = '#2c313c',

  fg = '#f5f7fa',

  fg_dim = '#d7dae0',

  normal = '#61afef',
  insert = '#98c379',
  visual = '#ffd036',
  visual_line = '#d19a66',

  replace = '#e06c75',
  command = '#c678dd',

  terminal = '#56b6c2',
  select = '#d19a66',

  mode_fg = '#0b0d10',
  inactive = '#5c6370',

  error = '#ff6b6b',
  warn = '#ffd036',
  info = '#61afef',
  hint = '#c678dd',
}

local mode_colors = {
  n = palette.normal,
  i = palette.insert,
  v = palette.visual,
  V = palette.visual_line,

  [CTRL_V] = palette.visual_line,
  c = palette.command,
  R = palette.replace,

  s = palette.select,

  S = palette.select,
  [CTRL_S] = palette.select,
  t = palette.terminal,
}

local mode_names = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  V = 'V-LINE',
  [CTRL_V] = 'V-BLOCK',
  c = 'COMMAND',
  R = 'REPLACE',
  s = 'SELECT',
  S = 'S-LINE',
  [CTRL_S] = 'S-BLOCK',
  t = 'TERMINAL',
}

local function set_hl(name, opts) vim.api.nvim_set_hl(0, name, opts) end

set_hl('HeirlineNormal', { fg = palette.fg, bg = palette.bg, bold = true })
set_hl('HeirlineInactive', { fg = palette.fg_dim, bg = palette.bg3, italic = true })
set_hl('HeirlineGit', { fg = palette.terminal, bg = palette.bg, bold = true })
set_hl('HeirlineLsp', { fg = palette.command, bg = palette.bg, bold = true })
set_hl('HeirlineFiletype', { fg = palette.insert, bg = palette.bg, bold = true })
set_hl('HeirlineEncoding', { fg = palette.visual, bg = palette.bg, bold = true })
set_hl('HeirlineProgress', { fg = palette.terminal, bg = palette.bg, italic = true })

set_hl('HeirlineDiagERROR', { fg = palette.error, bg = palette.bg, bold = true })
set_hl('HeirlineDiagWARN', { fg = palette.warn, bg = palette.bg, bold = true })
set_hl('HeirlineDiagINFO', { fg = palette.info, bg = palette.bg, bold = true })
set_hl('HeirlineDiagHINT', { fg = palette.hint, bg = palette.bg, bold = true })

local Space = { provider = ' ' }
local Align = { provider = '%=' }

local progress_msg = ''

vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('HeirlineProgressGroup', { clear = true }),
  callback = function(ev)
    local v = ev.data and ev.data.params and ev.data.params.value
    if not v then return end

    if v.kind == 'end' then
      progress_msg = ''
    elseif v.kind == 'begin' then
      progress_msg = v.title or ''
    elseif v.kind == 'report' then
      progress_msg = v.title or v.message or ''

      if v.percentage then progress_msg = progress_msg .. ' ' .. math.floor(v.percentage) .. '%' end
    end
  end,
})

local ViMode = {
  condition = conditions.is_active,
  init = function(self) self.mode = vim.fn.mode(1) end,
  provider = function(self)
    local name = mode_names[self.mode] or self.mode
    if vim.o.paste then name = name .. '-P' end
    return ' ' .. name .. ' '
  end,
  hl = function(self)
    return {
      fg = palette.mode_fg,
      bg = mode_colors[self.mode] or palette.normal,
      bold = true,
    }
  end,
  update = { 'ModeChanged', 'OptionSet' },
}

local GitBranch = {
  condition = function(self)
    self._git_head = vim.b.gitsigns_head
    return conditions.is_active() and self._git_head and self._git_head ~= ''
  end,
  provider = function(self) return ' ' .. ICONS.branch .. ' ' .. self._git_head .. ' ' end,
  hl = 'HeirlineGit',
  update = { 'BufEnter', 'BufWritePost' },
}

local GitDiff = {
  condition = conditions.is_active,

  init = function(self) self._dict = vim.b.gitsigns_status_dict or {} end,
  provider = function(self)
    local d = self._dict
    local parts = {}

    if (d.added or 0) > 0 then parts[#parts + 1] = ICONS.diff_a .. ' ' .. d.added end
    if (d.changed or 0) > 0 then parts[#parts + 1] = ICONS.diff_c .. ' ' .. d.changed end
    if (d.removed or 0) > 0 then parts[#parts + 1] = ICONS.diff_d .. ' ' .. d.removed end

    return #parts > 0 and (' ' .. table.concat(parts, ' ') .. ' ') or ''
  end,
  hl = { fg = palette.fg_dim, bg = palette.bg, bold = true },
  update = { 'BufEnter', 'BufWritePost' },
}

local FileName = {
  condition = conditions.is_active,
  init = function(self)
    local name = vim.api.nvim_buf_get_name(0)
    self._fname = vim.fn.fnamemodify(name, ':t')
    if self._fname == '' then self._fname = '[No Name]' end

    self._icon = ''
    local ok_devicons, devicons = pcall(require, 'nvim-web-devicons')
    if ok_devicons then
      local icon = devicons.get_icon(self._fname, vim.fn.fnamemodify(self._fname, ':e'), { default = true })
      if icon then self._icon = icon .. ' ' end
    end

    self._mod = vim.bo.modified

    self._ro = vim.bo.readonly
  end,
  provider = function(self)
    return ' ' .. self._icon .. (self._mod and ICONS.modified .. ' ' or '') .. (self._ro and ICONS.readonly .. ' ' or '') .. self._fname .. ' '
  end,
  hl = { fg = palette.fg, bg = palette.bg, bold = true },
  update = { 'BufEnter', 'BufFilePost', 'BufWritePost', 'TextChanged', 'TextChangedI' },
}

local Diagnostics = {

  condition = conditions.has_diagnostics,
  init = function(self) self._counts = vim.diagnostic.count(0) or {} end,
  provider = function(self)
    local icons = {
      ERROR = ICONS.diag_e,
      WARN = ICONS.diag_w,
      INFO = ICONS.diag_i,

      HINT = ICONS.diag_h,
    }

    local out = {}
    for _, sev in ipairs { 'ERROR', 'WARN', 'INFO', 'HINT' } do
      local n = self._counts[vim.diagnostic.severity[sev]] or 0
      if n > 0 then out[#out + 1] = '%#HeirlineDiag' .. sev .. '# ' .. icons[sev] .. ' ' .. n .. ' %#HeirlineNormal#' end
    end

    return #out > 0 and table.concat(out, '') or ''
  end,
  update = { 'DiagnosticChanged', 'BufEnter', 'LspAttach', 'LspDetach' },
}

local LspName = {
  condition = conditions.lsp_attached,
  init = function(self)
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
      names[#names + 1] = client.name
    end
    self._lsp = names
  end,
  provider = function(self) return self._lsp and #self._lsp > 0 and (' ' .. table.concat(self._lsp, '/') .. ' ') or '' end,
  hl = 'HeirlineLsp',
  update = { 'LspAttach', 'LspDetach', 'BufEnter' },
}

local FileType = {
  condition = conditions.is_active,
  init = function(self) self._ft = vim.bo.filetype end,
  provider = function(self) return self._ft ~= '' and (' ' .. self._ft:upper() .. ' ') or '' end,
  hl = 'HeirlineFiletype',
  update = { 'FileType', 'BufEnter' },
}

local Encoding = {
  condition = conditions.is_active,

  init = function(self)
    self._enc = vim.bo.fileencoding
    if self._enc == '' then self._enc = 'utf-8' end
  end,
  provider = function(self) return ' ' .. self._enc .. ' ' end,
  hl = 'HeirlineEncoding',
  update = { 'BufEnter', 'OptionSet' },
}

local Location = {
  condition = conditions.is_active,
  provider = ' %l:%c ',
  hl = { fg = palette.fg, bg = palette.bg, bold = true },
  update = { 'CursorMoved', 'CursorMovedI', 'BufEnter' },
}

local Progress = {
  condition = function() return progress_msg ~= '' end,
  provider = function() return ' ' .. progress_msg .. ' ' end,
  hl = 'HeirlineProgress',
  update = { 'LspProgress' },
}

local InactiveBlock = {
  condition = conditions.is_not_active,
  init = function(self)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    self._iname = name ~= '' and name or '[No Name]'
  end,
  provider = function(self) return ' ' .. self._iname .. ' ' end,
  hl = 'HeirlineInactive',
  update = { 'BufEnter', 'BufFilePost' },
}

local StatusLine = {
  hl = function() return conditions.is_active() and 'HeirlineNormal' or 'HeirlineInactive' end,

  ViMode,
  Space,
  GitBranch,
  GitDiff,

  Align,

  FileName,

  Align,

  Diagnostics,
  Space,
  LspName,
  FileType,
  Encoding,
  Location,
  Progress,

  InactiveBlock,
}

heirline.setup {
  statusline = StatusLine,
}

_G.HeirlineStatusLine = StatusLine
