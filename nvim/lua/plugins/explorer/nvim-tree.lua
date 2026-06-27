local api = require 'nvim-tree.api'

require('nvim-tree').setup {
  hijack_netrw = true,

  sync_root_with_cwd = true,
  respect_buf_cwd = false,

  update_focused_file = {
    enable = false,
    update_root = false,
  },

  filesystem_watchers = {
    enable = true,
  },

  renderer = {
    highlight_clipboard = 'none',
  },

  on_attach = function(bufnr)
    local explorer = require('plugins.explorer')
    local api = require 'nvim-tree.api'

    api.config.mappings.default_on_attach(bufnr)

    local map = function(lhs, rhs, desc, modes)
      vim.keymap.set(modes or 'n', lhs, rhs, {
        buffer = bufnr,
        silent = true,
        noremap = true,
        desc = 'NvimTree: ' .. desc,
      })
    end

    map('a', explorer.create, 'Create')
    map('r', explorer.rename, 'Rename')
    map('d', explorer.delete, 'Delete')
    -- c/x must work both in normal mode (single node) and visual
    -- mode (multi selection) so V j j c copies the selected range.
    map('c', explorer.copy, 'Copy', { 'n', 'x' })
    map('x', explorer.cut, 'Cut', { 'n', 'x' })
    map('p', explorer.paste, 'Paste')
    map('u', explorer.undo, 'Undo File Action')
    map('<C-r>', explorer.redo, 'Redo File Action')

    map('h', api.node.navigate.parent_close, 'Close Directory')
    map('l', api.node.open.edit, 'Open')
    map('s', api.node.open.horizontal, 'Open: Horizontal Split')
    map('S', api.node.open.vertical, 'Open: Vertical Split')
  end,
}

vim.keymap.set(
  'n',
  '<leader>e',
  function()
    require('nvim-tree.api').tree.toggle {
      path = vim.uv.cwd(),
      focus = true,
      find_file = true,
    }
  end,
  { desc = 'Explorer' }
)