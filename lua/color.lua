-- ハイライトの設定
local function setup_highlight()
  -- コメント中の `NOTE` などの文字を強調表示する
  -- See : https://zenn.dev/takatom/articles/cbb5a7f7996da0
  vim.api.nvim_set_hl(0, "@text.note", { link = "ModeMsg" })
  vim.api.nvim_set_hl(0, "@text.warning", { link = "Error" })
  vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })

  -- ターミナルバッファの背景色
  vim.api.nvim_set_hl(0, "TermBg", { bg = "#121212" })

  -- NvimTree関連のハイライト設定
  -- 開いているファイルの見た目を下線のみにする
  vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = "NONE", underline = true, bold = false })
  -- 実行可能ファイルを通常と同じ見た目にする
  vim.api.nvim_set_hl(0, "NvimTreeExecFile", { link = "NvimTreeNormal" })
  vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { link = "NvimTreeNormal" })
  vim.api.nvim_set_hl(0, "NvimTreeImageFile", { link = "NvimTreeNormal" })
  -- dotfile / gitignore をグレー表示
  vim.api.nvim_set_hl(0, "NvimTreeGitFileIgnoredHL", { fg = "#6b6b6b" })
  vim.api.nvim_set_hl(0, "NvimTreeGitIgnoredIcon", { fg = "#6b6b6b" })
  vim.api.nvim_set_hl(0, "NvimTreeGitFolderIgnoredHL", { fg = "#6b6b6b" })

  -- window-pickerプラグイン関連のハイライト設定
  vim.api.nvim_set_hl(0, "WindowPickerStatusLine", { fg = "#ededed", bg = "#4493c8", bold = true })
  vim.api.nvim_set_hl(0, "WindowPickerStatusLineNC", { fg = "#ededed", bg = "#4493c8", bold = true })
end

-- ターミナルバッファ関連の設定
local function setup_termbuf()
  local term_mode_grp = vim.api.nvim_create_augroup('TermModeColors', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'TermOpen', 'TermEnter', 'TermLeave' }, {
  group = term_grp,
  callback = function()
    -- ターミナルバッファの場合
    if vim.bo.buftype == 'terminal' then
      vim.opt_local.winhighlight = "Normal:TermBg"
    else
      -- 通常のファイルバッファの場合、設定をクリア
      vim.opt_local.winhighlight = ""
    end
  end,
})
end

local function setup()
  setup_highlight()
  setup_termbuf()

  -- colorschema読み込み時にhighlightがリセットされるのを防ぐ
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = setup_highlight,
  })
end

return {
  setup = setup,
}
