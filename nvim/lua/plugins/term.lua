return
{
  'akinsho/toggleterm.nvim',
  version = "*",
  lazy = false,
  config = function()
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'single',
        width = function() return math.floor(vim.o.columns * 0.8) end,   -- 80% of the screen width
        height = function() return math.floor(vim.o.lines * 0.6) end,    -- 60% of the screen height
        -- width = 200,
        -- height = 50,
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
      }
    }
  end
}
