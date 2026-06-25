local fzf = require 'fzf-lua'

fzf.setup {
  winopts = {
    border = 'rounded',
    preview = { layout = 'horizontal', horizontal = 'right:50%', wrap = true },
  },
  files = {
    fd_opts = table.concat({
      '--color=never',
      '--type f',
      '--hidden',
      '--follow',
      '--exclude .git',
      '--exclude node_modules',
      '--exclude .next',
      '--exclude dist',
      '--exclude build',
    }, ' '),
  },
  grep = {
    rg_opts = table.concat({
      '--column',
      '--line-number',
      '--no-heading',
      '--color=always',
      '--smart-case',
      '--hidden',
      '--glob=!{.git,node_modules,.next,dist,build,lock}',
    }, ' '),
  },
}

-- cwd (current working directory)
vim.keymap.set('n', '<leader>ff', function() fzf.files { cwd = vim.uv.cwd() } end)

vim.keymap.set('n', '<leader>fw', function() vscode_grep { cwd = vim.uv.cwd() } end)

vim.keymap.set('n', '<leader>fo', function() fzf.oldfiles { cwd_only = true } end)

-- project root
vim.keymap.set('n', '<leader>fF', function() fzf.files { git_root = true } end)

vim.keymap.set('n', '<leader>fW', function() fzf.live_grep { git_root = true } end)

vim.keymap.set('n', '<leader>fO', function()
  fzf.oldfiles {
    cwd = fzf.path.git_root(vim.uv.cwd()) or vim.uv.cwd(),
    cwd_only = true,
  }
end)
vim.keymap.set('n', '<leader>,', function() fzf.buffers { sort_mru = true, sort_lastused = true } end)
