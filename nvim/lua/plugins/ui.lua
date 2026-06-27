require('noice').setup {
  cmdline = { enabled = true, view = 'cmdline_popup' },

  popupmenu = { enabled = true, backend = 'nui' },

  views = {
    cmdline_popup = {
      position = { row = 5, col = '50%' },
      size = { width = 70, height = 'auto' },
    },

    popupmenu = {
      relative = 'editor',
      position = { row = 8, col = '50%' },
      size = { width = 70, height = 10 },
      border = { style = 'rounded' },
    },
  },

  presets = {
    command_palette = false,
    bottom_search = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
}

require('hlchunk').setup {
  chunk = {
    enable = true,
    style = {
      { fg = '#ffd036' },
      { fg = '#c21f30' },
    },
  },
  line_num = {
    enable = true,
    style = {
      { fg = '#ffd036' },
      { fg = '#c21f30' },
    },
  },
}

require('barbar').setup {}
