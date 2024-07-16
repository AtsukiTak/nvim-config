vim.cmd("colorscheme molokai")

-- コメント中の `NOTE` などの文字を強調表示する
-- See : https://zenn.dev/takatom/articles/cbb5a7f7996da0
vim.api.nvim_set_hl(0, "@text.note", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "@text.warning", { link = "Error" })
vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })

