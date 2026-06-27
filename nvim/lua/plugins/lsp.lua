vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    client.server_capabilities.semanticTokensProvider = nil

    local bufnr = event.buf

    local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, desc = desc }) end

    map('gd', vim.lsp.buf.definition, 'Goto Definition')
    map('gr', vim.lsp.buf.references, 'References')
    map('gI', vim.lsp.buf.implementation, 'Implementation')
    map('gy', vim.lsp.buf.type_definition, 'Type Definition')

    map('K', function() vim.lsp.buf.hover { border = 'rounded' } end, 'Hover')

    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>cr', vim.lsp.buf.rename, 'Rename')
  end,
})

vim.lsp.config('lua_ls', {
  settings = { Lua = { diagnostics = { globals = { 'vim', 'MiniFiles' } } } },
})

vim.lsp.config('tailwindcss', {
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
})

vim.lsp.enable {
  'tsgo',
  'jsonls',
  'html',
  'cssls',
  'tailwindcss',
  'lua_ls',
  'clangd',
  'gopls',
  'pyright',
  'rust_analyzer',
  'yamlls',
  'dockerls',
  'docker_compose_language_service',
}
