-- Filesystem primitives. Recursive copy/move/trash. No nvim-tree.api use.

local M = {}

M.TRASH_DIR = vim.fn.stdpath("data") .. "/nvim-tree-session-trash"

-- ---------- helpers ----------

local function exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function basename(path)
  return path:match("([^/\\]+)$") or path
end

local function dirname(path)
  return vim.fn.fnamemodify(path, ":h")
end

local function ext_of(name)
  return name:match("(%.[^.]+)$") or ""
end

local function stem_of(name, ext)
  if ext ~= "" then
    return name:sub(1, -(#ext + 1))
  end
  return name
end

-- ---------- stat ----------

function M.is_file(path)
  local st = vim.uv.fs_stat(path)
  return st ~= nil and st.type == "file"
end

function M.is_dir(path)
  local st = vim.uv.fs_stat(path)
  return st ~= nil and st.type == "directory"
end

function M.ensure_dir(path)
  if not exists(path) then
    vim.fn.mkdir(path, "p")
  end
end

-- ---------- unique path ----------
-- file copy.ts, file copy 2.ts, ...
-- folder copy, folder copy 2, ...

function M.unique_path(path)
  if not exists(path) then return path end
  local dir = dirname(path)
  local name = basename(path)
  local ext = ext_of(name)
  local stem = stem_of(name, ext)

  local candidate = dir .. "/" .. stem .. " copy" .. ext
  if not exists(candidate) then return candidate end

  local n = 2
  while true do
    candidate = dir .. "/" .. stem .. " copy " .. n .. ext
    if not exists(candidate) then return candidate end
    n = n + 1
  end
end

function M.unique_dir(path)
  if not exists(path) then return path end
  local parent = dirname(path)
  local name = basename(path)

  local candidate = parent .. "/" .. name .. " copy"
  if not exists(candidate) then return candidate end

  local n = 2
  while true do
    candidate = parent .. "/" .. name .. " copy " .. n
    if not exists(candidate) then return candidate end
    n = n + 1
  end
end

-- ---------- copy (recursive) ----------

local function copy_file(src, dst)
  local lines = vim.fn.readfile(src, "b")
  vim.fn.writefile(lines, dst, "b")
end

local function copy_dir_recursive(src, dst)
  vim.fn.mkdir(dst, "p")
  for _, name in ipairs(vim.fn.readdir(src)) do
    local sp = src .. "/" .. name
    local dp = dst .. "/" .. name
    if M.is_dir(sp) then
      copy_dir_recursive(sp, dp)
    else
      copy_file(sp, dp)
    end
  end
end

function M.copy_path(src, dst)
  if M.is_dir(src) then
    copy_dir_recursive(src, dst)
  else
    M.ensure_dir(dirname(dst))
    copy_file(src, dst)
  end
end

-- ---------- move ----------

function M.move_path(src, dst)
  if not exists(src) then
    error("move_path: source does not exist: " .. src)
  end
  M.ensure_dir(dirname(dst))
  if os.rename(src, dst) then
    return true
  end
  -- cross-device fallback: copy then delete
  M.copy_path(src, dst)
  pcall(vim.fn.system, { "rm", "-rf", src })
  return true
end

-- ---------- trash ----------

local function unique_trash_subdir()
  local n = 1
  while true do
    local stamp = tostring(os.time()) .. "_" .. n
    local p = M.TRASH_DIR .. "/" .. stamp
    if not exists(p) then return p end
    n = n + 1
  end
end

-- Move path into a fresh trash subdir. Returns the subdir path.
function M.trash_path(path)
  local sub = unique_trash_subdir()
  vim.fn.mkdir(sub, "p")
  local name = basename(path)
  local dst = sub .. "/" .. name
  M.move_path(path, dst)
  return sub
end

-- Restore previously-trashed path back to its original location.
function M.restore_path(trash_sub, original_path)
  M.ensure_dir(dirname(original_path))
  local src = trash_sub .. "/" .. basename(original_path)
  M.move_path(src, original_path)
  pcall(vim.fn.system, { "rm", "-rf", trash_sub })
end

-- Wipe and recreate the trash dir (startup + VimLeavePre).
-- Use shell rm -rf: vim.fn.delete segfaults on certain nested layouts.
function M.cleanup_trash()
  pcall(vim.fn.system, { "rm", "-rf", M.TRASH_DIR })
  vim.fn.mkdir(M.TRASH_DIR, "p")
end

return M