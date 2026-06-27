require('better_escape').setup {
  timeout = 350,
  default_mappings = false,

  mappings = {
    i = { j = { j = '<Esc>', k = '<Esc>' }, k = { j = '<Esc>', k = '<Esc>' } },
  },
}

require('flash').setup {
  search = {
    mode = 'exact',
    incremental = true,
    multi_window = false,
  },
  label = {
    after = true,
    before = false,
    style = 'overlay',
    reuse = 'all',
    min_pattern_length = 1,
  },
  highlight = {
    backdrop = true,
    matches = true,
  },
  jump = {
    autojump = false,
  },
}

require('logsitter').setup {
  path_format = 'default',
  prefix = '🚀',
  separator = '->',
}
vim.keymap.set('n', '<leader>lg', function() logsitter.log() end, {
  desc = 'Log current node',
  silent = true,
})
