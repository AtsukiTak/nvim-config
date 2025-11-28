local M = {}

--- terminal の shell が busy か（外部コマンド実行中か）を判定する
--- 戻り値:
---   true  = busy（コマンド実行中）
---   false = idle（プロンプト表示中）
---   nil, err = エラー（terminal じゃない等）
function M.is_terminal_busy(bufnr)
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
function M.is_terminal_idle(bufnr)
  local busy, err = M.is_terminal_busy(bufnr)
  if busy == nil then
    return nil, err
  end
  return not busy
end

-- terminal buffer関連のセットアップ
function M.setup()

  -- Neovim がデフォルトで設定している TermClose の autocommand を消す
  pcall(vim.api.nvim_clear_autocmds, {
    group = "nvim.terminal",
    event = "TermClose",
  })

  -- terminal bufferでexitしたときにwindowを削除しない
  local grp = vim.api.nvim_create_augroup("TerminalToBlankOnExit", { clear = true })
  vim.api.nvim_create_autocmd("TermClose", {
    group = grp,
    callback = function(args)
      -- エラー等でバッファが無効なら何もしない
      if not vim.api.nvim_buf_is_valid(args.buf) then return end

      -- このターミナルを表示している全ウィンドウを取得
      local wins = vim.fn.win_findbuf(args.buf) or {}

      -- 1. 代わりとなる空のスクラッチバッファを「1つだけ」作成する
      --    (false: unlisted, true: scratch buffer)
      local new_buf = vim.api.nvim_create_buf(false, true)

      -- 新しいバッファの設定（ユーザーの好みに合わせる）
      vim.bo[new_buf].bufhidden = "wipe"      -- 隠れたら消す（ゴミを残さない）
      vim.bo[new_buf].buftype = "nofile"
      vim.bo[new_buf].swapfile = false
      vim.bo[new_buf].modifiable = true

      -- 2. 対象の全ウィンドウに対し、強制的に新しいバッファをセットする
      for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_buf(win, new_buf)
        end
      end

      -- 3. 元のターミナルバッファを削除する
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
        end
      end)
    end,
  })
end

return M
