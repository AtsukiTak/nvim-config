-- ハイライトの設定
local function setup_highlight()
  -- コメント中の `NOTE` などの文字を強調表示する
  -- See : https://zenn.dev/takatom/articles/cbb5a7f7996da0
  vim.api.nvim_set_hl(0, "@text.note", { link = "ModeMsg" })
  vim.api.nvim_set_hl(0, "@text.warning", { link = "Error" })
  vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })

  -- ターミナルバッファの背景色
  vim.api.nvim_set_hl(0, "TermBgView", { bg = "#323232" })
  vim.api.nvim_set_hl(0, "TermBgEdit", { bg = "#2a2a2a" })
end

-- ターミナルバッファ関連の設定
local function setup_termbuf()
  local term_mode_grp = vim.api.nvim_create_augroup('TermModeColors', { clear = true })

  -- ターミナルバッファを開いた時はTermBgViewを設定
  vim.api.nvim_create_autocmd("TermOpen", {
    group = gterm_mode_grprp,
    pattern = "*",
    callback = function()
      vim.opt_local.winhighlight = "Normal:TermBgView"
    end,
  })

  -- ターミナルモードに入った時はTermBgEditを設定
  vim.api.nvim_create_autocmd("TermEnter", {
    group = gterm_mode_grprp,
    pattern = "*",
    callback = function() vim.opt_local.winhighlight = "Normal:TermBgEdit" end,
  })

  -- ターミナルモードから出た時はTermBgViewを設定
  vim.api.nvim_create_autocmd("TermLeave", {
    group = gterm_mode_grprp,
    pattern = "*",
    callback = function() vim.opt_local.winhighlight = "Normal:TermBgView" end,
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
