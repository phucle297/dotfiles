local logo = table.concat({
  -- " ██████╗ ███████╗██████╗ ███╗   ███╗███████╗███████╗███████╗",
  -- " ██╔══██╗██╔════╝██╔══██╗████╗ ████║██╔════╝██╔════╝██╔════╝",
  -- " ██████╔╝█████╗  ██████╔╝██╔████╔██║█████╗  █████╗  ███████╗",
  -- " ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ██╔══╝  ╚════██║",
  -- " ██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗███████╗███████║",
  -- " ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝",

  '      _____         _____',
  '     |  _  |___ ___|     |___ ___ ___',
  '     |   __| -_|  _| | | | -_| -_|_ -|',
  '     |__|  |___|_| |_|_|_|___|___|___|',
}, '\n')
local starter = require 'mini.starter'

local pad = string.rep(' ', 15)

local function new_section(name, action, section) return { name = name, action = action, section = pad .. section } end

starter.setup {
  evaluate_single = true,
  header = logo,
  items = {
    new_section('Find file', function() require('fzf-lua').files { cwd = vim.uv.cwd() } end, 'Fzf'),

    new_section('New file', 'ene | startinsert', 'Built-in'),

    new_section('Recent files', function() require('fzf-lua').oldfiles() end, 'Fzf'),

    new_section('Find text', function() require('fzf-lua').live_grep { cwd = vim.uv.cwd() } end, 'Fzf'),

    new_section('Quit', 'qa', 'Built-in'),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(pad .. '░ ', false),
    starter.gen_hook.aligning('center', 'center'),
  },
}
