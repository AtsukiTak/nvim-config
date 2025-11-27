-- ハイライトの設定
local function setup_highlight()
  -- コメント中の `NOTE` などの文字を強調表示する
  -- See : https://zenn.dev/takatom/articles/cbb5a7f7996da0
  vim.api.nvim_set_hl(0, "@text.note", { link = "ModeMsg" })
  vim.api.nvim_set_hl(0, "@text.warning", { link = "Error" })
  vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })

  -- ターミナルバッファの背景色
  vim.api.nvim_set_hl(0, "TermBgView", { bg = "#323232" })
  vim.api.nvim_set_hl(0, "TermBgEdit", { bg = "#232323" })
end

-- ターミナルバッファ関連の設定
local function setup_termbuf()
  local term_mode_grp = vim.api.nvim_create_augroup('TermModeColors', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'TermOpen', 'TermEnter', 'TermLeave' }, {
  group = term_grp,
  callback = function()
    -- ターミナルバッファの場合
    if vim.bo.buftype == 'terminal' then
      local mode = vim.api.nvim_get_mode().mode
      -- :terminal modelのとき
      if mode == 't' then
        vim.opt_local.winhighlight = "Normal:TermBgEdit"
      else
        vim.opt_local.winhighlight = "Normal:TermBgView"
      end
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
