local M = {}

local BACKDROP_HL = "FloatingBackdrop"

local function open_backdrop()
  -- Define highlight only once so users can override it in their colorscheme.
  if vim.fn.hlexists(BACKDROP_HL) == 0 then
    vim.api.nvim_set_hl(0, BACKDROP_HL, { bg = "#000000", blend = 70 })
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    style = "minimal",
    focusable = false,
    zindex = 1,
  })

  vim.api.nvim_win_set_option(win, "winhl", "Normal:" .. BACKDROP_HL)
  vim.api.nvim_win_set_option(win, "winblend", 50)

  return win
end

M.show = function()
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.8)

  local backdrop_win = open_backdrop()

  local win = vim.api.nvim_open_win(0, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = "HOGEHOGEHOGE",
    title_pos = "center",
    zindex = 2,
  })

  local function close_backdrop()
    if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
      vim.api.nvim_win_close(backdrop_win, true)
      backdrop_win = nil
    end
  end

  -- タイトル更新関数
  local function update_title()
    -- いまフォーカスされてる window がこの float じゃなければ何もしない
    if vim.api.nvim_get_current_win() ~= win then
      return
    end

    local curbuf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(curbuf)
    name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"

    -- title だけ差し替え
    vim.api.nvim_win_set_config(win, {
      title = name,
    })
  end

  local group = vim.api.nvim_create_augroup("FloatTitle_" .. win, { clear = true })

  -- この floating window にフォーカスが来た / 中でバッファが変わったときだけ update
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    callback = function()
      update_title()
    end,
  })

  -- win が閉じられたら autocmd を掃除
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = tostring(win),
    callback = function()
      close_backdrop()
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })

  -- 最初のタイトルも設定しておく
  update_title()
end

return M
