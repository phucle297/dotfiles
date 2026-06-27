local hl = vim.api.nvim_set_hl

hl(0, 'BlinkCmpMenu', { bg = '#1e222a' })
hl(0, 'BlinkCmpMenuBorder', { fg = '#61afef', bg = '#1e222a' })
hl(0, 'BlinkCmpMenuSelection', { bg = '#3e4452', fg = '#ffffff', bold = true })
hl(0, 'BlinkCmpLabel', { fg = '#abb2bf' })
hl(0, 'BlinkCmpLabelMatch', { fg = '#61afef', bold = true })
hl(0, 'BlinkCmpKind', { fg = '#98c379' })
hl(0, 'BlinkCmpKindText', { fg = '#98c379' })
hl(0, 'BlinkCmpKindFunction', { fg = '#c678dd' })
hl(0, 'BlinkCmpKindMethod', { fg = '#c678dd' })
hl(0, 'BlinkCmpKindVariable', { fg = '#e5c07b' })

hl(0, 'HopNextKey', {
  fg = '#ffffff',
  bg = '#61afef',
  bold = true,
})

hl(0, 'HopNextKey1', {
  fg = '#98c379',
  bold = true,
})

hl(0, 'HopNextKey2', {
  fg = '#e5c07b',
})

hl(0, 'HopUnmatched', {
  fg = '#5c6370',
})

hl(0, 'NvimTreeCopiedHL', { link = 'Visual' })
hl(0, 'NvimTreeCutHL', { link = 'ErrorMsg' })
