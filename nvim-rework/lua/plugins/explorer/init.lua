-- Explorer: session-only fs action layer for nvim-tree.
-- Public API: setup, create, rename, delete, copy, cut, paste, undo, redo.

require 'plugins.explorer.nvim-tree'

local M = {}

local fs        = require("plugins.explorer.fs")
local history   = require("plugins.explorer.history")
local clipboard = require("plugins.explorer.clipboard")
local marks     = require("plugins.explorer.marks")

-- ---------- helpers ----------

local function api_reload()
  pcall(function() require("nvim-tree.api").tree.reload() end)
  vim.schedule(marks.refresh)
end

local function get_node()
  return require("nvim-tree.api").tree.get_node_under_cursor()
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function prompt(msg, default)
  local val
  -- vim.fn.input uses the cmdline, always renders. vim.ui.input floating
  -- window does not appear from inside a buffer-local mapping in some
  -- terminals/configs.
  local ok = pcall(function()
    val = vim.fn.input(msg .. " ", default or "")
  end)
  if not ok or val == nil then return nil end
  val = trim(val)
  if val == "" then return nil end
  return val
end

local function node_dir(node)
  if node.type == "directory" then
    return node.absolute_path
  end
  return vim.fn.fnamemodify(node.absolute_path, ":h")
end

-- ---------- setup ----------

function M.setup()
  fs.cleanup_trash()
  local grp = vim.api.nvim_create_augroup("ExplorerSessionTrash", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = grp,
    callback = function() fs.cleanup_trash() end,
  })
  marks.setup()
end

-- Run once on require (spec: "when module starts").
M.setup()

-- ---------- actions ----------

function M.create()
  local node = get_node()
  if not node then return end
  local name = prompt("Create (end with / for folder): ")
  if not name then return end

  local is_dir = name:sub(-1) == "/"
  local clean = is_dir and name:sub(1, -2) or name
  if clean == "" then return end

  local base = node_dir(node)
  local path = base .. "/" .. clean

  -- ensure parent dirs exist for nested paths like "foo/bar/a.js"
  fs.ensure_dir(vim.fn.fnamemodify(path, ":h"))

  local create_fn
  if is_dir then
    create_fn = function() vim.fn.mkdir(path, "p") end
  else
    create_fn = function() vim.fn.writefile({}, path) end
  end

  create_fn()
  history.push({
    label = "create " .. (is_dir and "dir " or "file ") .. path,
    ["do"] = create_fn,
    undo = function() vim.fn.delete(path, "rf") end,
  })
  api_reload()
end

function M.rename()
  local node = get_node()
  if not node then return end
  local old = node.absolute_path
  local default = vim.fn.fnamemodify(old, ":t")
  local new_name = prompt("Rename to: ", default)
  if not new_name or new_name == default then return end

  local new_path = vim.fn.fnamemodify(old, ":h") .. "/" .. new_name
  fs.move_path(old, new_path)

  history.push({
    label = "rename " .. old .. " -> " .. new_path,
    ["do"]   = function() fs.move_path(old, new_path) end,
    undo = function() fs.move_path(new_path, old) end,
  })
  api_reload()
end

-- Collect paths from visual selection (V) or single node under cursor.
-- Tries three sources in order: nvim-tree's own visual nodes (most
-- reliable), `<``>` marks via get_nodes_in_range, then cursor node.
local function collect_selected_paths()
  local api = require("nvim-tree.api")
  local core = require("nvim-tree.core")
  local explorer = core.get_explorer()
  if not explorer then return {} end

  local paths, seen = {}, {}
  local function add(p)
    if p and not seen[p] then seen[p] = true; table.insert(paths, p) end
  end

  -- 1. nvim-tree native visual nodes
  local ok_u, utils = pcall(require, "nvim-tree.utils")
  if ok_u and utils and utils.is_visual_mode and utils.is_visual_mode() then
    local ok_n, nodes = pcall(utils.get_visual_nodes)
    if ok_n and nodes then
      for _, n in ipairs(nodes) do
        if n and n.absolute_path then add(n.absolute_path) end
      end
    end
  end

  -- 2. visual marks
  if #paths == 0 then
    local vmode = vim.fn.visualmode()
    local vstart = vim.fn.line("'<")
    local vend = vim.fn.line("'>")
    if vmode ~= "" and vstart > 0 and vend >= vstart then
      local lo, hi = math.min(vstart, vend), math.max(vstart, vend)
      local r_ok, nodes = pcall(function() return explorer:get_nodes_in_range(lo, hi) end)
      if r_ok and nodes then
        for _, n in ipairs(nodes) do
          if n and n.absolute_path then add(n.absolute_path) end
        end
      end
    end
  end

  -- 3. single node under cursor
  if #paths == 0 then
    local node = api.tree.get_node_under_cursor()
    if node and node.absolute_path then add(node.absolute_path) end
  end

  return paths
end

local function confirm_delete(paths)
  local msg
  if #paths == 1 then
    msg = "Delete " .. paths[1] .. "?"
  else
    msg = "Delete " .. #paths .. " items?"
  end
  local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)
  return choice == 1
end

function M.delete()
  local paths = collect_selected_paths()
  if #paths == 0 then return end
  if not confirm_delete(paths) then return end

  local actions = {}
  for _, original in ipairs(paths) do
    local trash_sub
    local function perform_trash()
      trash_sub = fs.trash_path(original)
    end
    perform_trash()

    table.insert(actions, {
      label = "delete " .. original,
      ["do"]   = perform_trash,
      undo = function() fs.restore_path(trash_sub, original) end,
    })
  end
  for _, a in ipairs(actions) do
    history.push(a)
  end
  clipboard.clear()
  api_reload()
end

-- Append paths to existing clipboard if mode matches, else replace.
-- Deduplicates by absolute path.
local function clipboard_append(mode, paths)
  if clipboard.mode == mode then
    for _, p in ipairs(paths) do
      local dup = false
      for _, existing in ipairs(clipboard.paths) do
        if existing == p then dup = true break end
      end
      if not dup then table.insert(clipboard.paths, p) end
    end
  else
    clipboard.set(mode, paths)
  end
end

function M.copy()
  local paths = collect_selected_paths()
  if #paths == 0 then
    vim.notify("Nothing to copy", vim.log.levels.WARN)
    return
  end
  clipboard_append("copy", paths)
  vim.schedule(marks.refresh)
end

function M.cut()
  local paths = collect_selected_paths()
  if #paths == 0 then
    vim.notify("Nothing to cut", vim.log.levels.WARN)
    return
  end
  clipboard_append("cut", paths)
  vim.schedule(marks.refresh)
end

function M.paste()
  if clipboard.is_empty() then
    vim.notify("Clipboard empty", vim.log.levels.INFO)
    return
  end
  local node = get_node()
  if not node then
    vim.notify("No node under cursor", vim.log.levels.WARN)
    return
  end

  local dest_dir = node_dir(node)
  local mode = clipboard.mode
  local sources = clipboard.paths

  for _, src in ipairs(sources) do
    if not vim.uv.fs_stat(src) then
      vim.notify("Source missing: " .. src, vim.log.levels.WARN)
      goto continue
    end
    local name = vim.fn.fnamemodify(src, ":t")
    local raw_dst = dest_dir .. "/" .. name
    local dst
    if fs.is_dir(src) then
      dst = fs.unique_dir(raw_dst)
    else
      dst = fs.unique_path(raw_dst)
    end

    local ok, err
    if mode == "copy" then
      ok, err = pcall(fs.copy_path, src, dst)
      if ok then
        history.push({
          label = "copy " .. src .. " -> " .. dst,
          ["do"]   = function() fs.copy_path(src, dst) end,
          undo = function() vim.fn.delete(dst, "rf") end,
        })
      end
    else -- cut
      ok, err = pcall(fs.move_path, src, dst)
      if ok then
        history.push({
          label = "move " .. src .. " -> " .. dst,
          ["do"]   = function() fs.move_path(src, dst) end,
          undo = function() fs.move_path(dst, src) end,
        })
      end
    end
    if not ok then
      vim.notify("Paste failed for " .. src .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
    ::continue::
  end

  if mode == "cut" then
    clipboard.clear()
  else
    -- copy mode: user said clear array after paste
    clipboard.clear()
  end
  pcall(api_reload)
end

function M.undo()
  history.undo()
  api_reload()
end

function M.redo()
  history.redo()
  api_reload()
end

return M