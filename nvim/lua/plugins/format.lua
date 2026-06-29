local conform = require 'conform'

local prettier_configs = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.json5',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.js',
  '.prettierrc.cjs',
  '.prettierrc.mjs',
  'prettier.config.js',
  'prettier.config.cjs',
  'prettier.config.mjs',
}

local oxfmt_configs = {
  'oxlint.json',
  '.oxlintrc.json',
}

local biome_configs = {
  'biome.json',
  'biome.jsonc',
}

local function root(bufnr, patterns) return vim.fs.root(bufnr, patterns) end

local function package_has(bufnr, names)
  local pkg_root = root(bufnr, { 'package.json' })
  if not pkg_root then return false end

  local pkg_path = pkg_root .. '/package.json'
  local ok, lines = pcall(vim.fn.readfile, pkg_path)
  if not ok then return false end

  local ok_json, pkg = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not ok_json or type(pkg) ~= 'table' then return false end

  local deps = vim.tbl_extend('force', pkg.dependencies or {}, pkg.devDependencies or {}, pkg.peerDependencies or {}, pkg.optionalDependencies or {})

  for _, name in ipairs(names) do
    if pkg[name] ~= nil or deps[name] ~= nil then return true end
  end

  return false
end

local function web_formatter(bufnr)
  if root(bufnr, oxfmt_configs) then return { 'oxfmt' } end

  if root(bufnr, biome_configs) then return { 'biome' } end

  if root(bufnr, prettier_configs) then return { 'prettier' } end

  if package_has(bufnr, { '@oxc-project/runtime', 'oxc', 'oxlint' }) then return { 'oxfmt' } end

  if package_has(bufnr, { '@biomejs/biome', 'biome' }) then return { 'biome' } end

  if package_has(bufnr, { 'prettier' }) then return { 'prettier' } end

  return { 'prettier' }
end

conform.setup {
  formatters_by_ft = {
    javascript = web_formatter,
    javascriptreact = web_formatter,
    typescript = web_formatter,
    typescriptreact = web_formatter,

    json = web_formatter,
    jsonc = web_formatter,

    css = web_formatter,
    scss = web_formatter,
    html = web_formatter,

    markdown = web_formatter,

    lua = { 'stylua' },
  },

  formatters = {
    oxfmt = {
      cwd = function(_, ctx) return root(ctx.buf, oxfmt_configs) or root(ctx.buf, { 'package.json' }) end,
      require_cwd = false,
    },

    biome = {
      cwd = function(_, ctx) return root(ctx.buf, biome_configs) or root(ctx.buf, { 'package.json' }) end,
      require_cwd = false,
    },

    prettier = {
      cwd = function(_, ctx) return root(ctx.buf, prettier_configs) or root(ctx.buf, { 'package.json' }) end,
      require_cwd = false,
    },
  },

  format_on_save = function(bufnr)
    if vim.b[bufnr].large_file then return end

    return {
      timeout_ms = 3000,
      lsp_format = 'fallback',
    }
  end,
}

vim.keymap.set('n', '<leader>cf', function()
  conform.format {
    async = true,
    lsp_format = 'fallback',
  }
end, { desc = 'Format' })
