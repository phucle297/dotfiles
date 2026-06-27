local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', { callback = function() vim.highlight.on_yank() end })
-- end

-- Optimize for large file
local LARGE_FILE = 1024 * 1024 -- 1 MB
autocmd('BufReadPost', {
  callback = function(args)
    if vim.fn.getfsize(args.file) < LARGE_FILE then return end

    vim.b.large_file = true

    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.cursorline = false
    vim.opt_local.wrap = false

    vim.schedule(function()
      pcall(vim.treesitter.stop, args.buf)
      vim.diagnostic.enable(false, { bufnr = args.buf })
      vim.cmd 'syntax off'
    end)
  end,
})

-- Save remove ^M on window
autocmd('BufWritePre', {
  callback = function(args)
    local view = vim.fn.winsaveview()

    vim.cmd [[%s/\r//ge]]

    vim.fn.winrestview(view)
  end,
})
-- end

-- Highlight cursor line
vim.opt.cursorline = true

local group = vim.api.nvim_create_augroup('ModeCursorLine', { clear = true })

local colors = {
  normal = '#2e3440',
  insert = '#26332f',
  visual = '#332b3f',
  replace = '#3f2b2b',
  command = '#303040',
}

local function set_cursorline(bg) vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg }) end

autocmd({ 'VimEnter', 'ColorScheme', 'ModeChanged' }, {
  group = group,
  callback = function()
    local mode = vim.fn.mode()

    if mode:match 'i' then
      set_cursorline(colors.insert)
    elseif mode:match '[vV\22]' then
      set_cursorline(colors.visual)
    elseif mode:match 'R' then
      set_cursorline(colors.replace)
    elseif mode:match 'c' then
      set_cursorline(colors.command)
    else
      set_cursorline(colors.normal)
    end
  end,
})
-- end

-- Attach LSP to hover
autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover' }))
  end,
})
-- end

-- Flash
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'FlashBackdrop', { fg = '#3b4048' })

    vim.api.nvim_set_hl(0, 'FlashMatch', {
      fg = '#ffffff',
      bg = '#61afef',
      bold = true,
    })

    vim.api.nvim_set_hl(0, 'FlashCurrent', {
      fg = '#282c34',
      bg = '#e5c07b',
      bold = true,
    })

    vim.api.nvim_set_hl(0, 'FlashLabel', {
      fg = '#282c34',
      bg = '#98c379',
      bold = true,
    })
  end,
})

vim.cmd 'doautocmd ColorScheme'
--end
