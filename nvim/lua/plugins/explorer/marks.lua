-- Visual markers on the nvim-tree buffer: "(copy)" / "(cut)" via extmarks.

local M = {}

local ns = vim.api.nvim_create_namespace("explorer_session_marks")

local function setup_highlights()
  vim.api.nvim_set_hl(0, "NvimTreeSessionCopy", { link = "DiffAdded", default = true })
  vim.api.nvim_set_hl(0, "NvimTreeSessionCut", { link = "WarningMsg", default = true })
end

function M.setup()
  setup_highlights()
end

function M.refresh()
  local api = require("nvim-tree.api")
  local core = require("nvim-tree.core")
  local clipboard = require("plugins.explorer.clipboard")

  local win = api.tree.winid and api.tree.winid() or nil
  if not win or not vim.api.nvim_win_is_valid(win) then return end

  local bufnr = vim.api.nvim_win_get_buf(win)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if not api.tree.is_tree_buf(bufnr) then return end

  local copy_paths, cut_paths = {}, {}
  if clipboard.mode == "copy" then
    copy_paths = clipboard.paths
  elseif clipboard.mode == "cut" then
    cut_paths = clipboard.paths
  end
  if #copy_paths == 0 and #cut_paths == 0 then return end

  local explorer = core.get_explorer()
  if not explorer then return end
  local start_line = require("nvim-tree.core").get_nodes_starting_line()
  local ok, nodes_by_line = pcall(function()
    return explorer:get_nodes_by_line(start_line)
  end)
  if not ok or not nodes_by_line then return end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for line, node in pairs(nodes_by_line) do
    if node and node.absolute_path then
      local abs = node.absolute_path
      local label, hl
      for _, p in ipairs(copy_paths) do
        if p == abs then label = "(copy)"; hl = "NvimTreeSessionCopy"; break end
      end
      if not label then
        for _, p in ipairs(cut_paths) do
          if p == abs then label = "(cut)"; hl = "NvimTreeSessionCut"; break end
        end
      end
      if label then
        local row = line - 1
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, 0, {
          virt_text = { { " " .. label, hl } },
          virt_text_pos = "eol",
          hl_mode = "combine",
        })
      end
    end
  end
end

return M