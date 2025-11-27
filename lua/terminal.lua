--- terminal の shell が busy か（外部コマンド実行中か）を判定する
--- 戻り値:
---   true  = busy（コマンド実行中）
---   false = idle（プロンプト表示中）
---   nil, err = エラー（terminal じゃない等）
local function is_terminal_busy(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local shell_pid = vim.b[bufnr].terminal_job_pid
  if not shell_pid then
    return nil, "not a terminal buffer"
  end

  -- pgrep -P <shell_pid> → 子プロセス一覧
  local cmd = { "pgrep", "-P", tostring(shell_pid) }
  local out = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    return nil, "pgrep failed"
  end

  -- 空行を除いた子プロセス数をカウント
  local count = 0
  for _, line in ipairs(out) do
    if line ~= "" then
      count = count + 1
    end
  end

  -- terminal は必ず1つの child（shell）を持つ
  -- 子プロセスが2つ以上 → busy
  return count >= 2
end

--- idle 判定（busy の反転）
local function is_terminal_idle(bufnr)
  local busy, err = is_terminal_busy(bufnr)
  if busy == nil then
    return nil, err
  end
  return not busy
end

--- terminalがidle状態の時のみcloseする
local function remove_terminal_if_idle(bufnr)
  local busy, err = is_terminal_busy(buf)
  if busy == nil then
    vim.notify("Failed to inspect terminal: " .. (err or "unknown error"), vim.log.levels.WARN)
    return
  end
  if busy then
    vim.notify("Terminal is still running; buffer not closed", vim.log.levels.WARN)
    return
  end
end

return {
  is_terminal_busy = is_terminal_busy,
  is_terminal_idle = is_terminal_idle,
  remove_terminal_if_idle = remove_terminal_if_idle,
}

