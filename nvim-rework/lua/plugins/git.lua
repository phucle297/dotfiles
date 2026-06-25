require('gitsigns').setup {
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
  },

  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 400,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, desc = desc }) end

    map(']h', gs.next_hunk, 'Next hunk')
    map('[h', gs.prev_hunk, 'Prev hunk')
    map('<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('<leader>hb', gs.blame_line, 'Blame line')
    map('<leader>hB', gs.toggle_current_line_blame, 'Toggle blame')
  end,
}
