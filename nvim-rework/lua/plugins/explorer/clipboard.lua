-- In-memory clipboard. No disk persistence.

local M = {}

M.mode = nil      -- "copy" | "cut" | nil
M.paths = {}      -- absolute paths

function M.set(mode, paths)
  M.mode = mode
  M.paths = paths or {}
end

function M.clear()
  M.mode = nil
  M.paths = {}
end

function M.is_empty()
  return M.mode == nil or #M.paths == 0
end

return M