require('blink.cmp').setup {
  snippets = { preset = 'default' },

  appearance = { nerd_font_variant = 'mono' },

  completion = {
    accept = { auto_brackets = { enabled = true } },
    menu = { border = 'rounded', draw = { treesitter = { 'lsp' } } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' },
    },
    ghost_text = { enabled = false },
  },

  signature = { enabled = true, window = { border = 'rounded' } },

  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline', ['<Right>'] = false, ['<Left>'] = false },
    completion = {
      list = { selection = { preselect = false } },
      menu = {
        auto_show = function() return vim.fn.getcmdtype() == ':' end,
        border = 'rounded',
      },
      ghost_text = { enabled = true },
    },
  },

  keymap = {
    preset = 'enter',
    ['<C-y>'] = { 'select_and_accept' },
    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
  },
}
