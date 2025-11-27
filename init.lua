vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- netrwを無効化する
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true
vim.o.ambiwidth = "double"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.expandtab = true -- tabを入力した時にspaceで代替する
vim.o.list = true -- tab文字などを可視化する
vim.o.showcmd = false
vim.o.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize' -- セッション保存
vim.o.showtabline = 2

-- Keymap
require("keymaps").setup()

-- カスタムコマンド
vim.api.nvim_create_user_command("Sqa", function()
  require("safeclose").safe_close()
end, {})

-- Color
require("color").setup()

-- Plugin
require("plugins").setup()

-- ターミナル終了時に、そのウィンドウで空バッファを開き、元のターミナルバッファは消す
local grp = vim.api.nvim_create_augroup("TerminalToBlankOnExit", { clear = true })
vim.api.nvim_create_autocmd("TermClose", {
  group = grp,
  callback = function(args)
    -- このターミナルを表示している全ウィンドウを取得
    local wins = vim.fn.win_findbuf(args.buf) or {}
    for _, win in ipairs(wins) do
      -- 各ウィンドウのコンテキストで空バッファを開く（ウィンドウは残す）
      vim.api.nvim_win_call(win, function()
        vim.cmd.enew()                          -- 新規(空)バッファ
        vim.bo.buftype   = "nofile"             -- スクラッチ化
        vim.bo.bufhidden = "hide"
        vim.bo.swapfile  = false
        vim.bo.buflisted = false
        vim.bo.modifiable = true
        vim.bo.readonly   = false
        vim.bo.filetype   = ""
        -- 必要ならプレースホルダ文字を入れてもOK: vim.api.nvim_buf_set_lines(0, 0, -1, false, {""})
      end)
    end

    -- 置き換えが済んだら、元のターミナルバッファを消す（ウィンドウは消えない）
    vim.schedule(function()
      pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
    end)
  end,
})
