local conform = require 'conform'

conform.setup {
  formatters_by_ft = {
    javascript = { 'oxfmt', 'biome', 'prettier', stop_after_first = true },
    javascriptreact = {
      'oxfmt',
      'biome',
      'prettier',
      stop_after_first = true,
    },
    typescript = { 'oxfmt', 'biome', 'prettier', stop_after_first = true },
    typescriptreact = {
      'oxfmt',
      'biome',
      'prettier',
      stop_after_first = true,
    },

    json = { 'biome', 'prettier', stop_after_first = true },
    jsonc = { 'biome', 'prettier', stop_after_first = true },

    css = { 'biome', 'prettier', stop_after_first = true },
    scss = { 'biome', 'prettier', stop_after_first = true },
    html = { 'biome', 'prettier', stop_after_first = true },
    markdown = { 'prettier' },

    lua = { 'stylua' },
  },

  format_on_save = function(bufnr)
    if vim.b[bufnr].large_file then return end

    return { timeout_ms = 2000, lsp_format = 'fallback' }
  end,
}

vim.keymap.set('n', '<leader>cf', function() conform.format { async = true, lsp_format = 'fallback' } end, { desc = 'Format' })
