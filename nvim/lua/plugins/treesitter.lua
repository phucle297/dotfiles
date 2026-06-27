local treesitter = require 'nvim-treesitter'

treesitter.setup { install_dir = vim.fn.stdpath 'data' .. '/site' }

local parsers = {
  'lua',
  'vim',
  'vimdoc',
  'javascript',
  'typescript',
  'tsx',
  'json',
  'html',
  'css',
  'scss',
  'markdown',
  'markdown_inline',
  'go',
  'gomod',
  'gowork',
  'gosum',
  'c',
  'cpp',
  'rust',
  'python',
}

treesitter.install(parsers)

local ts_indent_enabled = { lua = true, go = true, rust = true, python = true }

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    if vim.b[args.buf].large_file then return end

    pcall(vim.treesitter.start, args.buf)

    if ts_indent_enabled[vim.bo[args.buf].filetype] then pcall(function() vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end) end
  end,
})
