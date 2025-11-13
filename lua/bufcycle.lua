-- ファイルバッファとターミナルバッファを巡回するユーティリティ

local M = {}

-- ========= 共通ユーティリティ =========
local function is_loaded(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr)
end

local function buftype(bufnr)
  return vim.api.nvim_buf_get_option(bufnr, "buftype")
end

local function index_of(t, val)
  for i, v in ipairs(t) do
    if v == val then return i end
  end
  return nil
end

local function jump_to_buffer(bufnr)
  local target_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(target_win, bufnr)
end

local function cycle(list, delta)
  if #list == 0 then return false end
  local cur = vim.api.nvim_get_current_buf()
  local idx = index_of(list, cur)
  if not idx then
    jump_to_buffer(list[1])
    return true
  end
  local next_idx = ((idx - 1 + delta) % #list) + 1
  jump_to_buffer(list[next_idx])
  return true
end

-- ========= File バッファ収集 =========
local function collect_file_buffers()
  local files = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if is_loaded(b) and buftype(b) == "" then
      table.insert(files, b)
    end
  end
  return files
end

-- ========= Terminal バッファ収集 =========
local function collect_terminal_buffers()
  local list = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if is_loaded(b) and buftype(b) == "terminal" then
      table.insert(list, b)
    end
  end
  return list
end

-- ========= 公開API =========
function M.next_file_buffer()
  local ok = cycle(collect_file_buffers(), 1)
  if not ok then
    vim.notify("No file buffers found", vim.log.levels.ERROR)
  end
end

function M.prev_file_buffer()
  local ok = cycle(collect_file_buffers(), -1)
  if not ok then
    vim.notify("No file buffers found", vim.log.levels.ERROR)
  end
end

function M.next_terminal()
  local ok = cycle(collect_terminal_buffers(), 1)
  if not ok then
    vim.notify("No terminal buffers found", vim.log.levels.ERROR)
  end
end

function M.prev_terminal()
  local ok = cycle(collect_terminal_buffers(), -1)
  if not ok then
    vim.notify("No terminal buffers found", vim.log.levels.ERROR)
  end
end

return M
