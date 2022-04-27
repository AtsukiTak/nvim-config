vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.o.number = true
vim.o.ambiwidth = "double"
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.autoindent = true
vim.bo.expandtab = true -- tabを入力した時にspaceで代替する
vim.wo.list = true -- tab文字などを可視化する

vim.cmd("colorscheme molokai")
