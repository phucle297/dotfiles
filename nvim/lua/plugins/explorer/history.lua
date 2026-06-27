-- Session-only undo/redo stacks.
-- Each action: { label, do, undo } closures.

local M = {}

M.undo_stack = {}
M.redo_stack = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

function M.push(action)
  table.insert(M.undo_stack, action)
  M.redo_stack = {}
end

function M.undo()
  local action = table.remove(M.undo_stack)
  if not action then
    notify("Nothing to undo")
    return
  end
  local ok, err = pcall(action.undo)
  if not ok then
    notify("Undo failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  table.insert(M.redo_stack, action)
end

function M.redo()
  local action = table.remove(M.redo_stack)
  if not action then
    notify("Nothing to redo")
    return
  end
  local ok, err = pcall(action["do"])
  if not ok then
    notify("Redo failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  table.insert(M.undo_stack, action)
end

function M.clear()
  M.undo_stack = {}
  M.redo_stack = {}
end

return M